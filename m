Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823AbaD3XFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 19:05:04 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:37236 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759803AbaD3XE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 19:04:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140430221238.GV18016@ZenIV.linux.org.uk>
References: <20140430160345.GP18016@ZenIV.linux.org.uk>
	<CAJfpegu+q3sT=8==9K5t4=qeJH2azFcBGeMXUtK3LVSEEzXTUA@mail.gmail.com>
	<20140430183650.GQ18016@ZenIV.linux.org.uk>
	<CAJfpegu+=zidycJwcBPjuDLP-ZnGisOGQpD8GKhD-Wz6eNzd9g@mail.gmail.com>
	<20140430190227.GR18016@ZenIV.linux.org.uk>
	<20140430195918.GS18016@ZenIV.linux.org.uk>
	<CA+55aFxe4HKHiWbarfwtww9=WUgfAmk+Cf3G7tdBB19uMdjbEg@mail.gmail.com>
	<20140430203823.GT18016@ZenIV.linux.org.uk>
	<CA+55aFyqqwrtv7ifTYVK943qm2OJOF8aF1y6apMSwjG93T=ztA@mail.gmail.com>
	<20140430211206.GU18016@ZenIV.linux.org.uk>
	<20140430221238.GV18016@ZenIV.linux.org.uk>
Date: Wed, 30 Apr 2014 16:04:58 -0700
X-Google-Sender-Auth: HZaNyAGy71zO77iX39dsk9JT_1s
Message-ID: <CA+55aFzekh6peA627B1e3NwcL06DqErWX6whJGm4w0WDRTn1gA@mail.gmail.com>
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

On Wed, Apr 30, 2014 at 3:12 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> I've just pushed the whole thing to vfs.git#for-linus;
> review and testing would be very welcome.

I have no half-way relevant test-case for this, so I'm hoping people
who have good VFS stress-tests (preferably under memory pressure so
that we get that whole shrinking path) will test.

But it looks fine.

That said, I do hate that RCU read-lock around the final spin-unlock.

Let me go talk to the paravirt people. Maybe they don't need this, and
I don't know exactly *how* they use that lock pointer after the unlock
in the "kick waiters" part. Maybe it's all good.

                     Linus
