Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaJXHYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:24:48 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:39112 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaJXHYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:24:46 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20141024032422.GI7996@ZenIV.linux.org.uk>
References: <20141023232539.GA4662@tucsk.piliscsaba.szeredi.hu>
	<20141024022055.GH7996@ZenIV.linux.org.uk>
	<20141024032422.GI7996@ZenIV.linux.org.uk>
Date: Fri, 24 Oct 2014 09:24:45 +0200
Message-ID: <CAJfpegt-X_Cd8B5H65keshhhuwH2-HPpaBC30atKeS3QjaariA@mail.gmail.com>
Subject: Re: [GIT PULL] overlay filesystem v25
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 5:24 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Oct 24, 2014 at 03:20:55AM +0100, Al Viro wrote:
>> Why the hell do you hold ->i_mutex across the entire opening of underlying
>> directory?  All you need is to serialize one assignment; the side that loses
>> the race will simply fput() what it opened...

The reason I didn't do your "fix" is that it

 - adds more lines than it takes,

 - I wasn't sure at all if the lockless access is actually correct
without the ACCESS_ONCE and all the memory barrier magic that might be
necessary on weird architectures.

The rest of the changes look OK.

Thanks,
Miklos
