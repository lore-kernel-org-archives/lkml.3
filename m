Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934849AbaKLDQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:16:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33444 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbaKLDQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 22:16:56 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5462D0F5.1050008@jp.fujitsu.com>
Date: Wed, 12 Nov 2014 12:16:05 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Zhang Zhen <zhenzhang.zhang@huawei.com>
CC: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Linux MM <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <wangnan0@huawei.com>
Subject: Re: [PATCH] memory-hotplug: remove redundant call of page_to_pfn
References: <1415697184-26409-1-git-send-email-zhenzhang.zhang@huawei.com> <5461D343.60803@huawei.com>
In-Reply-To: <5461D343.60803@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/11 18:13), Zhang Zhen wrote:
> The start_pfn can be obtained directly by
> phys_index << PFN_SECTION_SHIFT.
>
> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
> ---

The patch looks good to me but I want you to write a purpose of the patch
to the description for other reviewer.

Thanks,
Yasuaki Ishimatsu

>   drivers/base/memory.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 7c5d871..85be040 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -228,8 +228,8 @@ memory_block_action(unsigned long phys_index, unsigned long action, int online_t
>   	struct page *first_page;
>   	int ret;
>
> -	first_page = pfn_to_page(phys_index << PFN_SECTION_SHIFT);
> -	start_pfn = page_to_pfn(first_page);
> +	start_pfn = phys_index << PFN_SECTION_SHIFT;
> +	first_page = pfn_to_page(start_pfn);
>
>   	switch (action) {
>   		case MEM_ONLINE:
>


