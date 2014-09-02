Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaIBPq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:46:58 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:49362 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaIBPqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:46:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Pankaj Dubey <pankaj.dubey@samsung.com>,
        naveenkrishna.ch@gmail.com
Subject: Re: [PATCH] tty/serial: fix config dependencies for samsung serial
Date: Tue, 02 Sep 2014 17:46:23 +0200
Message-ID: <3749760.naNt3fHoTI@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409671320-7604-1-git-send-email-ch.naveen@samsung.com>
References: <1409671320-7604-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8Cl3+rPRBG25wUi7LOodLVjbNqN7C/0zxCixny7yzg0
 3iafjl+8eOkzrZpfwdp4B6DDe9JKwtGgy0HMEfa2INvA2w+wwn
 +C6qAwk9pVNhCvMhessfXg1/uT2j5e4aydiFONa5dd0KB/6ezJ
 DNYVJ6GqVlK4IBCnLDvYlh0J0IOlQvjIFQTYD6umhdrS0031W7
 GcXZn9enZCL0epuKqfS4WkAvLLRIn0ge+LxK4RtRmlUicge9u1
 sD694/zv1FLfZasCaacGq+mcZxDl895pARGkojsvpm7upxd3wZ
 pZoO/hc/1f2YnN5fn2ZHNnoxuSR/xe7QmTiNJiyI3Ntc20frrs
 VEfnIBOoePMp/9yvWI24=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 September 2014 20:52:00 Naveen Krishna Chatradhi wrote:
> Make the config symbols SERIAL_SAMSUNG_UARTS_4 and
> SERIAL_SAMSUNG_UARTS depend on SERIAL_SAMSUNG rather than
> PLAT_SAMSUNG.

Please always describe why you are doing a change. This patch
seems really pointless.

>  config SERIAL_SAMSUNG_UARTS_4
>         bool
> -       depends on PLAT_SAMSUNG
> +       depends on SERIAL_SAMSUNG
>         default y if !(CPU_S3C2410 || CPU_S3C2412 || CPU_S3C2440 || CPU_S3C2442)
>         help
>           Internal node for the common case of 4 Samsung compatible UARTs
>  
>  config SERIAL_SAMSUNG_UARTS
>         int
> -       depends on PLAT_SAMSUNG
> +       depends on SERIAL_SAMSUNG
>         default 4 if SERIAL_SAMSUNG_UARTS_4 || CPU_S3C2416
>         default 3
>         help
> 

Have you checked that it still builds on all samsung platforms when
SERIAL_SAMSUNG is disabled? We have had build errors in this area
in the past.

	Arnd
