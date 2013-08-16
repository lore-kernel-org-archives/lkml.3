Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab3HPMag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 08:30:36 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:13888 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3HPMad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 08:30:33 -0400
Message-ID: <520E1B62.1060501@nsn.com>
Date: Fri, 16 Aug 2013 14:30:26 +0200
From: Alexander Sverdlin <alexander.sverdlin@nsn.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: ext Wladislav Wiebe <wladislav.kw@gmail.com>
CC: grant.likely@linaro.org, rob.herring@calxeda.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] of: fdt: fix memory initialization for expanded DT
References: <5208C04A.5000303@gmail.com>
In-Reply-To: <5208C04A.5000303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 1944
X-purgate-ID: 151667::1376656227-00003561-91DB344C/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 08/12/2013 01:00 PM, ext Wladislav Wiebe wrote:
> Already existing property flags are filled wrong for properties created from
> initial FDT. This could cause problems if this DYNAMIC device-tree functions
> are used later, i.e. properties are attached/detached/replaced. Simply dumping
> flags from the running system show, that some initial static (not allocated via
> kzmalloc()) nodes are marked as dynamic.
> 
> I putted some debug extensions to property_proc_show(..) :
> ..
> +       if (OF_IS_DYNAMIC(pp))
> +               pr_err("DEBUG: xxx : OF_IS_DYNAMIC\n");
> +       if (OF_IS_DETACHED(pp))
> +               pr_err("DEBUG: xxx : OF_IS_DETACHED\n");
> 
> when you operate on the nodes (e.g.: ~$ cat /proc/device-tree/*some_node*) you
> will see that those flags are filled wrong, basically in most cases it will dump
> a DYNAMIC or DETACHED status, which is in not true.
> (BTW. this OF_IS_DETACHED is a own define for debug purposes which which just
> make a test_bit(OF_DETACHED, &x->_flags)
> 
> If nodes are dynamic kernel is allowed to kfree() them. But it will crash
> attempting to do so on the nodes from FDT -- they are not allocated via
> kzmalloc().
> 
> Signed-off-by: Wladislav Wiebe <wladislav.kw@gmail.com>

Acked-by: Alexander Sverdlin <alexander.sverdlin@nsn.com>

> ---
>  drivers/of/fdt.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 6bb7cf2..b10ba00 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -392,6 +392,8 @@ static void __unflatten_device_tree(struct boot_param_header *blob,
>  	mem = (unsigned long)
>  		dt_alloc(size + 4, __alignof__(struct device_node));
> 
> +	memset((void *)mem, 0, size);
> +
>  	((__be32 *)mem)[size / 4] = cpu_to_be32(0xdeadbeef);
> 
>  	pr_debug("  unflattening %lx...\n", mem);
> 

-- 
Best regards,
Alexander Sverdlin.
