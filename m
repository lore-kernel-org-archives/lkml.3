Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaIWIIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:08:15 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57846 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaIWIIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:08:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, Pankaj Dubey <pankaj.dubey@samsung.com>,
        Naveen Krishna Ch <naveenkrishna.ch@gmail.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Subject: Re: [PATCH] tty/serial: fix config dependencies for samsung serial
Date: Tue, 23 Sep 2014 10:07:31 +0200
Message-ID: <5903767.VzDJhUfQDI@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAM4voaky-zin8ikdkLBwpTKy13hz3iON8tmNsd55-kr8po8Qaw@mail.gmail.com>
References: <1409671320-7604-1-git-send-email-ch.naveen@samsung.com> <10202237.9vbtDF9MIQ@wuerfel> <CAM4voaky-zin8ikdkLBwpTKy13hz3iON8tmNsd55-kr8po8Qaw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:aZ/zBDLMhwqhnB96gshq5ovHm5dsOj5rVsHWxA2R4pC
 kDU6XAUbvqsBzybYNRLamX/WAb+NkB8bdT50bByxMxLH3d9iLc
 yeHuTviuBjFjSMG7Wb2IOFz6RnLmkaP2gTZpGsytbbila+tyRl
 LFR8tdFEJJO2VFlY5r42hRkevvfApwX6cHKBO/vg2uXodJUQXd
 W8AzruTbJz7l7aTK02q5vYmFjvy+Mq8pXkPsPTaVIYkMPU2jbn
 MlR/fNE+besdtciEKs8zlTXOvvyWUEyBbQnokElW3xBFXWqjUT
 HNeRJhoEu3GLu74/d4tGA/FXBUK/+zN16lIRWl1bDegflyvD6J
 MPQ83FZ838QeDCwaWKWo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 12:34:26 Abhilash Kesavan wrote:
> >>
> >> The SERIAL_SAMSUNG_UARTS_4 and SERIAL_SAMSUNG_UARTS config options are
> >> meaningful only if SERIAL_SAMSUNG is enabled. Hence the dependency
> >> rules were changed. I will repost this patch with better description.
> >
> > My point is that the options are used by both the uart driver and
> > the platform code, e.g. for the purpose of PM debugging which can
> > be enabled even when the serial-samsung driver is turned off.
> 
> I looked through the code and could find two references to these
> symbols in the platform-specific code: arch/arm/plat-samsung/init.c
> and arch/arm/mach-s3c64xx/irq-pm.c. The first one is being used to
> initialize the uart platform device in non-dt way while the second one
> saves and restores the uart irq masks for all channels across a
> suspend/resume cycle. Also, the save/restore will get bypassed in case
> CONFIG_SERIAL_SAMSUNG_UARTS is not defined. It does not look like
> either of these cases would cause any issue with the current patch,
> can you please help me understand the problem ?

It's possible that it works fine now, I just pointed out that we
had bugs in this area in the past, so it would be good if you can
add to the changelog a statement that you have checked that the
new patch does not cause problems here.

	Arnd
