Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaKXPbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:31:38 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50406 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaKXPbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:31:37 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18BmrJq2BWMyJzxjpzrcJLn
Date: Mon, 24 Nov 2014 07:28:37 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: linux-next: manual merge of the v4l-dvb tree with the arm-soc
 tree
Message-ID: <20141124152836.GA2817@atomide.com>
References: <20141124132214.2f756b6a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124132214.2f756b6a@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [141123 18:24]:
> Hi Mauro,
> 
> Today's linux-next merge of the v4l-dvb tree got a conflict in
> arch/arm/mach-omap2/devices.c between commit e7e42b9d2a7f ("ARM:
> OMAP4+: Remove unused omap_l3_noc platform init") from the arm-soc tree
> and commit 1b65729a186b ("[media] mach-omap2: remove deprecated
> VIDEO_OMAP2 support") from the v4l-dvb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Oops, that's a self-inflicted merge conflict, sorry. I should have
waited a bit longer on the removal of the now unnecessary l3_init.

Anyways, the resolution is correct thanks.

Regards,

Tony

> diff --cc arch/arm/mach-omap2/devices.c
> index 492ef1607115,1b623a06cdcd..000000000000
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@@ -67,28 -67,40 +67,6 @@@ static int __init omap3_l3_init(void
>   }
>   omap_postcore_initcall(omap3_l3_init);
>   
> - #if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
>  -static int __init omap4_l3_init(void)
>  -{
>  -	int i;
>  -	struct omap_hwmod *oh[3];
>  -	struct platform_device *pdev;
>  -	char oh_name[L3_MODULES_MAX_LEN];
> --
> - static struct resource omap2cam_resources[] = {
> - 	{
> - 		.start		= OMAP24XX_CAMERA_BASE,
> - 		.end		= OMAP24XX_CAMERA_BASE + 0xfff,
> - 		.flags		= IORESOURCE_MEM,
> - 	},
> - 	{
> - 		.start		= 24 + OMAP_INTC_START,
> - 		.flags		= IORESOURCE_IRQ,
>  -	/* If dtb is there, the devices will be created dynamically */
>  -	if (of_have_populated_dt())
>  -		return -ENODEV;
>  -
>  -	/*
>  -	 * To avoid code running on other OMAPs in
>  -	 * multi-omap builds
>  -	 */
>  -	if (!cpu_is_omap44xx() && !soc_is_omap54xx())
>  -		return -ENODEV;
>  -
>  -	for (i = 0; i < L3_MODULES; i++) {
>  -		snprintf(oh_name, L3_MODULES_MAX_LEN, "l3_main_%d", i+1);
>  -
>  -		oh[i] = omap_hwmod_lookup(oh_name);
>  -		if (!(oh[i]))
>  -			pr_err("could not look up %s\n", oh_name);
> --	}
> - };
> --
> - static struct platform_device omap2cam_device = {
> - 	.name		= "omap24xxcam",
> - 	.id		= -1,
> - 	.num_resources	= ARRAY_SIZE(omap2cam_resources),
> - 	.resource	= omap2cam_resources,
> - };
> - #endif
>  -	pdev = omap_device_build_ss("omap_l3_noc", 0, oh, 3, NULL, 0);
>  -
>  -	WARN(IS_ERR(pdev), "could not build omap_device for %s\n", oh_name);
>  -
>  -	return PTR_RET(pdev);
>  -}
>  -omap_postcore_initcall(omap4_l3_init);
> --
>   #if defined(CONFIG_IOMMU_API)
>   
>   #include <linux/platform_data/iommu-omap.h>


