Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab3LNU6o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:58:44 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:44059 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab3LNU6n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:58:43 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 12:58:37 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] drivers: pnp: Mark the function pnp_build_option() as
 static in resource.c
Message-ID: <20131214205836.GU17601@leaf>
References: <20131214132056.GA8624@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131214132056.GA8624@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 06:50:56PM +0530, Rashika Kheria wrote:
> This patch marks the function pnp_build_option() as static in resource.c
> because it is not used outside this file.
> 
> Thus, it also eliminates the following warning in resource.c:
> drivers/pnp/resource.c:34:20: warning: no previous prototype for ‘pnp_build_option’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/pnp/resource.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
> index d95e101..bacddd1 100644
> --- a/drivers/pnp/resource.c
> +++ b/drivers/pnp/resource.c
> @@ -31,7 +31,7 @@ static int pnp_reserve_mem[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some
>   * option registration
>   */
>  
> -struct pnp_option *pnp_build_option(struct pnp_dev *dev, unsigned long type,
> +static struct pnp_option *pnp_build_option(struct pnp_dev *dev, unsigned long type,
>  				    unsigned int option_flags)
>  {
>  	struct pnp_option *option;
> -- 
> 1.7.9.5
> 
