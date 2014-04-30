Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbaD3UX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:23:29 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:55267 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758872AbaD3UX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:23:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140430195918.GS18016@ZenIV.linux.org.uk>
References: <20140429232013.GM18016@ZenIV.linux.org.uk>
	<20140430023142.GN18016@ZenIV.linux.org.uk>
	<CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
	<20140430040436.GO18016@ZenIV.linux.org.uk>
	<20140430154958.GC3113@tucsk.piliscsaba.szeredi.hu>
	<20140430160345.GP18016@ZenIV.linux.org.uk>
	<CAJfpegu+q3sT=8==9K5t4=qeJH2azFcBGeMXUtK3LVSEEzXTUA@mail.gmail.com>
	<20140430183650.GQ18016@ZenIV.linux.org.uk>
	<CAJfpegu+=zidycJwcBPjuDLP-ZnGisOGQpD8GKhD-Wz6eNzd9g@mail.gmail.com>
	<20140430190227.GR18016@ZenIV.linux.org.uk>
	<20140430195918.GS18016@ZenIV.linux.org.uk>
Date: Wed, 30 Apr 2014 13:23:26 -0700
X-Google-Sender-Auth: JMF5pR0k9u-SpaG5d3E4JAAvrlQ
Message-ID: <CA+55aFxe4HKHiWbarfwtww9=WUgfAmk+Cf3G7tdBB19uMdjbEg@mail.gmail.com>
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

On Wed, Apr 30, 2014 at 12:59 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Another thing: I don't like what's going on with freeing vs. ->d_lock there.
> Had that been a mutex, we'd definitely get a repeat of "vfs: fix subtle
> use-after-free of pipe_inode_info".  The question is, can spin_unlock(p)
> dereference p after another CPU gets through spin_lock(p)?  Linus?

spin_unlock() *should* be safe wrt that issue.

But I have to say, I think paravirtualized spinlocks may break that.
They do all kinds of "kick waiters" after releasing the lock.

Doesn't the RCU protection solve that, though? Nobody should be
releasing the dentry under us, afaik..

            Linus
