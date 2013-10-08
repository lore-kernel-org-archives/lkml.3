Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3JHNHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:07:32 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:33633 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab3JHNH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:07:29 -0400
Message-ID: <52540388.8090709@gmail.com>
Date: Tue, 08 Oct 2013 08:07:20 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Majunath Goudar <csmanjuvijay@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, nataraja.km@lge.com,
        Grant Likely <grant.likely@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VEXPRESS: Fix VEXPRESS implicit declarations dependence
 errors.
References: <1381228895-24814-1-git-send-email-csmanjuvijay@gmail.com>
In-Reply-To: <1381228895-24814-1-git-send-email-csmanjuvijay@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 05:41 AM, Majunath Goudar wrote:
> This patch adds a of_find_node_by_phandle() and of_get_next_parent()
> function declaration dependence on"#ifdef CONFIG_OF" in "include/linux/of.h"
> else part return inline dummy implementations (returning NULL). Without
> this patch,build system can lead to issues. This was discovered during
> randconfig testing,in which VEXPRESS_CONFIG was enabled w/o CONFIG_OF
> being enabled,leading to the following error:

What is blocking making VExpress DT only?

The subject should reflect the subsystem you are changing and the
description is missing spaces at a minimum.

Rob

> 
> CC      drivers/mfd/vexpress-config.o
> drivers/mfd/vexpress-config.c: In function ‘__vexpress_config_func_get’:
> drivers/mfd/vexpress-config.c:117:4: error: implicit declaration of function
> ‘of_find_node_by_phandle’ [-Werror=implicit-function-declaration]
>     bridge_node = of_find_node_by_phandle(
>     ^
> drivers/mfd/vexpress-config.c:117:16: warning: assignment makes pointer from
> integer without a cast [enabled by default]
>     bridge_node = of_find_node_by_phandle(
> 
> Signed-off-by: Manjunath Goudar <csmanjuvijay@gmail.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: devicetree@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  include/linux/of.h |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index f95aee3..968787d 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -340,6 +340,15 @@ int of_device_is_stdout_path(struct device_node *dn);
>  
>  #else /* CONFIG_OF */
>  
> +static inline struct device_node *of_find_node_by_phandle(phandle handle)
> +{
> +	return NULL;
> +}
> +static inline struct device_node *of_get_next_parent(struct device_node *node)
> +{
> +	return NULL;
> +}
> +
>  static inline const char* of_node_full_name(struct device_node *np)
>  {
>  	return "<no-node>";
> 

