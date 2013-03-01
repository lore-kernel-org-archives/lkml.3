Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab3CAHJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:09:29 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:58213 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3CAHJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:09:28 -0500
Date: Fri, 1 Mar 2013 16:09:25 +0900
From: Simon Horman <horms@verge.net.au>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org,
        vladimir.barinov@cogentembedded.com, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] <linux/of_platform.h>: fix compilation warnings with DT
 disabled
Message-ID: <20130301070925.GA24369@verge.net.au>
References: <201302190258.25726.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201302190258.25726.sergei.shtylyov@cogentembedded.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 02:58:25AM +0300, Sergei Shtylyov wrote:
> Fix the following compilation warnings (in Simon Horman's renesas.git repo):
> 
> In file included from arch/arm/mach-shmobile/setup-r8a7779.c:24:0:
> include/linux/of_platform.h:107:13: warning: ‘struct of_device_id’ declared
> inside parameter list [enabled by default]
> include/linux/of_platform.h:107:13: warning: its scope is only this definition
> or declaration, which is probably not what you want [enabled by default]
> include/linux/of_platform.h:107:13: warning: ‘struct device_node’ declared
> inside parameter list [enabled by default]
> 
> <linux/of_platform.h> only #include's headers with definitions of the above
> mentioned structures if CONFIG_OF_DEVICE=y but uses them even if not. One
> solution is to move some #include's out of #ifdef CONFIG_OF_DEVICE and use
> incomplete declarations for the rest of the structures where the #ifdef move
> doesn't help...
> 
> Reported-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>

Grant, could you consider taking this patch?

> ---
> Actually, it compiles eve without 'struct device_node' declared, I haven't
> found the reason of this, so left it there...
> 
>  include/linux/of_platform.h |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux/include/linux/of_platform.h
> ===================================================================
> --- linux.orig/include/linux/of_platform.h
> +++ linux/include/linux/of_platform.h
> @@ -11,9 +11,10 @@
>   *
>   */
>  
> -#ifdef CONFIG_OF_DEVICE
>  #include <linux/device.h>
>  #include <linux/mod_devicetable.h>
> +
> +#ifdef CONFIG_OF_DEVICE
>  #include <linux/pm.h>
>  #include <linux/of_device.h>
>  #include <linux/platform_device.h>
> @@ -100,7 +101,7 @@ extern int of_platform_populate(struct d
>  
>  #if !defined(CONFIG_OF_ADDRESS)
>  struct of_dev_auxdata;
> -struct device;
> +struct device_node;
>  static inline int of_platform_populate(struct device_node *root,
>  					const struct of_device_id *matches,
>  					const struct of_dev_auxdata *lookup,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
