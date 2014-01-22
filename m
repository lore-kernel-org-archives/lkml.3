Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbaAVL45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:56:57 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:51873 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbaAVL4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:56:54 -0500
Message-ID: <52DFB1BC.7080000@huawei.com>
Date: Wed, 22 Jan 2014 19:55:40 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <kexec@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Geng Hui <hui.geng@huawei.com>, <linux-mm@kvack.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] ARM: Premit ioremap() to map reserved pages
References: <1390389916-8711-1-git-send-email-wangnan0@huawei.com> <1390389916-8711-2-git-send-email-wangnan0@huawei.com> <20140122114215.GZ15937@n2100.arm.linux.org.uk>
In-Reply-To: <20140122114215.GZ15937@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/22 19:42, Russell King - ARM Linux wrote:
> On Wed, Jan 22, 2014 at 07:25:14PM +0800, Wang Nan wrote:
>> This patch relaxes the restriction set by commit 309caa9cc, which
>> prohibit ioremap() on all kernel managed pages.
>>
>> Other architectures, such as x86 and (some specific platforms of) powerpc,
>> allow such mapping.
>>
>> ioremap() pages is an efficient way to avoid arm's mysterious cache control.
>> This feature will be used for arm kexec support to ensure copied data goes into
>> RAM even without cache flushing, because we found that flush_cache_xxx can't
>> reliably flush code to memory.
> 
> Yes, let's bypass the check and allow this in violation of the
> architecture specification by allowing mapping the same memory with
> different types, which leads to unpredictable behaviour.  Yes, that's
> a very good idea, because what we want to do is far more important than
> following the requirements of the architecture.
> 
> So... NAK.
> 
> Yes, flush_cache_xxx() doesn't flush back to physical RAM, that's not
> what it's defined to do - it's defined that it flushes enough of the
> cache to ensure that page table updates are safe (such as when tearing
> down a page mapping.)  So it's hardly surprising that doesn't work.
> 
> If you want to be able to have DMA access to memory, then you need to
> use an API which has been designed for that purpose, and if there isn't
> one, then you need to discuss your requirements, rather than trying to
> hack around the problem.

So what is correct API which is designed for this propose?

> 
> The issue here will be that the APIs we currently have for DMA become
> extremely expensive when you want to deal with (eg) all system RAM.
> Or, there's flush_cache_all() which should flush all levels of cache
> in the system, and thus push all data back to RAM.
> 
> Now, why are you copying your patches to the stable people?  That makes
> no sense - they haven't been reviewed and they haven't been integrated
> into an existing kernel.  So, they don't meet the basic requirements
> for stable tree submission...
> 


