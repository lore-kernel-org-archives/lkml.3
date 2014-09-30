Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbaI3DzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 23:55:10 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:36175 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaI3DzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 23:55:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>
References: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>
Date: Mon, 29 Sep 2014 20:55:07 -0700
X-Google-Sender-Auth: SZz6H0qEhc7Xg8PekyV0mpCzL4I
Message-ID: <CA+55aFwfTeoCJDs6RJg++0SY=SsPrn7Y_Y0Ag_TsNvd6Vsj1Eg@mail.gmail.com>
Subject: Re: [PATCH 0/5] fuse: handle release synchronously (v4)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        avati@gluster.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 5:05 AM, Maxim Patlasov <MPatlasov@parallels.com> wrote:
>
> There is a long-standing demand for synchronous behaviour of fuse_release:

That's just complete bullshit.

The fact is, release() is not synchronous. End of story.

If you want to catch "close()" synchronously, you use flush(). The two
are NOT the same, and never will be, and never should be confused.

"release()" happens at some random time (but only once), and cannot
return an error.

"flush()" happens synchronously at close() time, and can return an error.

Anybody who confuses the two is *wrong*.

It sounds like somebody wants to use "flush()" in fuse.  But please
don't mistake that for "release". It's different.

So please kill this "FOPEN_SYNC_RELEASE" thing with fire. It's crazy,
it's wrong, it's stupid. It must die.

               Linus
