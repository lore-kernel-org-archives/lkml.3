Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaICK4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:56:45 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57675 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbaICK4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:56:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-serial@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: Re: [PATCH] tty/serial: fix config dependencies for samsung serial
Date: Wed, 03 Sep 2014 12:56:02 +0200
Message-ID: <10202237.9vbtDF9MIQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAHfPSqAn5gHjDA75Zf1W5=GH9_W+X6+4oc9rDK7CqeSoF3DURw@mail.gmail.com>
References: <1409671320-7604-1-git-send-email-ch.naveen@samsung.com> <3749760.naNt3fHoTI@wuerfel> <CAHfPSqAn5gHjDA75Zf1W5=GH9_W+X6+4oc9rDK7CqeSoF3DURw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ifQFuQkQIVsrpwl9w2OgJ/TdIJO5tYWQ0p2cQu+bPGd
 jxV3Tmyyx12E0b/m//k/qckAcph1FAFDp0wQUu9DKHcG+ww7ch
 MR6DjZ5+e4gBNkbEBCm4DHxHAM2RCxdJhjWKofo9Ni9YFYOj4Z
 iZBeCjUmAnyrKYPnMtVTB1mWEEtvGrYKQqzUVIxy3XMX5/8rAI
 gZYkVe1kHS62sidtFl5XKZD9acHWyJovh2DERAQnFJHMF0BW44
 CNQy6kq/fv0K1xJo4RvaXsyzhsfv2dPfxyiMw110MM8U4zu3jX
 Kaa2IB5WL1Mvq5Sw2EpuTM99HsNNtcv5tDFKwhM4GSnmh7rNPq
 thrtb+zaUH6hAFCSTQFQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2014 13:51:56 Naveen Krishna Ch wrote:
> On 2 September 2014 21:16, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 02 September 2014 20:52:00 Naveen Krishna Chatradhi wrote:
> >> Make the config symbols SERIAL_SAMSUNG_UARTS_4 and
> >> SERIAL_SAMSUNG_UARTS depend on SERIAL_SAMSUNG rather than
> >> PLAT_SAMSUNG.
> >
> > Please always describe why you are doing a change. This patch
> > seems really pointless.
> 
> The SERIAL_SAMSUNG_UARTS_4 and SERIAL_SAMSUNG_UARTS config options are
> meaningful only if SERIAL_SAMSUNG is enabled. Hence the dependency
> rules were changed. I will repost this patch with better description.

My point is that the options are used by both the uart driver and
the platform code, e.g. for the purpose of PM debugging which can
be enabled even when the serial-samsung driver is turned off.

> >>  config SERIAL_SAMSUNG_UARTS_4
> >>         bool
> >> -       depends on PLAT_SAMSUNG
> >> +       depends on SERIAL_SAMSUNG
> >>         default y if !(CPU_S3C2410 || CPU_S3C2412 || CPU_S3C2440 || CPU_S3C2442)
> >>         help
> >>           Internal node for the common case of 4 Samsung compatible UARTs
> >>
> >>  config SERIAL_SAMSUNG_UARTS
> >>         int
> >> -       depends on PLAT_SAMSUNG
> >> +       depends on SERIAL_SAMSUNG
> >>         default 4 if SERIAL_SAMSUNG_UARTS_4 || CPU_S3C2416
> >>         default 3
> >>         help
> >>
> >
> > Have you checked that it still builds on all samsung platforms when
> > SERIAL_SAMSUNG is disabled? We have had build errors in this area
> > in the past.
> 
> Yes, it builds for other Samsung platforms.

Ok.

	Arnd
