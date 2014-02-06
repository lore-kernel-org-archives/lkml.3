Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbaBFAv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 19:51:29 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47778 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbaBFAv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 19:51:28 -0500
Message-ID: <52F2DC6F.8070005@ti.com>
Date: Wed, 5 Feb 2014 19:50:55 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ARM: mm: Fix the memblock allocation for LPAE machines
References: <1391285687-20534-1-git-send-email-santosh.shilimkar@ti.com> <52F2CBC0.3030305@ti.com> <20140205234815.GU26684@n2100.arm.linux.org.uk>
In-Reply-To: <20140205234815.GU26684@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 February 2014 06:48 PM, Russell King - ARM Linux wrote:
> On Wed, Feb 05, 2014 at 06:39:44PM -0500, Santosh Shilimkar wrote:
>> Russell,
>>
>> On Saturday 01 February 2014 03:14 PM, Santosh Shilimkar wrote:
>>> Commit ad6492b8 added much needed memblock_virt_alloc_low() and further
>>> commit 07bacb3 {memblock, bootmem: restore goal for alloc_low} fixed the
>>> issue with low memory limit thansk to Yinghai. But even after all these fixes,
>>> there is still one case where the limit check done with ARCH_LOW_ADDRESS_LIMIT
>>> for low memory fails. Russell pointed out the issue with 32 bit LPAE machines
>>> in below thread.
>>> 	https://lkml.org/lkml/2014/1/28/364
>>>
>>> Since on some LPAE machines where memory start address is beyond 4GB,
>>> the low memory marker in memblock will be set to default
>>> ARCH_LOW_ADDRESS_LIMIT which is wrong. We can fix this by letting
>>> architectures set the ARCH_LOW_ADDRESS_LIMIT using another export
>>> similar to memblock_set_current_limit() but am not sure whether
>>> its worth the trouble. Tell me if you think otherwise.
>>>
>>> Rather am just trying to fix that one broken case using memblock_virt_alloc()
>>> in setup code since the memblock.current_limit is updated appropriately
>>> makes it work on all ARM 32 bit machines.
>>>
>>> Cc: Yinghai Lu <yinghai@kernel.org>
>>> Cc: Russell King <linux@arm.linux.org.uk>
>>> Cc: Strashko, Grygorii <grygorii.strashko@ti.com>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>> ---
>> Whats you say here ? We should get the fix for the
>> issue. If you are ok, I can drop the patch in patch system.
> 
> Is this still an issue, or has Tejun fixed it by some other means?  I've not
> noticed anything being broken at the moment.
> 
> Can you confirm whether we still have an issue without this patch please?
> 
Fixes for all cases exist except 'LPAE + memory start beyond 4 GB'.
This case is still broken and  hence I posted the $subject patch.

Regards,
Santosh

