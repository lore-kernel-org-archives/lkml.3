Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaJBO1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:27:51 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:45450 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaJBO1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:27:50 -0400
MIME-Version: 1.0
In-Reply-To: <20141002092721.GB24016@arm.com>
References: <CAHkaATTho2U=cy8Ee0BD2oSp=4Vpb0GhTqUzEOCW0Jdw8u0ENw@mail.gmail.com>
	<20141002092721.GB24016@arm.com>
Date: Thu, 2 Oct 2014 22:27:49 +0800
Message-ID: <CAHkaATRMnUvQWnW7t=iTQ98Ka9RTNLJ3cg9xnGaco3LYRC8KLA@mail.gmail.com>
Subject: Re: [PATCH] Use phys_addr_t type for physical address (arm64)
From: Min-Hua Chen <orca.chen@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the type of physical address from unsigned long to phys_addr_t,
make valid_phys_addr_range more readable.

Signed-off-by: Min-Hua Chen <orca.chen@gmail.com>
---
 arch/arm64/include/asm/io.h |    2 +-
 arch/arm64/mm/mmap.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index e0ecdcf..f771e8b 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -243,7 +243,7 @@ extern void __iomem *ioremap_cache(phys_addr_t
phys_addr, size_t size);
  * (PHYS_OFFSET and PHYS_MASK taken into account).
  */
 #define ARCH_HAS_VALID_PHYS_ADDR_RANGE
-extern int valid_phys_addr_range(unsigned long addr, size_t size);
+extern int valid_phys_addr_range(phys_addr_t addr, size_t size);
 extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);

 extern int devmem_is_allowed(unsigned long pfn);
diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index 8ed6cb1..1d73662 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -102,7 +102,7 @@ EXPORT_SYMBOL_GPL(arch_pick_mmap_layout);
  * You really shouldn't be using read() or write() on /dev/mem.  This might go
  * away in the future.
  */
-int valid_phys_addr_range(unsigned long addr, size_t size)
+int valid_phys_addr_range(phys_addr_t addr, size_t size)
 {
     if (addr < PHYS_OFFSET)
         return 0;
-- 
1.7.10.4

On Thu, Oct 2, 2014 at 5:27 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Wed, Oct 01, 2014 at 03:26:55PM +0100, Min-Hua Chen wrote:
>> I found that valid_phys_addr_range does not use
>> phys_addr_t to describe physical address.
>> Is it better to change the type from unsigned long to phys_addr_t?
>
> Yes, that looks like a sensible change. Both types are 64-bit on arm64, so
> it shouldn't affect functionality. Can you resend as a proper patch (with
> commit message) please?
>
> Will
>
>> Signed-off-by: Min-Hua Chen<orca.chen@gmail.com>
>> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
>> index e0ecdcf..f771e8b 100644
>> --- a/arch/arm64/include/asm/io.h
>> +++ b/arch/arm64/include/asm/io.h
>> @@ -243,7 +243,7 @@ extern void __iomem *ioremap_cache(phys_addr_t
>> phys_addr, size_t size);
>>   * (PHYS_OFFSET and PHYS_MASK taken into account).
>>   */
>>  #define ARCH_HAS_VALID_PHYS_ADDR_RANGE
>> -extern int valid_phys_addr_range(unsigned long addr, size_t size);
>> +extern int valid_phys_addr_range(phys_addr_t addr, size_t size);
>>  extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
>>
>>  extern int devmem_is_allowed(unsigned long pfn);
>> diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
>> index 8ed6cb1..1d73662 100644
>> --- a/arch/arm64/mm/mmap.c
>> +++ b/arch/arm64/mm/mmap.c
>> @@ -102,7 +102,7 @@ EXPORT_SYMBOL_GPL(arch_pick_mmap_layout);
>>   * You really shouldn't be using read() or write() on /dev/mem.  This might go
>>   * away in the future.
>>   */
>> -int valid_phys_addr_range(unsigned long addr, size_t size)
>> +int valid_phys_addr_range(phys_addr_t addr, size_t size)
>>  {
>>      if (addr < PHYS_OFFSET)
>>          return 0;
>> --
>> 1.7.10.4
>>
