Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbaENOar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:30:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaENOaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:30:46 -0400
Date: Wed, 14 May 2014 16:30:43 +0200
From: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Florian Fainelli'" <f.fainelli@gmail.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Joe Perches'" <joe@perches.com>,
        "'Dan Carpenter'" <dan.carpenter@oracle.com>
Subject: Re: [PATCH] lib: devres: Mark devm_request_and_ioremap() as
 deprecated
Message-ID: <20140514143043.GC17301@kroah.com>
References: <002301cf6f36$b1d11320$15733960$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002301cf6f36$b1d11320$15733960$%han@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 02:38:11PM +0900, Jingoo Han wrote:
> devm_request_and_ioremap() was obsoleted by devm_ioremap_resource().
> (7509657 "lib: devres: Introduce devm_ioremap_resource()") So,
> let's mark it as deprecated in order to stop using it.
> 
> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> ---
>  include/linux/device.h |    4 ++--
>  lib/devres.c           |    1 +
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 67f003a..769c86b 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -627,8 +627,8 @@ extern void *devm_kmemdup(struct device *dev, const void *src, size_t len,
>  			  gfp_t gfp);
>  
>  void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
> -void __iomem *devm_request_and_ioremap(struct device *dev,
> -			struct resource *res);
> +void __deprecated __iomem *devm_request_and_ioremap(struct device *dev,
> +						    struct resource *res);

If no one uses it, just delete it entirely from the tree, no need to
mark __deprecated, that's not going to stop new people from using it.

Also, I see a number of existing users in Linus's tree, please remove
those usages as well.

greg k-h
