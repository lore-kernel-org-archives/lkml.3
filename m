Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbaLQOgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 09:36:17 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:56395 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaLQOgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 09:36:16 -0500
MIME-Version: 1.0
In-Reply-To: <1414729631-11005-5-git-send-email-tharvey@gateworks.com>
References: <1414729631-11005-1-git-send-email-tharvey@gateworks.com>
	<1414729631-11005-5-git-send-email-tharvey@gateworks.com>
Date: Wed, 17 Dec 2014 12:36:14 -0200
Message-ID: <CAOMZO5DzEe91pTv+UkCbj0DzgVDOb9hjuakt9NmpTJnEk-j8UA@mail.gmail.com>
Subject: Re: [PATCH 4/5] cpufreq: imx6q: add ldo-bypass support
From: Fabio Estevam <festevam@gmail.com>
To: Tim Harvey <tharvey@gateworks.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Silvio F <silvio.fricke@gmail.com>, Christian Hemp <c.hemp@phytec.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Iain Paton <ipaton0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

On Fri, Oct 31, 2014 at 2:27 AM, Tim Harvey <tharvey@gateworks.com> wrote:
> When an external PMIC is used for VDD_SOC and VDD_ARM you can save power by
> bypassing the internal LDO's provided by the anantop regulator as long as
> you are running less than 1.2GHz. If running at 1.2GHz the IMX6 datasheets
> state that you must use the internal LDO's to reduce ripple on the suplies.
>
> A failure to bypass the LDO's when using an external PMIC will result in an
> extra voltage drop (~125mV) between VDD_ARM_IN and VDD_ARM and VDD_SOC_IN and
> VDD_SOC which violates the voltages specificed by the datasheets.
>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> ---
>  drivers/cpufreq/imx6q-cpufreq.c | 51 +++++++++++++++++++++++++++++++++++++++++

Shouldn't the LDO bypass support be added into the anatop regulator
driver instead?

What if someone wants to use LDO bypass and not use the cpufreq driver?
