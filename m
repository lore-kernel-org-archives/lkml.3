Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbbAPCAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 21:00:53 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35926 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbbAPCAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 21:00:51 -0500
Date: Thu, 15 Jan 2015 18:00:40 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Stephen Wang <wstephen@codeaurora.org>
Cc: jcliburn@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ethernet: atheros: Add nss-gmac driver
Message-ID: <20150115180040.180fdbb9@urahara>
In-Reply-To: <1420754626-30121-1-git-send-email-wstephen@codeaurora.org>
References: <y>
	<1420754626-30121-1-git-send-email-wstephen@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Jan 2015 14:03:46 -0800
Stephen Wang <wstephen@codeaurora.org> wrote:

> +static int32_t nss_gmac_setup_tx_desc_queue(struct nss_gmac_dev *gmacdev,
> +						struct device *dev,
> +						uint32_t no_of_desc,
> +						uint32_t desc_mode)
> +{
> +	int32_t i;
> +	struct dma_desc *first_desc = NULL;
> +	dma_addr_t dma_addr;
> +
> +	gmacdev->tx_desc_count = 0;
> +
> +	BUG_ON(desc_mode != RINGMODE);
> +	BUG_ON((no_of_desc & (no_of_desc - 1)) != 0);
> +
> +	netdev_dbg(gmacdev->netdev, "Total size of memory required for Tx Descriptors in Ring Mode = 0x%08x"
> +			, (uint32_t) ((sizeof(struct dma_desc) * no_of_desc)));
> +
> +	first_desc = dma_alloc_coherent(dev, sizeof(struct dma_desc) * no_of_desc
> +					, &dma_addr, GFP_KERNEL);
> +	if (first_desc == NULL) {

In a lot of places you first initialize a variable then assign it 5 lines
later to it's initial value.  Get rid of the first initialization.
