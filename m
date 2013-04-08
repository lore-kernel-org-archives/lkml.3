Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934670Ab3DHQOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:14:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:61324 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760248Ab3DHQOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:14:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="224619603"
Date: Mon, 8 Apr 2013 18:14:10 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: swarren@nvidia.com, broonie@opensource.wolfsonmicro.com,
        gg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: palmas: initialise client->of_node for dummy
 created client
Message-ID: <20130408161410.GB24058@zurbaran>
References: <1363683500-24891-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363683500-24891-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Tue, Mar 19, 2013 at 02:28:20PM +0530, Laxman Dewangan wrote:
> Palmas device have three different i2c addresses. The device creates
> the two new dummy i2c clients for accessing the register by using
> primary client adapter. This new dummy i2c client have their of_node
> as NULL.
> 
> The dummy i2c client is used for registering interrupt and on this,
> it creates irq domain handle. This created irq domain handle has
> their of_node as NULL.
> 
> Now when any child of this device is registered through the DT as
> follows:
>          palmas: tps65913@58 {
>          	::::::::::::::::::
> 
>          	#interrupt-cells = <2>;
>                 interrupt-controller;
> 
>                 palmas_rtc {
>                        compatible = "ti,palmas-rtc";
>                        interrupt-parent = <&palmas>;
>                        interrupts = <8 0>;
>                 };
>                 ::::::::::;;;
>          };
> 
> And child driver (palam-rtc in this case) get their irq number as
> 	irq = platform_get_irq(pdev, 0);
> 
> The returned irq number is error in this case. The reason is that
> the created irq_domain handle for the palmas interrupt does not have
> valid node and so matching of node fails with palmas node.
> 
> Hence initialising the newly dummy created client->of_node with the
> primary clients of_node so that irq_domain handle have proper of_node
> for matching.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/mfd/palmas.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
Applied to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
