Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaIHPWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:22:47 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:56809 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbaIHPWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:22:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: pcf8563: fix uninitialized use warning
Date: Mon, 08 Sep 2014 17:22:40 +0200
Message-ID: <10094879.uvjB4Q3B81@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <540D8CA8.5020104@cogentembedded.com>
References: <3640058.m4Rfp1dmTJ@wuerfel> <540D8CA8.5020104@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5fevMeS9DMcv5QoUX80g2EkCvmofzTn1Vl3YguTl52l
 QC6Js5zNV5GBVoU3ALY5YV8FwlTjtWDa9wV/rHhnp6k4DTj5QF
 EoaMuoZzRqt7juoRQbRb+0IWIIE1YstaeObTrYSrz1+OI4WIPd
 w+cPR0ZH6cAixSiXO1lnpp58sP0Qu1FByisu2wVwm8586IMHIf
 lqJV8pc9u5oEMxuyTdrfFMUocJZO4NR3Px1uHb9Yd+YKEDfN/W
 lR6au/MTaddMJuUpNokW+AObj9p8+fnK+2xkTL3tve1t0RmP5w
 8e0Y2Er9P3FQB1mpd3aPnZ8uUYpBtQaMPVGBRTX+PRB459jAgr
 P9vd7nvi56kKItQytWmM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2014 15:02:00 Sergei Shtylyov wrote:
> > diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
> > index 5a197d9dc7e7..3a6f994c4da8 100644
> > --- a/drivers/rtc/rtc-pcf8563.c
> > +++ b/drivers/rtc/rtc-pcf8563.c
> > @@ -167,7 +167,7 @@ static irqreturn_t pcf8563_irq(int irq, void *dev_id)
> >       char pending;
> >
> >       err = pcf8563_get_alarm_mode(pcf8563->client, NULL, &pending);
> > -     if (err < 0)
> > +     if (err)
> >               return err;
> 
>     Returning negative values from the IRQ handler doesn't seem valid.
> Arbitrary positive value aren't good either. Perhaps should return IRQ_NONE 
> instead?

Good point. This is unrelated to the problem I was trying to fix, but it
seems like a good idea to fix both.

	Arnd
