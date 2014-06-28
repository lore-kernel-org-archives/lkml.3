Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaF1PEG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 11:04:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47030 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752733AbaF1PEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 11:04:04 -0400
Date: Sat, 28 Jun 2014 17:04:01 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, linux-kernel@vger.kernel.org,
        Nadav Haklai <nadavh@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/5] ARM: mvebu: Enable SCU Speculative linefills to L2
 for Armada 375/38x
Message-ID: <20140628170401.758c9d63@free-electrons.com>
In-Reply-To: <1403822608-31158-5-git-send-email-gregory.clement@free-electrons.com>
References: <1403822608-31158-1-git-send-email-gregory.clement@free-electrons.com>
	<1403822608-31158-5-git-send-email-gregory.clement@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gregory CLEMENT,

On Fri, 27 Jun 2014 00:43:27 +0200, Gregory CLEMENT wrote:

> diff --git a/arch/arm/mach-mvebu/board-v7.c b/arch/arm/mach-mvebu/board-v7.c
> index 8bb742fdf5ca..a24ea105e709 100644
> --- a/arch/arm/mach-mvebu/board-v7.c
> +++ b/arch/arm/mach-mvebu/board-v7.c
> @@ -45,6 +45,7 @@ static void __init mvebu_scu_enable(void)
>  		of_find_compatible_node(NULL, NULL, "arm,cortex-a9-scu");
>  	if (np) {
>  		scu_base = of_iomap(np, 0);
> +		scu_spec_linefills_enable(scu_base, true);

I find it rather weird to have a function call <foo>_enable() take a
boolean parameter to indicate whether <foo> should be enabled or
disabled. You should choose between:

	scu_spec_linefills_ctrl(scu_base, true/false)

(or some better suffix than _ctrl), or:

	scu_spec_linefills_enable(scu_base)
	scu_spec_linefills_disable(scu_base)

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
