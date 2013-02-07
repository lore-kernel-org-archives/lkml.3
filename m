Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab3BGNhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:37:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55705 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758566Ab3BGNha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:37:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Takashi Iwai <tiwai@suse.de>, axboe@kernel.dk, cbou@mail.ru,
        davem@davemloft.net, dtor@mail.ru, dwmw2@infradead.org,
        grant.likely@secretlab.ca, gregkh@linuxfoundation.org, jkosina@suse.cz,
        jslaby@suse.cz, khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH 12/15] sound: add missing HAS_IOPORT and GENERIC_HARDIRQS dependencies
Date: Thu, 07 Feb 2013 14:36:15 +0100
Message-ID: <1376233.Q2CJ8VJpTB@wuerfel>
User-Agent: KMail/4.10 rc3 (Linux/3.8.0-3-generic; KDE/4.9.98; x86_64; ; )
In-Reply-To: <20130207133206.GB3929@osiris>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com> <201302062156.55910.arnd@arndb.de> <20130207133206.GB3929@osiris>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:6zxmePSkltcnAKtyDS0H7EDOCGfda6b5/MY5RV2jHGq
 skfUjuTYXKjIj2+Kp0al9+Lq95ZPg5jOPBszA5+KGnUtKlZrDf
 qWDCY5bSJ8G/wMUiC3qozQGnpdNJH/wuI+nN4osGpywb+wAltY
 ygPiqfKkPUbNgxpHTUKn7IdY1dXsc+bbqK2Ackf0tADd1WDejf
 4m8355xdchNsZTiH2MUHk+ddE2d8LjOpTUe9qXf7ZbRXCrykXx
 NfSTr8f5I/L5JZdDtLgbel5uA9/dYpJfdmbptQrhXMaPL7v4Yy
 XVtpvEoKTr1Aql2L9pP4ZtTzOVvGHWz7N9pq0Hx3CSv5M1r9iU
 hh6Tfpx2IYQk8wcAGAMo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013 14:32:06 Heiko Carstens wrote:
> 
> That sounds reasonable. And a quick grep seems to indicate that s390
> is the last architecture with !GENERIC_HARDIRQS.
> However having two completely different IRQ subsystems within one
> architecture will bring up some interesting questions like e.g.
> how should /proc/interrupts look like? Or /proc/stat:intr ?

/proc/interrupts can still be managed by architecture code, and
you can put in there whatever makes sense. I would suggest
keeping the current code for it, or adding the GENERIC_HARDIRQ
support at the end of it.

> Jan considered turning GENERIC_HARDIRQS on for PCI support, but didn't.
> I don't know why he didn't and since he left, we can't ask him anymore.

I briefly talked about it with him a couple of months ago, and
he said that the thought Martin would hate it.  I still think
it's the best solution though.

> So for the time being I'd appreciate it if we can simply add the
> additional GENERIC_HARDIRQS dependencies where needed, since I consider
> a working allmodconfig quite important.
>
> Later on we should indeed try to switch to GENERIC_HARDIRQS and then
> git rid of that config option completely. However I leave that to
> Sebastian and Gerald who now take care of our PCI code 

Yes, makes sense.

	Arnd
