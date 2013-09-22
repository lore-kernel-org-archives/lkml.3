Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab3IVOo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 10:44:28 -0400
Received: from benson.vm.bytemark.co.uk ([212.110.190.137]:39855 "EHLO
	benson.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab3IVOo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 10:44:27 -0400
Message-ID: <1379861045.30708.22.camel@dagon.hellion.org.uk>
Subject: Re: [linux-sunxi] [PATCH V3: Add Smp support for Allwinner A20.
 1/3] Add smp support for Allwinner A20(sunxi 7i).
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-sunxi@googlegroups.com
Cc: coosty@163.com, maxime.ripard@free-electrons.com,
        daniel.lezcano@linaro.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.co, rob.herring@calxeda.com,
        Fan Rong <cinifr@gmail.com>
Date: Sun, 22 Sep 2013 15:44:05 +0100
In-Reply-To: <1379852488-32147-2-git-send-email-cinifr@gmail.com>
References: <1379852488-32147-1-git-send-email-cinifr@gmail.com>
	 <1379852488-32147-2-git-send-email-cinifr@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-22 at 20:21 +0800, Fan Rong wrote:

> +	/* Set boot addr */
> +	paddr = virt_to_phys(sun7i_secondary_startup);
> +	writel(paddr, sunxi7i_cc_base + SUN7I_CPUCFG_BOOTADDR);

This means that the secondary cores will miss out on any setup which the
bootloader might have done for the primary CPU, e.g. switching to NS HYP
mode, setting the CNTFRQ etc.

Wouldn't it be better to do all this stuff in the bootloader and either
implement PSCI or have the bootloader do the traditional holding pen and
mbox address thing?


