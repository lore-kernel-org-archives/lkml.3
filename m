Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaEIHeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:34:31 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:56849 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaEIHe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:34:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 1/2] input: fix ps2/serio module dependency
Date: Fri, 09 May 2014 09:34:26 +0200
Message-ID: <4385062.1bvKsSrGCq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140508155931.GA11672@core.coreip.homeip.net>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <1399560990-1402858-15-git-send-email-arnd@arndb.de> <20140508155931.GA11672@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:YnYmdy3kE0iM/HdrCqO8+MegTQFLU9+nViZbVewlnv+
 9SZ6TV9ryuFzJ6jXoRMEN2+a2EXsfLoqy53+Kn4vRuhHTdKJ8N
 EN5VFYjdK+JScdmmviye/G5Lu17JpyHrILEnSDXAZzq6YeJlzO
 wRnm3/yfrhF/sQVqAZzedEE0CrLkyIeUqFUKx2rd5myXa4nFht
 V4c2FCiEzsedEGWa/dyr7cNdX8YLMW2iqV0CoACf8PcaxA2vLF
 eUHEdBbdJkrxVlMNde72OK3EzyChAgaqnYWYwZS7TNbjSfWgi3
 4tanxouMPAhESZ3kz/+etCVHKLlkb29GnQykF+1cIm/V4XLG3V
 anRhGT8WEoYeToajFnCs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 May 2014 08:59:31 Dmitry Torokhov wrote:
> Hi Arnd,
> 
> On Thu, May 08, 2014 at 04:56:26PM +0200, Arnd Bergmann wrote:
> > @@ -71,7 +71,7 @@ config KEYBOARD_ATKBD
> >       default y
> >       select SERIO
> >       select SERIO_LIBPS2
> > -     select SERIO_I8042 if X86
> > +     select SERIO_I8042 if X86 || ARCH_MIGHT_HAVE_PC_SERIO
> 
> x86 also selects ARCH_MIGHT_HAVE_PC_SERIO so shouldn't this be
> 
>         select SERIO_I8042 if ARCH_MIGHT_HAVE_PC_SERIO
> 
> ?
> 
> I can fix it up on my side if you agree.

Yes, sounds good, thanks!

	Arnd
