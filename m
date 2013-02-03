Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab3BCRCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 12:02:18 -0500
Received: from mga14.intel.com ([143.182.124.37]:22072 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab3BCRCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 12:02:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,595,1355126400"; 
   d="scan'208";a="198252455"
Date: Sun, 3 Feb 2013 18:02:13 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Aaron Sierra <asierra@xes-inc.com>
Cc: =?iso-8859-1?B?QWfzY3MgUOFs?= <agocs.pal.86@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] lpc_ich: fix gpio base and control offsets
Message-ID: <20130203170213.GQ8476@sortiz-mobl>
References: <b9fec05c-d383-4282-b2af-c95855ff6abb@zimbra>
 <3ffa5032-0565-48f0-a4ae-473452f4c902@zimbra>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ffa5032-0565-48f0-a4ae-473452f4c902@zimbra>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arron,

On Thu, Jan 24, 2013 at 02:52:39PM -0600, Aaron Sierra wrote:
> In ICH5 and earlier the GPIOBASE and GPIOCTRL registers are found at
> offsets 0x58 and 0x5C, respectively. This patch allows GPIO access to
> properly be enabled (and disabled) for these chipsets.
> 
> Signed-off-by: Agócs Pál <agocs.pal.86@gmail.com>
> Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
> ---
>  drivers/mfd/lpc_ich.c |  109 ++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 76 insertions(+), 33 deletions(-)
I applied this one to my for-next branch, but:


> @@ -858,14 +874,35 @@ wdt_done:
>  static int lpc_ich_probe(struct pci_dev *dev,
>  				const struct pci_device_id *id)
>  {
> +	struct lpc_ich_priv *priv;
>  	int ret;
>  	bool cell_added = false;
> 
> -	ret = lpc_ich_init_wdt(dev, id);
> +	priv = kmalloc(GFP_KERNEL, sizeof(struct lpc_ich_priv));
> +	if (!priv)
> +		return -ENOMEM;
Could you please come back to me with a follow up patch that would convert
this to the devm_kzalloc() API ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
