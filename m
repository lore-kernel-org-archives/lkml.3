Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaJ1Nsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:48:32 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:36700 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752404AbaJ1Nsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:48:31 -0400
Message-ID: <544F9EAA.5010404@hurleysoftware.com>
Date: Tue, 28 Oct 2014 09:48:26 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: CMA: test_pages_isolated failures in alloc_contig_range
References: <2457604.k03RC2Mv4q@avalon> <xa1tsii8l683.fsf@mina86.com>
In-Reply-To: <xa1tsii8l683.fsf@mina86.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +cc Andrew Morton ]

On 10/28/2014 08:38 AM, Michal Nazarewicz wrote:
> On Sun, Oct 26 2014, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>> Hello,
>>
>> I've run into a CMA-related issue while testing a DMA engine driver with 
>> dmatest on a Renesas R-Car ARM platform. 
>>
>> When allocating contiguous memory through CMA the kernel prints the following 
>> messages to the kernel log.
>>
>> [   99.770000] alloc_contig_range test_pages_isolated(6b843, 6b844) failed
>> [  124.220000] alloc_contig_range test_pages_isolated(6b843, 6b844) failed
>> [  127.550000] alloc_contig_range test_pages_isolated(6b845, 6b846) failed
>> [  132.850000] alloc_contig_range test_pages_isolated(6b845, 6b846) failed
>> [  151.390000] alloc_contig_range test_pages_isolated(6b843, 6b844) failed
>> [  166.490000] alloc_contig_range test_pages_isolated(6b843, 6b844) failed
>> [  181.450000] alloc_contig_range test_pages_isolated(6b845, 6b846) failed
>>
>> I've stripped the dmatest module down as much as possible to remove any 
>> hardware dependencies and came up with the following implementation.
> 
> Like Laura wrote, the message is not (should not be) a problem in
> itself:

[...]

> So as you can see cma_alloc will try another part of the cma region if
> test_pages_isolated fails.
> 
> Obviously, if CMA region is fragmented or there's enough space for only
> one allocation of required size isolation failures will cause allocation
> failures, so it's best to avoid them, but they are not always avoidable.
> 
> To debug you would probably want to add more debug information about the
> page (i.e. data from struct page) that failed isolation after the
> pr_warn in alloc_contig_range.

If the message does not indicate an actual problem, then its printk level is
too high. These messages have been reported when using 3.16+ distro kernels.

Regards,
Peter Hurley
