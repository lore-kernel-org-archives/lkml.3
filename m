Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaEPVIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:08:11 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:43741 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbaEPVIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:08:09 -0400
Date: Fri, 16 May 2014 17:08:05 -0400
From: Tejun Heo <tj@kernel.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] dma-mapping: Add devm_ interface for dma_map_single()
Message-ID: <20140516210805.GO5379@htj.dyndns.org>
References: <1400228799-8832-1-git-send-email-eli.billauer@gmail.com>
 <1400228799-8832-3-git-send-email-eli.billauer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400228799-8832-3-git-send-email-eli.billauer@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 16, 2014 at 11:26:36AM +0300, Eli Billauer wrote:
> +dma_addr_t dmam_map_single(struct device *dev, void *ptr, size_t size,
> +			   enum dma_data_direction direction)
> +
> +{
> +	struct dma_devres *dr;
> +	dma_addr_t dma_handle;
> +
> +	dr = devres_alloc(dmam_map_single_release, sizeof(*dr), GFP_KERNEL);
> +	if (!dr)
> +		return 0;
> +
> +	dma_handle = dma_map_single(dev, ptr, size, direction);

Don't we wanna map the underlying operation - dma_map_single_attrs() -
instead?

> +	if (dma_mapping_error(dev, dma_handle)) {
> +		devres_free(dr);
> +		return 0;

Can't we just keep returning dma_handle?  Even if that means invoking
->mapping_error() twice?  It's yucky to have subtly different error
return especially because in most cases it won't fail.

Thanks.

-- 
tejun
