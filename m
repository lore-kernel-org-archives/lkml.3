Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3DOPXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:23:50 -0400
Received: from smtp-out-028.synserver.de ([212.40.185.28]:1208 "EHLO
	smtp-out-028.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab3DOPXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:23:46 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 22330
Message-ID: <516C1B4B.2070806@metafoo.de>
Date: Mon, 15 Apr 2013 17:22:51 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Paolo Pisati <paolo.pisati@canonical.com>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] dma: of-dma: check OF pointer property before dereferencing
 it
References: <1366015193-6627-1-git-send-email-paolo.pisati@canonical.com> <1366015193-6627-2-git-send-email-paolo.pisati@canonical.com>
In-Reply-To: <1366015193-6627-2-git-send-email-paolo.pisati@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 10:39 AM, Paolo Pisati wrote:
> Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>

That should already be fixed in the DMA tree. See commit 7362f04c28 ("DMA:
OF: Check properties value before running be32_to_cpup() on it").

- Lars


> ---
>  drivers/dma/of-dma.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
> index 69d04d2..9628298 100644
> --- a/drivers/dma/of-dma.c
> +++ b/drivers/dma/of-dma.c
> @@ -91,6 +91,7 @@ int of_dma_controller_register(struct device_node *np,
>  				(struct of_phandle_args *, struct of_dma *),
>  				void *data)
>  {
> +	void 	*parent;
>  	struct of_dma	*ofdma;
>  	int		nbcells;
>  
> @@ -103,8 +104,10 @@ int of_dma_controller_register(struct device_node *np,
>  	if (!ofdma)
>  		return -ENOMEM;
>  
> -	nbcells = be32_to_cpup(of_get_property(np, "#dma-cells", NULL));
> -	if (!nbcells) {
> +	parent = of_get_property(np, "#dma-cells", NULL);
> +	if (parent)
> +		nbcells = be32_to_cpup(parent);
> +	if (!parent || !nbcells) {
>  		pr_err("%s: #dma-cells property is missing or invalid\n",
>  		       __func__);
>  		kfree(ofdma);

