Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536AbaD3U5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:57:09 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:38706 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759361AbaD3U5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:57:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140430203823.GT18016@ZenIV.linux.org.uk>
References: <CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
	<20140430040436.GO18016@ZenIV.linux.org.uk>
	<20140430154958.GC3113@tucsk.piliscsaba.szeredi.hu>
	<20140430160345.GP18016@ZenIV.linux.org.uk>
	<CAJfpegu+q3sT=8==9K5t4=qeJH2azFcBGeMXUtK3LVSEEzXTUA@mail.gmail.com>
	<20140430183650.GQ18016@ZenIV.linux.org.uk>
	<CAJfpegu+=zidycJwcBPjuDLP-ZnGisOGQpD8GKhD-Wz6eNzd9g@mail.gmail.com>
	<20140430190227.GR18016@ZenIV.linux.org.uk>
	<20140430195918.GS18016@ZenIV.linux.org.uk>
	<CA+55aFxe4HKHiWbarfwtww9=WUgfAmk+Cf3G7tdBB19uMdjbEg@mail.gmail.com>
	<20140430203823.GT18016@ZenIV.linux.org.uk>
Date: Wed, 30 Apr 2014 13:57:05 -0700
X-Google-Sender-Auth: 8Ybo29KOjK0UbS_tQOOpb0K6Whc
Message-ID: <CA+55aFyqqwrtv7ifTYVK943qm2OJOF8aF1y6apMSwjG93T=ztA@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 1:38 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> We do not (and cannot) call dentry_kill() with rcu_read_lock held - it can
> trigger any amount of IO, for one thing.  We can take it around the
> couple of places where do that spin_unlock(&dentry->d_lock) (along with
> setting DCACHE_RCUACCESS) - that's what I'd been refering to.

Just the last spin_unlock() would be the case that matters, if the
spin_unlock() is done on something that could be freed immediately and
the lock protects and is inside the entity that gets freed.

>   BTW, is there any convenient
> way to tell git commit --amend to update the commit date?  Something
> like --date=now would be nice, but it isn't accepted...

--date="$(date)" works.

The "--date" thing doesn't take the nice "git approxidate" strings,
maybe it should. So you have to give it a "real" date.

              Linus
