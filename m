Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaL2VL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 16:11:28 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47703 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbaL2VL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 16:11:27 -0500
Message-ID: <54A1C37D.5000106@codeaurora.org>
Date: Mon, 29 Dec 2014 13:11:25 -0800
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Stefan I. Strogin" <s.strogin@partner.samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, aneesh.kumar@linux.vnet.ibm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dmitry Safonov <d.safonov@partner.samsung.com>,
        Pintu Kumar <pintu.k@samsung.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        SeongJae Park <sj38.park@gmail.com>, Hui Zhu <zhuhui@xiaomi.com>,
        Minchan Kim <minchan@kernel.org>, Dyasly Sergey <s.dyasly@samsung.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Subject: Re: [PATCH 2/3] mm: cma: introduce /proc/cmainfo
References: <cover.1419602920.git.s.strogin@partner.samsung.com> <264ce8ad192124f2afec9a71a2fc28779d453ba7.1419602920.git.s.strogin@partner.samsung.com>
In-Reply-To: <264ce8ad192124f2afec9a71a2fc28779d453ba7.1419602920.git.s.strogin@partner.samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2014 6:39 AM, Stefan I. Strogin wrote:
> /proc/cmainfo contains a list of currently allocated CMA buffers for every
> CMA area when CONFIG_CMA_DEBUG is enabled.
>
> Format is:
>
> <base_phys_addr> - <end_phys_addr> (<size> kB), allocated by <PID>\
> 		(<command name>), latency <allocation latency> us
>   <stack backtrace when the buffer had been allocated>
>
> Signed-off-by: Stefan I. Strogin <s.strogin@partner.samsung.com>
> ---
...
> +static int __init proc_cmainfo_init(void)
> +{
> +	proc_create("cmainfo", S_IRUSR, NULL, &proc_cmainfo_operations);
> +	return 0;
> +}
> +
> +module_init(proc_cmainfo_init);
> +#endif /* CONFIG_CMA_DEBUG */
>

This seems better suited to debugfs over procfs, especially since the
option can be turned off. It would be helpful to break it
down by cma region as well to make it easier on systems with a lot
of regions.

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
