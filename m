Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab3HQT2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 15:28:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52942 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab3HQT2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 15:28:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [RFC v1 4/5] ARM: mvebu: add Armada 1500 and Sony NSZ-GS7 device tree files
Date: Sat, 17 Aug 2013 21:28:34 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376682098-10580-5-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1376682098-10580-5-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201308172128.35245.arnd@arndb.de>
X-Provags-ID: V02:K0:0ByerBCWpTb6ymfkoBbyNEW62c3k0zP+R/3j2vTxNCK
 rTkSJd6nHffHG7CRQTndd/7JlMY58OtuW9LOO4RS0LZkGtgie+
 KbBqP+b17k4S/B3NAhlwYoF9xaK01G92k2juLiNjJn4wgbcdLc
 Nmhub0cdIZMjgMXT00C9WlFlE/W9FJx4LTJ2KiS9Yd4hcPinkZ
 89mjATrfVxmQTx5llh33mDxbjvBx7AUmnsmfnbuIBoMHmFpANO
 aWY7GMRa7qmW0tNwNcn1teym7Il4ebS1cFB0IVc4oQl/J4dowZ
 3sw4sTlRnw2eL2xDG9B1RZeQSIR9H+nQfzL0jJlravJUmAHENt
 GVZaOz8iSV9LIkr3hhiQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 August 2013, Sebastian Hesselbarth wrote:
> +               cpu@0 {
> +                       compatible = "marvell,sheeva-v7";
> +                       device_type = "cpu";
> +                       next-level-cache = <&l2>;
> +                       reg = <0>;
> +               };
...
> +               l2: l2-cache-controller@1ac0000 {
> +                       compatible = "marvell,aurora-outer-cache";
> +                       reg = <0x1ac0000 0x1000>;
> +                       cache-level = <2>;
> +               };
> +
> +               gic: interrupt-controller@1ad0000 {
> +                       compatible = "arm,cortex-a9-gic";
> +                       reg = <0x1ad1000 0x1000
> +                              0x1ad0100 0x0100>;
> +                       interrupt-controller;
> +                       #interrupt-cells = <3>;
> +               };
> +
> +               local-timer@1ad0600 {
> +                       compatible = "arm,cortex-a9-twd-timer";
> +                       reg = <0x1ad0600 0x20>;
> +                       interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
> +                       clocks = <&cpu0clk>;
> +               };

This seems like a strange combination. I would have expected either PJ4+Aurora+apbtimer
or A9+pl310+localtimer, based on what I found in the chromecast kernel source.
Do you have more information here about what is used on the two variants?

	Arnd
