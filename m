Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbaJFKEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 06:04:38 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17101 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaJFKEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 06:04:37 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-9f-5432693220ad
Message-id: <54326930.1090805@samsung.com>
Date: Mon, 06 Oct 2014 12:04:32 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, Jean Delvare <jdelvare@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH v2] cma: make default CMA area size zero for x86
References: <1412517260-3832-1-git-send-email-akinobu.mita@gmail.com>
In-reply-to: <1412517260-3832-1-git-send-email-akinobu.mita@gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e/4VV2jTKMQg8ajghavDnQwWsxZv4bN
	4si17+wWMz/sZLbon7Ga2WLiysnMFtM2ilss2G9tsfTuJzaLZYufMlpc3jWHzeLSgQVMFscu
	/WO02LxpKrPFjw2PWS3+b/nM5iDgMX/nR0aPnbPusnus+LOezWPzCi2PTas62TzenTvH7nFi
	xm8Wj8k3ljN6fHx6i8Xj/b6rQBWnqz0+b5LzONHyhTWAN4rLJiU1J7MstUjfLoEr49fkP6wF
	z0Qqtu7axNLAeFCgi5GTQ0LAROLtnDUsELaYxIV769m6GLk4hASWMkpc7ZnIBOF8YpR4Nv0C
	G0gVr4CWxNId58E6WARUJX4uX8gIYrMJGEp0ve0CquHgEBWIkXjTXgBRLijxY/I9sHIRgRSJ
	/49nM4PMZBa4xiyxcNMCdpCEsICLxLoZ68DmCwm4Srz5PhUszingJnH97h9WEJtZwEziy8vD
	ULa8xOY1b5knMArMQrJjFpKyWUjKFjAyr2IUTS1NLihOSs811CtOzC0uzUvXS87P3cQIicQv
	OxgXH7M6xCjAwajEwxuxwzBEiDWxrLgy9xCjBAezkghvfJpRiBBvSmJlVWpRfnxRaU5q8SFG
	Jg5OqQbG2PBdUdeM3q9wkHJatU/pZ9e26GsrqwKCpA/r2LrE2f/9fup8PafOXUPuG1PMpCXj
	Q8LFDntJLkrgYVmTVBhx/bHa5tXntjcITD579oONYsflezd1a+q0moS4b6gxhDeb3P1daa2n
	suWTYPhvn2x95uz7O7c/CnQP/2hwQJk5kFf0U/pchjwlluKMREMt5qLiRADZPaw6ogIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-10-05 15:54, Akinobu Mita wrote:
> This makes CMA memory area size zero for x86 in default configuration
> (doesn't change on the other architectures).  If default CMA size is
> zero, DMA_CMA is disabled.  It can be enabled by passing cma= to the
> kernel.
>
> This makes less impact on x86.  Because there is no mainline driver that
> requires it for x86, and Peter Hurley reported the performance
> regression, as this is trying to drive _all_ dma mapping allocations
> through a _very_ small window.
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Reported-by: Peter Hurley <peter@hurleysoftware.com>
> Cc: Peter Hurley <peter@hurleysoftware.com>
> Cc: Chuck Ebbert <cebbert.lkml@gmail.com>
> Cc: Jean Delvare <jdelvare@suse.de>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Don Dutile <ddutile@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: x86@kernel.org
> Cc: iommu@lists.linux-foundation.org

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
> * v2
> - Add information in help text, suggested by Chuck Ebbert
>
>   drivers/base/Kconfig | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 4e7f0ff..115882f 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -240,18 +240,24 @@ comment "Default contiguous memory area size:"
>   config CMA_SIZE_MBYTES
>   	int "Size in Mega Bytes"
>   	depends on !CMA_SIZE_SEL_PERCENTAGE
> +	default 0 if X86
>   	default 16
>   	help
>   	  Defines the size (in MiB) of the default memory area for Contiguous
> -	  Memory Allocator.
> +	  Memory Allocator.  If the size of 0 is selected, CMA is disabled by
> +	  default, but it can be enabled by passing cma=size[MG] to the kernel.
> +
>   
>   config CMA_SIZE_PERCENTAGE
>   	int "Percentage of total memory"
>   	depends on !CMA_SIZE_SEL_MBYTES
> +	default 0 if X86
>   	default 10
>   	help
>   	  Defines the size of the default memory area for Contiguous Memory
>   	  Allocator as a percentage of the total memory in the system.
> +	  If 0 percent is selected, CMA is disabled by default, but it can be
> +	  enabled by passing cma=size[MG] to the kernel.
>   
>   choice
>   	prompt "Selected region size"

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

