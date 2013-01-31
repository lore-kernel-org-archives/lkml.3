Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3AaH2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 02:28:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:52739 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab3AaH2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 02:28:10 -0500
Date: Thu, 31 Jan 2013 08:30:05 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 1/1] dma: pl330: Convert to devm_ioremap_resource()
Message-ID: <20130131073005.GA12469@kroah.com>
References: <1359616024-11640-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359616024-11640-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 12:37:04PM +0530, Sachin Kamat wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> This change is based against linux-next tree (20130128).
> This change however introduces the followign sparse warning:
> drivers/dma/pl330.c:2883:22: warning: incorrect type in argument 1 (different address spaces)
> drivers/dma/pl330.c:2883:22:    expected void const *ptr
> drivers/dma/pl330.c:2883:22:    got void [noderef] <asn:2>*base
> drivers/dma/pl330.c:2884:34: warning: incorrect type in argument 1 (different address spaces)
> drivers/dma/pl330.c:2884:34:    expected void const *ptr
> drivers/dma/pl330.c:2884:34:    got void [noderef] <asn:2>*base

These are known, a patch has been posted for both the kernel and sparse
to fix this up.

thanks,

greg k-h
