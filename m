Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaLCKxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:53:15 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:57109 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaLCKxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:53:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Stefan Agner <stefan@agner.ch>, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        daniel.lezcano@linaro.org, tglx@linutronix.de, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/12] Documentation: dt: imx: add MSCM documentation
Date: Wed, 03 Dec 2014 11:52:41 +0100
Message-ID: <57320597.hlx9GuXmaF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417565531-4507-8-git-send-email-stefan@agner.ch>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch> <1417565531-4507-8-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:NYjoONiFY4Ftf9Cjv6Y8M7qzJH7RT6D3sgPwOUaHXfJ
 Smlk9j5oD43l7CGJKGFRHJpwUpJcIYekhhupw0k5+I34moiB9q
 7xKeiEcmvJWJ5MkUw/urqTadFx9bDNil7sLEHi3MkcEw6X4rwn
 YO7T4ABFHXu+NfF3dnqdpO5CZjoGZhpLJg+KHBKbENggB36nUF
 AAymkNwOsPCm7vVinTmh5EQvJ/SSOFmhlz7dpOicePT0dn6KuG
 grerJM9LyKoKKmn4pZyADTS/SCASdTqiuUB1UZtJrqktYR1T4l
 aNYY3j2XCaDZFyoUvvHRnfNAwHb2zSd4+qOVA1AFMBPQFmK9Pj
 ggd2CCMWwBgHPpLvXxdQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 01:12:06 Stefan Agner wrote:
> +Freescale Vybrid Miscellaneous System Control Module
> +
> +The MSCM IP contains Access Control and TrustZone Security hardware,
> +CPU Configuration registers and Interrupt Router control.
> +
> +Required properties:
> +- compatible : "fsl,vf610-mscm"
> +- reg : the register range of the MSCM module
> +
> +Example:
> +       mscm: mscm@40001000 {                 
> +               compatible = "fsl,vf610-mscm";
> +               reg = <0x40001000 0x1000>;    
> +       };                                    

This sounds like one of those generic system controller devices.
Should this be marked as syscon an accessed through
syscon_regmap_lookup_by_phandle()?

If you only eve have one driver touching these registers, that
won't be necessary of course.

	arnd
