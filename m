Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaIXTUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:20:41 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63368 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaIXTUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:20:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140924185521.GC7996@ZenIV.linux.org.uk>
References: <1411582473-29184-1-git-send-email-sem@altlinux.org>
	<20140924185521.GC7996@ZenIV.linux.org.uk>
Date: Wed, 24 Sep 2014 12:20:38 -0700
X-Google-Sender-Auth: EZsYuArZ2PdTk5suxZocIc_2XzI
Message-ID: <CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mikhail Efremov <sem@altlinux.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:55 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Yecchhhh...  Applied, but it's very ugly.  Oh, well - regression is
> regression, and I don't see a cleaner fix at the moment.  If I don't
> manage to come up with anything prettier, to Linus it goes in tonight
> pull request ;-/

Please don't. That thing is too ugly to exist. It also looks
completely and utterly buggy. There's no way I'm taking it. If
switch-names is suddenly conditional, what the f*ck happens to the
name hash which is unconditionally done with a swap() right
afterwards.

There's no way that patch is correct.

           Linus
