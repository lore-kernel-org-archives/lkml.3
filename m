Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaKJJDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:03:32 -0500
Received: from numascale.com ([213.162.240.84]:34749 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbaKJJDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:03:30 -0500
Message-ID: <54607F54.2050707@numascale.com>
Date: Mon, 10 Nov 2014 17:03:16 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
CC: Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] x86: Drop redundant memory-block sizing code
References: <ojh5M-xh-17@gated-at.bofh.it> <1415249414-20888-1-git-send-email-daniel@numascale.com> <20141106094007.GA4849@pd.tnic> <545B4E84.7050707@numascale.com> <20141106104034.GB4849@pd.tnic> <545B5735.8000401@numascale.com> <20141106115636.GA4318@pd.tnic>
In-Reply-To: <20141106115636.GA4318@pd.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 07:56 PM, Borislav Petkov wrote:
> On Thu, Nov 06, 2014 at 07:10:45PM +0800, Daniel J Blueman wrote:
>> "As the first check for 64GB or larger memory returns a 2GB memory
>> block size in that case, the following check for less than 64GB will
>> always
>
> Right, but why isn't there a simple else? Instead, the >64GB case is
> looking at totalram_pages but the so-called else case is looking at
> max_pfn. Why, what's the difference?
>
> My purely hypothetical suspicion is this thing used to handle some
> special case with memory holes where totalram_pages was still < 64GB but
> max_pfn was above. I'm looking at this memory block size approximation
> downwards which supposedly used to do something at some point, right?
>
> Now, when you remove this, it doesn't do so anymore, potentially
> breaking some machines.
>
> Or is this simply unfortunate coding and totalram_pages and max_pfn are
> equivalent?
>
> Questions over questions... Maybe it is time for some git log
> archeology...

Yes, totalram_pages doesn't count the MMIO hole, whereas max_pfn does.

I've made NumaConnect firmware changes that will guarantee max_pfn is 
always aligned to at least 2GB, so 
bdee237c0343a5d1a6cf72c7ea68e88338b26e08 "x86: mm: Use 2GB memory block 
size on large-memory x86-64 systems" can be dropped and Yinghai's 
approach will give 2GB memory blocks on our systems.

Thanks,
   Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
