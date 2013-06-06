Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab3FFGzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 02:55:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55492 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab3FFGzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 02:55:00 -0400
Date: Thu, 6 Jun 2013 08:54:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: Magnus Damm <magnus.damm@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Vinod Koul <vinod.koul@intel.com>, Tony Lindgren <tony@atomide.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 4/4] OF: modify function stubs to match proper function
 declarations.
In-Reply-To: <1367305883-2997-5-git-send-email-g.liakhovetski@gmx.de>
Message-ID: <Pine.LNX.4.64.1306060852070.32566@axis700.grange>
References: <1367305883-2997-1-git-send-email-g.liakhovetski@gmx.de>
 <1367305883-2997-5-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:Msuf5mM+lbcoUn8G3fjeNI2xnLX26pUtK6NL6xJTOjd
 pLbU2VeaY6nosjPtptPpWGc/j08BkONc5/AmdwPV22k2qMdKjx
 7AufL/gPKmeVFaTauIr3Z4JDuprVSgWUqpwmPaj8e8FBGugZBh
 XTGTDcWnpYqFWhlI3XV7SQXGBTtWftZxyrAKFQz6+2Y5BU2khj
 8C4igedAGp9kMP1Cf5N2P3kdFCvtVaJZlBj/fzTM5ZZtR9n5YU
 o0QP34lk0II1hnTB7Z9yOz0LNmam4qJKZwK2vQTdfAeGhitNxq
 6krMShl55pUvFy53Ts8t2J2uDpwHb08nNYmCqlthy9CvbEulBc
 GdKsELWZBGCHuwcqGyOKc3jH35948lfw9nilsDLdGVUV5KkcAz
 zMOpdUc3f/L1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, 30 Apr 2013, Guennadi Liakhovetski wrote:

> of_parse_phandle_with_args() and of_count_phandle_with_args() functions
> are declared with their first parameter as const. However, their
> respective stubs, used when CONFIG_OF isn't defined, don't have the "const"
> modifier. This patch adds it to fix the mismatch.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> ---
>  include/linux/of.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

This patch is a trivial fix and doesn't actually depend on others in this 
series, any reason it hasn't been applied yet?

Thanks
Guennadi

> diff --git a/include/linux/of.h b/include/linux/of.h
> index 30ae71f..d9dbf73 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -466,7 +466,7 @@ static inline struct device_node *of_parse_phandle(const struct device_node *np,
>  	return NULL;
>  }
>  
> -static inline int of_parse_phandle_with_args(struct device_node *np,
> +static inline int of_parse_phandle_with_args(const struct device_node *np,
>  					     const char *list_name,
>  					     const char *cells_name,
>  					     int index,
> @@ -485,7 +485,7 @@ static inline int of_parse_phandle_with_child_args(const struct device_node *np,
>  	return -ENOSYS;
>  }
>  
> -static inline int of_count_phandle_with_args(struct device_node *np,
> +static inline int of_count_phandle_with_args(const struct device_node *np,
>  					     const char *list_name,
>  					     const char *cells_name)
>  {
> -- 
> 1.7.2.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
