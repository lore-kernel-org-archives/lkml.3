Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966304Ab3DQMIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 08:08:14 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:38361 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966251Ab3DQMIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 08:08:12 -0400
Message-ID: <516E9096.70906@linux.vnet.ibm.com>
Date: Wed, 17 Apr 2013 17:37:50 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linuxppc-dev@ozlabs.org, mikey@neuling.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 5/5] powerpc, perf: Enable branch stack sampling framework
 support with BHRB
References: <1366127650-1952-1-git-send-email-khandual@linux.vnet.ibm.com> <1366127650-1952-6-git-send-email-khandual@linux.vnet.ibm.com> <20130417070852.GA29203@concordia>
In-Reply-To: <20130417070852.GA29203@concordia>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041712-2674-0000-0000-000008A1D5C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 12:38 PM, Michael Ellerman wrote:
> On Tue, Apr 16, 2013 at 09:24:10PM +0530, Anshuman Khandual wrote:
>> This patch provides basic enablement for perf branch stack sampling framework
>> on POWER8 processor with a new PMU feature called BHRB (Branch History Rolling
>> Buffer).
>>
>> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
>> ---
>>  arch/powerpc/perf/core-book3s.c     | 96 +++++++++++++++++++++++++++++++++++--
>>  arch/powerpc/perf/perf_event_bhrb.c | 85 ++++++++++++++++++++++++++++++++
>>  2 files changed, 178 insertions(+), 3 deletions(-)
>>  create mode 100644 arch/powerpc/perf/perf_event_bhrb.c
>>
>> diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
>> index 4ac6e64..f4d1347 100644
>> --- a/arch/powerpc/perf/core-book3s.c
>> +++ b/arch/powerpc/perf/core-book3s.c
>> @@ -19,6 +19,8 @@
>>  #include <asm/firmware.h>
>>  #include <asm/ptrace.h>
>>  
>> +#define BHRB_MAX_ENTRIES	32
>> +
>>  struct cpu_hw_events {
>>  	int n_events;
>>  	int n_percpu;
>> @@ -38,11 +40,21 @@ struct cpu_hw_events {
>>  
>>  	unsigned int group_flag;
>>  	int n_txn_start;
>> +
>> +	/* BHRB bits */
>> +	u64				bhrb_filter;	/* BHRB HW branch filter */
>> +	int				bhrb_users;
>> +	void				*bhrb_context;
>> +	struct	perf_branch_stack	bhrb_stack;
>> +	struct	perf_branch_entry	bhrb_entries[BHRB_MAX_ENTRIES];
>>  };
>> +
>>  DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
>>  
>>  struct power_pmu *ppmu;
>>  
>> +#include "perf_event_bhrb.c"
>> +
> 
> Um, why are you doing that?
> 

There was no specific reason for that.

> If it's code that should be in a header, put it in a header. If it's C
> code, add it to the Makefile.

Sure I would get the new code in the Makefile. Thanks!

Regards
Anshuman

> 
> cheers
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 

