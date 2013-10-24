Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab3JXPdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:33:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35346 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599Ab3JXPdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:33:33 -0400
Message-ID: <52693DC1.1060503@ti.com>
Date: Thu, 24 Oct 2013 21:03:21 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: <devicetree@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <kyungmin.park@samsung.com>, <t.figa@samsung.com>,
        <sw0312.kim@samsung.com>, <inki.dae@samsung.com>,
        <rahul.sharma@samsung.com>, <kgene.kim@samsung.com>,
        <s.nawrocki@samsung.com>, <thomas.abraham@linaro.org>,
        <mturquette@linaro.org>
Subject: Re: [RFC 05/12] phy: use of_phy_simple_xlate for NULL xlate function
References: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com> <1382365111-6533-6-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1382365111-6533-6-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 21 October 2013 07:48 PM, Tomasz Stanislawski wrote:
> Use default handler of_phy_simple_xlate() when NULL is passed as argument to
> of_phy_provider_register().
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>  drivers/phy/phy-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index 03cf8fb..c38ae1e7 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -575,7 +575,7 @@ struct phy_provider *__of_phy_provider_register(struct device *dev,
>  
>  	phy_provider->dev = dev;
>  	phy_provider->owner = owner;
> -	phy_provider->of_xlate = of_xlate;
> +	phy_provider->of_xlate = of_xlate ? of_xlate : of_phy_simple_xlate;

Lets allow the phy provider to pass the correct of_xlate (of_phy_simple_xlate
is exported anyway). Instead you can modify the patch to check for of_xlate and
do a WARN if it is NULL.

Thanks
Kishon
