Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaDDBab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 21:30:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57255 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaDDBa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 21:30:28 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <533E0B0E.9020909@jp.fujitsu.com>
Date: Fri, 4 Apr 2014 10:29:50 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Li Zhong <zhong@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, <nfont@linux.vnet.ibm.com>,
        <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] memory driver: make phys_index/end_phys_index reflect
 the start/end section number
References: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com>
In-Reply-To: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/02 17:56), Li Zhong wrote:
> I noticed the phys_index and end_phys_index under
> /sys/devices/system/memory/memoryXXX/ have the same value, e.g.
> (for the test machine, one memory block has 8 sections, that is
>   sections_per_block equals 8)
>
> # cd /sys/devices/system/memory/memory100/
> # cat phys_index end_phys_index
> 00000064
> 00000064
>
> Seems they should reflect the start/end section number respectively, which
> also matches what is said in Documentation/memory-hotplug.txt
>
> This patch tries to modify that so the two files could show the start/end
> section number of the memory block.
>
> After this change, output of the above example looks like:
>
> # cat phys_index end_phys_index
> 00000320
> 00000327
>
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> ---

Good catch! This is a bug. So I think the bug should be fixed.

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>   drivers/base/memory.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index bece691..b10f2fa 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -114,7 +114,7 @@ static ssize_t show_mem_start_phys_index(struct device *dev,
>   	struct memory_block *mem = to_memory_block(dev);
>   	unsigned long phys_index;
>
> -	phys_index = mem->start_section_nr / sections_per_block;
> +	phys_index = mem->start_section_nr;
>   	return sprintf(buf, "%08lx\n", phys_index);
>   }
>
> @@ -124,7 +124,7 @@ static ssize_t show_mem_end_phys_index(struct device *dev,
>   	struct memory_block *mem = to_memory_block(dev);
>   	unsigned long phys_index;
>
> -	phys_index = mem->end_section_nr / sections_per_block;
> +	phys_index = mem->end_section_nr;
>   	return sprintf(buf, "%08lx\n", phys_index);
>   }
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


