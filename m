Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaG2Oku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:40:50 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:46473 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbaG2Okq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:40:46 -0400
Date: Tue, 29 Jul 2014 10:40:42 -0400
From: Tejun Heo <tj@kernel.org>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, kishon@ti.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 3/8] ata: libahci_platform: move port_map parameters
 into the AHCI structure
Message-ID: <20140729144042.GD4791@htj.dyndns.org>
References: <1406193450-17283-1-git-send-email-antoine.tenart@free-electrons.com>
 <1406193450-17283-4-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406193450-17283-4-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple nit picks.

On Thu, Jul 24, 2014 at 11:17:25AM +0200, Antoine Ténart wrote:
> @@ -321,6 +321,8 @@ struct ahci_host_priv {
>  	u32			cap;		/* cap to use */
>  	u32			cap2;		/* cap2 to use */
>  	u32			port_map;	/* port map to use */
> +	u32			force_port_map;	/* force port map */
> +	u32			mask_port_map;	/* mask out particular bits */

Let's collect the inputs, including flags, at the top and mark them clearly.

>  int ahci_platform_init_host(struct platform_device *pdev,
>  			    struct ahci_host_priv *hpriv,
>  			    const struct ata_port_info *pi_template,
> -			    unsigned long host_flags,
> -			    unsigned int force_port_map,
> -			    unsigned int mask_port_map)
> +			    unsigned long host_flags)

This doesn't make much sense to me.  Near the head of the function, it
does

	hpriv->flags |= host_flags;

Wouldn't it make more sense to just let the caller set hpriv->flags?

Thanks.

-- 
tejun
