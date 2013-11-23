Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab3KWSP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 13:15:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63516 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab3KWSPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 13:15:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] mtd: nand: davinci: reuse driver for Keystone arch
Date: Sat, 23 Nov 2013 19:15:29 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        grygorii.strashko@ti.com, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
References: <1384964699-15134-1-git-send-email-ivan.khoronzhuk@ti.com> <1384964699-15134-2-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1384964699-15134-2-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201311231915.29643.arnd@arndb.de>
X-Provags-ID: V02:K0:TrSrLFU8sGImLZT5jQuVxupdrOTlkLEsznkKgL5GbNX
 0BRYBMFVVjP5Q2W82nyyI4ZVhuKmEYgOAVJXYrD/S5RVobL88J
 mznvIEfvgS/SxwbOBGk8rHY0rMMQpA6aikDkd1rERD9QM92CZ7
 9uxCmxhwWBp05bC+acjsf/PRx1883a4RXKoCGLGTpa52O2Fsjs
 Gxmd/tdu70BrHeZfgQxiwDsBVO+sZLxtgeUEJXtnDHDApIXomm
 j2slDAQmvLU6QVSi+lQl/UJdzJpT0Bv5YPuZXbq5UIXzq3+fGR
 xirNbQBGiBK6SI/uQs6Pp55gSxSgOTmfTESvo/GOkD8923oM+/
 Q+HwD3EksXBHNbxOdnAc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 November 2013, Ivan Khoronzhuk wrote:
> --- a/drivers/mtd/nand/davinci_nand.c
> +++ b/drivers/mtd/nand/davinci_nand.c
> @@ -523,6 +523,7 @@ static struct nand_ecclayout hwecc4_2048 __initconst = {
>  #if defined(CONFIG_OF)
>  static const struct of_device_id davinci_nand_of_match[] = {
>         {.compatible = "ti,davinci-nand", },
> +       {.compatible = "ti,keystone-nand", },
>         {},
>  };
>  MODULE_DEVICE_TABLE(of, davinci_nand_of_match);

Same comment as for the watchdog driver: when the devices are actually compatible,
the driver does not need to know the new string, the preferred method is to
set both strings from the .dts file.

	Arnd
