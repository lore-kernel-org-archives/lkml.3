Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaJJKJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 06:09:03 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:51117 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaJJKJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 06:09:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Scott Branden <sbranden@broadcom.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, JD Zheng <jdzheng@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jonathan Richardson <jonathar@broadcom.com>
Subject: Re: [PATCH V4 5/7] ARM: dts: Enable Broadcom Cygnus SoC
Date: Fri, 10 Oct 2014 12:08:27 +0200
Message-ID: <6003834.vKPhBNUdsz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412894671-5921-6-git-send-email-sbranden@broadcom.com>
References: <1412894671-5921-6-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:+FCkzDTmyLA5ML57WM7ul0vqLZDYDlwnk2TaUe/X6ln
 FBrj8wa63dr7lQK8H/T3PBipphrxlpJemJimwimkP6fRfBxL5H
 n4wL8n3dGL0mMS8uvSUWt9TPYtN8kVUFdJwegKnGpNCkiBTesW
 KGx52OFaCUeqHTil2kbVHxbzLTICoxFPcl4EQl911YqUDU5Dc/
 r+HIetbETwaf02zuyI2o5pDAZ3uxY1yuoOf0kgC6ibaLZ7rVNp
 ILVWNg6GPoGhn94k98xMDpJdOhVlQh5TAdIjYZtumnVW8Y6kuM
 +8fL+3PA0EoiYktvkoDWK4k+h+odE8ot8JVbziCcMFJecLZwzy
 NDyyUPwdeY3Z9h1ZowB4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2014 15:44:29 Scott Branden wrote:
> +
> +               lcpll: lcpll@0301d02c {
> +                       #clock-cells = <0>;
> +                       compatible = "brcm,cygnus-lcpll-clk";
> +                       reg = <0x0301d02c 0x1c>;
> +                       clocks = <&osc>;
> +               };
> +
> +               genpll: genpll@0301d000 {
> +                       #clock-cells = <0>;
> +                       compatible = "brcm,cygnus-genpll-clk";
> +                       reg = <0x0301d000 0x2c>,
> +                                 <0x180AA024 0x4>,
> +                                 <0x0301C020 0x4>;
> +                       clocks = <&osc>;
> +               };
> +

To be honest, I'm not too happy about the way you specify a single
register for each clock as a global 'reg' property.

Presumably each of these registers is part of an IP block that does
multiple things, so it would be better to start out with a binding
for each IP block. How many of these blocks are used for clocks, and
what do they do?

	Arnd
