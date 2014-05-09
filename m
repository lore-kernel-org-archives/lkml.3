Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaEIKp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:45:58 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61916 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaEIKp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:45:56 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-82-536cb1e187b6
Message-id: <536CB1EF.2090204@samsung.com>
Date: Fri, 09 May 2014 12:46:07 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Rob Herring <robherring2@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Grant Likely <grant.likely@linaro.org>, benh@kernel.crashing.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 1/6] of: align RESERVEDMEM_OF_DECLARE function callbacks to
 other callbacks
References: <1399587823-17701-1-git-send-email-robherring2@gmail.com>
 <1399587823-17701-2-git-send-email-robherring2@gmail.com>
In-reply-to: <1399587823-17701-2-git-send-email-robherring2@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xq7oPN+YEGzScVLb4O+kYu8WHplZm
	i/lHzrFaHPizg9GiefF6NotNj6+xWlzeNYfN4v+eHewW3799Y3Pg9Pj9axKjx85Zd9k9et60
	sHpsWtXJ5nHn2h42j/1z17B7bF5S7/F5k1wARxSXTUpqTmZZapG+XQJXxr7zx5kK/vJVrJvU
	ztbAOIuni5GTQ0LARGL7tSUsELaYxIV769lAbCGBpYwSt7aqdTFyAdmfGCUWPHjLDJLgFdCS
	+H/jKiOIzSKgKrHv9TwmEJtNwFCi620XWLOoQIzE7s8LGSHqBSV+TL7HAjJIRKCTUWLP8tlM
	IA6zwHZGiQmrt4JNFRZIlHg2cQ07xOpGRomZXWogNqeAm8SV+6/AapgFzCQetayDsuUlNq95
	yzyBUWAWkiWzkJTNQlK2gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIZHzZwbj4mNUh
	RgEORiUe3hfRGcFCrIllxZW5hxglOJiVRHifTc8JFuJNSaysSi3Kjy8qzUktPsTIxMEp1cAo
	dypQ7BP3NuWci/Jr966oL4lZsnHdn8MmczYJOrXuPuj7xvLF2u9Hf90zcWHv2ebWvyJPMyGr
	aPOM8NMrTtq0zOVmL3qTEjpPdV3UgkOfZ63IarH5urG/Y/F+NxvWN37iN+/t98uN8hW4X6d8
	fU/swk96q725vc7MWJvWL6Yqr/poyfdbf9YYKLEUZyQaajEXFScCAOIwN7RqAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-05-09 00:23, Rob Herring wrote:
> From: Rob Herring <robh@kernel.org>
>
> All the parameters for RESERVEDMEM_OF_DECLARE function callbacks are
> members of struct reserved_mem, so just pass the struct ptr to callback
> functions so the function callback is more in line with other OF match
> table callbacks.
>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Signed-off-by: Rob Herring <robh@kernel.org>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/of/of_reserved_mem.c    | 2 +-
>   include/linux/of_reserved_mem.h | 4 ++--
>   2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index e420eb5..632aae8 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -188,7 +188,7 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem)
>   		if (!of_flat_dt_is_compatible(rmem->fdt_node, compat))
>   			continue;
>   
> -		if (initfn(rmem, rmem->fdt_node, rmem->name) == 0) {
> +		if (initfn(rmem) == 0) {
>   			pr_info("Reserved memory: initialized node %s, compatible id %s\n",
>   				rmem->name, compat);
>   			return 0;
> diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
> index 9b1fbb7..4c81b84 100644
> --- a/include/linux/of_reserved_mem.h
> +++ b/include/linux/of_reserved_mem.h
> @@ -21,8 +21,8 @@ struct reserved_mem_ops {
>   				  struct device *dev);
>   };
>   
> -typedef int (*reservedmem_of_init_fn)(struct reserved_mem *rmem,
> -				      unsigned long node, const char *uname);
> +typedef int (*reservedmem_of_init_fn)(struct reserved_mem *rmem);
> +
>   
>   #ifdef CONFIG_OF_RESERVED_MEM
>   void fdt_init_reserved_mem(void);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

