Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab3E3UVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:21:31 -0400
Received: from 18.mo5.mail-out.ovh.net ([178.33.45.10]:34767 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750921Ab3E3UVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:21:23 -0400
X-Greylist: delayed 32843 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 May 2013 16:21:23 EDT
Date: Thu, 30 May 2013 22:17:14 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH] of: Export of_irq_count for using in modules
Message-ID: <20130530201714.GE19834@game.jcrosoft.org>
References: <6aa29b1d109a46278a7f37b598defe07d6edfe60.1369921774.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6aa29b1d109a46278a7f37b598defe07d6edfe60.1369921774.git.michal.simek@xilinx.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13024691598917741471
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:49 Thu 30 May     , Michal Simek wrote:
> Export of_irq_count for modules.

can you explain why do you need to call of_irq_count

Best Regards,
J.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> We are using this function in remoteproc module drivers.
> There is also drivers/gpio/gpio-mvebu.c in the tree
> which use this function but this driver can't be compiled
> as module. This could be also the reason why is not this driver as module.
> ---
>  drivers/of/irq.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index a3c1c5a..c918dde 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -374,6 +374,7 @@ int of_irq_count(struct device_node *dev)
> 
>  	return nr;
>  }
> +EXPORT_SYMBOL_GPL(of_irq_count);
> 
>  /**
>   * of_irq_to_resource_table - Fill in resource table with node's IRQ info
> --
> 1.8.2.3
> 



> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss

