Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaH2NI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:08:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48653 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752824AbaH2NI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:08:26 -0400
Date: Fri, 29 Aug 2014 15:08:21 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Raphael Rigo <ml-arm@syscall.eu>, Arnaud Ebalard <arno@natisbad.org>,
        Simon Boulay <simon.boulay@vitec.com>
Subject: Re: [PATCH 2/4] clk: mvebu: armada-370: Fix timer drift caused by
 the SSCG deviation
Message-ID: <20140829150821.66f1d03d@free-electrons.com>
In-Reply-To: <1409312620-20631-3-git-send-email-gregory.clement@free-electrons.com>
References: <1409312620-20631-1-git-send-email-gregory.clement@free-electrons.com>
	<1409312620-20631-3-git-send-email-gregory.clement@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gregory CLEMENT,

On Fri, 29 Aug 2014 13:43:38 +0200, Gregory CLEMENT wrote:

> +bool a370_is_sscg_enabled(void __iomem *sar)

Minor nit: "static" is missing here.

> +{
> +	return !(readl(sar) & SARL_A370_SSCG_ENABLE);
> +}
> +
>  static const struct coreclk_soc_desc a370_coreclks = {
>  	.get_tclk_freq = a370_get_tclk_freq,
>  	.get_cpu_freq = a370_get_cpu_freq,
>  	.get_clk_ratio = a370_get_clk_ratio,
> +	.is_sscg_enabled = a370_is_sscg_enabled,
>  	.ratios = a370_coreclk_ratios,
>  	.num_ratios = ARRAY_SIZE(a370_coreclk_ratios),
>  };

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
