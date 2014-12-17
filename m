Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaLQK61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:58:27 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:57406 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQK6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:58:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Agner <stefan@agner.ch>
Cc: linux-arm-kernel@lists.infradead.org, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        daniel.lezcano@linaro.org, tglx@linutronix.de, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] ARM: dts: add support for Vybrid running on Cortex-M4
Date: Wed, 17 Dec 2014 11:57:06 +0100
Message-ID: <2673866.7fjSqeaHyh@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <b090cb361e81d2f1be5d21d1a07e9340@agner.ch>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch> <2994970.DCfUQgtmcD@wuerfel> <b090cb361e81d2f1be5d21d1a07e9340@agner.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:F+hHyreeK94YnEnvN0Nn0gfiqXxQo43Ve8NpFHt5GWr3/fbp0bY
 Vox9/oKtFOi7k+/5ln1UH2mbGMQPlnyfzh6OW/TkqUNfMXReIX4FyMtEzQoCyy4ZraB+UPO
 Rm+FSiVRpQOZxoeVLvO6KzZ26QgFb6cq1BAwsKEJU3vdxiBlO+PqTHsjED/z7+bEfND9fWu
 KRWAZc2V1GFZviEqzJx+w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 December 2014 23:19:08 Stefan Agner wrote:
> On 2014-12-03 12:03, Arnd Bergmann wrote:
> > On Wednesday 03 December 2014 01:12:10 Stefan Agner wrote:

> Just started looking in that a bit deeper and some question arose:
> Afaik, earlycon need to be supported by the uart driver. The fsl_lpuart,
> which is used for Vybrid's uart, does not support earlycon yet. However,
> earlyprink already works (see ./arch/arm/include/debug/vf.S). I
> understand that earlycon has the advantage of being able to be used on
> multiplatform. But earlyprintk is working really early (e.g. before
> locating the FDT), and it proved helpful for me when I started working
> on that Cortex-M4 stuff. Should earlycon replace earlyprintk completely?

earlyprintk will stay around for debugging early boot problems, but
with working earlycon support, there should no longer be a reason to
enable it by default.

> Maybe, on Vybrid, since it would be a good platform for automated !MMU
> testing, it would be nice to have earlycon which can be enabled in any
> case and would provide output even something blows up quite early... But
> I guess I would add earlycon support as part of a new patchset and just
> drop earlyprintk here for now.

Yes, I think that would be good.

> > 64 hash table entries sounds extremely small, doesn't that impact
> > performance? If you have 50MB of actual RAM available, I don't think
> > you need that.
> 
> Agreed. I copied that from EFM32 which is under much more memory
> pressure...

Ok.
	
	Arnd
