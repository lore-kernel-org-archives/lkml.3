Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaJ0PP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:15:56 -0400
Received: from mail-bl2on0122.outbound.protection.outlook.com ([65.55.169.122]:61120
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751523AbaJ0PPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:15:55 -0400
X-WSS-ID: 0NE3ZQB-08-MMT-02
X-M-MSG: 
Message-ID: <544E61A1.7090400@amd.com>
Date: Mon, 27 Oct 2014 17:15:45 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joerg Roedel <jroedel@suse.de>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm: export find_extend_vma and handle_mm_fault for
 driver use
References: <1414179271-7621-1-git-send-email-jbarnes@virtuousgeek.org>
 <20141027151327.GE9734@suse.de>
In-Reply-To: <20141027151327.GE9734@suse.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(24454002)(51704005)(479174003)(377454003)(164054003)(87936001)(65956001)(65806001)(76176999)(107046002)(95666004)(99396003)(106466001)(87266999)(120916001)(47776003)(50986999)(54356999)(65816999)(85306004)(105586002)(85852003)(20776003)(76482002)(36756003)(101416001)(92566001)(80316001)(92726001)(575784001)(19580405001)(19580395003)(64126003)(68736004)(110136001)(102836001)(23746002)(83506001)(33656002)(64706001)(86362001)(50466002)(80022003)(46102003)(84676001)(21056001)(4396001)(31966008)(97736003)(44976005);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Forefront-PRVS: 0377802854
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure, no problem

     Oded

On 10/27/2014 05:13 PM, Joerg Roedel wrote:

Hi Oded,

can you please test these patches with the KFD driver and make sure
nothing breaks for you? I really like this improvement and it would be
great to send it upstream for v3.19.

Thanks,

	Joerg

On Fri, Oct 24, 2014 at 12:34:30PM -0700, Jesse Barnes wrote:

> This lets drivers like the AMD IOMMUv2 driver handle faults a bit more
> simply, rather than doing tricks with page refs and get_user_pages().
>
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>   mm/memory.c | 1 +
>   mm/mmap.c   | 2 ++
>   2 files changed, 3 insertions(+)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 1cc6bfb..969ff0c 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3378,6 +3378,7 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>   
>   	return ret;
>   }
> +EXPORT_SYMBOL_GPL(handle_mm_fault);
>   
>   #ifndef __PAGETABLE_PUD_FOLDED
>   /*
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 7f85520..2ee7971 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2359,6 +2359,8 @@ find_extend_vma(struct mm_struct *mm, unsigned long addr)
>   }
>   #endif
>   
> +EXPORT_SYMBOL_GPL(find_extend_vma);
> +
>   /*
>    * Ok - we have the memory areas we should free on the vma list,
>    * so release them, and do the vma updates.
> -- 
> 1.9.1

