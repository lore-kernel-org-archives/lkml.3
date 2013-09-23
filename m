Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3IWOYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:24:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18337 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3IWOYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:24:12 -0400
Message-ID: <52404F4B.3000207@oracle.com>
Date: Mon, 23 Sep 2013 10:25:15 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com,
        xen-devel@lists.xen.org
Subject: Re: [Xen-devel] [PATCH v1 3/5] xen/PMU: Initialization code for Xen
 PMU
References: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com> <1378827110-4192-4-git-send-email-boris.ostrovsky@oracle.com> <20130923132618.GD3175@phenom.dumpdata.com> <52404DBD.6010607@oracle.com>
In-Reply-To: <52404DBD.6010607@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 10:18 AM, Boris Ostrovsky wrote:
> On 09/23/2013 09:26 AM, Konrad Rzeszutek Wilk wrote:
>> On Tue, Sep 10, 2013 at 11:31:48AM -0400, Boris Ostrovsky wrote:
>>> Map shared data structure that will hold CPU registers, VPMU context,
>>> VCPU/PCPI IDs of the VCPU interrupted by PMU interrupt. Hypervisor
>>> fills this information in its handler and passes it to the guest for
>>> further processing.
>>>
>>> Set up PMU VIRQ.
>>>
>>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>>> ---
>>>   arch/x86/xen/Makefile          |   2 +-
>>>   arch/x86/xen/pmu.c             | 122 
>>> +++++++++++++++++++++++++++++++++++++++++
>>>   arch/x86/xen/pmu.h             |  12 ++++
>>>   arch/x86/xen/smp.c             |  31 ++++++++++-
>>>   include/xen/interface/xen.h    |   1 +
>>>   include/xen/interface/xenpmu.h |  77 ++++++++++++++++++++++++++
>>>   6 files changed, 243 insertions(+), 2 deletions(-)
>>>   create mode 100644 arch/x86/xen/pmu.c
>>>   create mode 100644 arch/x86/xen/pmu.h
>>>
>>> diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
>>> index 96ab2c0..b187df5 100644
>>> --- a/arch/x86/xen/Makefile
>>> +++ b/arch/x86/xen/Makefile
>>> @@ -13,7 +13,7 @@ CFLAGS_mmu.o            := $(nostackp)
>>>   obj-y        := enlighten.o setup.o multicalls.o mmu.o irq.o \
>>>               time.o xen-asm.o xen-asm_$(BITS).o \
>>>               grant-table.o suspend.o platform-pci-unplug.o \
>>> -            p2m.o
>>> +            p2m.o pmu.o
>> Perhaps guard the build of this based on CONFIG_PERF_EVENTS?
>>
>> That would of course mean you also have to create in xenpmu.h
>> static inline empy functions for xen_pmu_finish and xen_pmu_init in case
>> CONFIG_PERF_EVENTS is not set.
>
> This is interface header, am I allowed to do those sorts of things there?

Never mind that, I was thinking of a different file. Sorry.

>
> Also, *theoretically* other performance-measuring tools can use this 
> framework, expect for perf-specific things like callbacks and the 
> handler call. So maybe I should put CONFIG_PERF_EVENTS in pmu.c?
>

-boris

