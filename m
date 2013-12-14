Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab3LNU6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:58:19 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38454 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab3LNU6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:58:17 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 12:58:10 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: Re: [PATCH] drivers: dca: Mark the function dca_common_get_tag() as
 static in dca-core.c
Message-ID: <20131214205810.GT17601@leaf>
References: <20131214134436.GA13211@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131214134436.GA13211@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 07:14:36PM +0530, Rashika Kheria wrote:
> This patch marks the function dca_common_get_tag() as static in
> dca-core.c because it is not used outside this file.
> 
> Thus, it also eliminates the following warning in dca-core.c:
> drivers/dca/dca-core.c:273:4: warning: no previous prototype for ‘dca_common_get_tag’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/dca/dca-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
> index 819dfda..9096e59 100644
> --- a/drivers/dca/dca-core.c
> +++ b/drivers/dca/dca-core.c
> @@ -270,7 +270,7 @@ EXPORT_SYMBOL_GPL(dca_remove_requester);
>   * @dev - the device that wants dca service
>   * @cpu - the cpuid as returned by get_cpu()
>   */
> -u8 dca_common_get_tag(struct device *dev, int cpu)
> +static u8 dca_common_get_tag(struct device *dev, int cpu)
>  {
>  	struct dca_provider *dca;
>  	u8 tag;
> -- 
> 1.7.9.5
> 
