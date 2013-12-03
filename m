Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab3LCKW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 05:22:27 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36137 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab3LCKWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 05:22:24 -0500
Message-ID: <529DB092.8010307@linux.vnet.ibm.com>
Date: Tue, 03 Dec 2013 15:51:06 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "mpe@ellerman.id.au" <michael@ozlabs.org>
CC: mikey@neuling.org, michaele@au1.ibm.com, linux-kernel@vger.kernel.org,
        eranian@google.com, linuxppc-dev@ozlabs.org,
        sukadev@linux.vnet.ibm.com
Subject: Re: [V3 01/10] perf: New conditional branch filter criteria in branch
 stack sampling
References: <20131126060618.917ED2C00A9@ozlabs.org> <529474C7.9050005@linux.vnet.ibm.com>
In-Reply-To: <529474C7.9050005@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120310-0260-0000-0000-00000409A3FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 03:45 PM, Anshuman Khandual wrote:
> On 11/26/2013 11:36 AM, mpe@ellerman.id.au wrote:
>> Ideally your commit subject would contain a verb, preferably in the present
>> tense.
>>
>> I think simply "perf: Add PERF_SAMPLE_BRANCH_COND" would be clearer.
> 
> 
> Sure, will change it.
> 
>>
>> On Wed, 2013-16-10 at 06:56:48 UTC, Anshuman Khandual wrote:
>>> POWER8 PMU based BHRB supports filtering for conditional branches.
>>> This patch introduces new branch filter PERF_SAMPLE_BRANCH_COND which
>>> will extend the existing perf ABI. Other architectures can provide
>>> this functionality with either HW filtering support (if present) or
>>> with SW filtering of instructions.
>>>
>>> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
>>> Reviewed-by: Stephane Eranian <eranian@google.com>
>>> ---
>>>  include/uapi/linux/perf_event.h | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
>>> index 0b1df41..5da52b6 100644
>>> --- a/include/uapi/linux/perf_event.h
>>> +++ b/include/uapi/linux/perf_event.h
>>> @@ -160,8 +160,9 @@ enum perf_branch_sample_type {
>>>  	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << 7, /* transaction aborts */
>>>  	PERF_SAMPLE_BRANCH_IN_TX	= 1U << 8, /* in transaction */
>>>  	PERF_SAMPLE_BRANCH_NO_TX	= 1U << 9, /* not in transaction */
>>> +	PERF_SAMPLE_BRANCH_COND		= 1U << 10, /* conditional branches */
>>>  
>>> -	PERF_SAMPLE_BRANCH_MAX		= 1U << 10, /* non-ABI */
>>> +	PERF_SAMPLE_BRANCH_MAX		= 1U << 11, /* non-ABI */
>>>  };
>>
>> This no longer applies against Linus' tree, you'll need to rebase it.
> 
> Okay

Hey Michael,

Looks like the patch still applies on top of Linus's tree. The modified patch with
a new commit subject line can be found here.

----------------------------------------------------------------------
>From d368096fc51a8da65f2d80ed5090d43cbc269f62 Mon Sep 17 00:00:00 2001
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Date: Mon, 22 Jul 2013 12:22:27 +0530
Subject: [PATCH] perf: Add PERF_SAMPLE_BRANCH_COND

POWER8 PMU based BHRB supports filtering for conditional branches.
This patch introduces new branch filter PERF_SAMPLE_BRANCH_COND which
will extend the existing perf ABI. Other architectures can provide
this functionality with either HW filtering support (if present) or
with SW filtering of instructions.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
---
 include/uapi/linux/perf_event.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index e1802d6..e2d8b8b 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -163,8 +163,9 @@ enum perf_branch_sample_type {
 	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << 7, /* transaction aborts */
 	PERF_SAMPLE_BRANCH_IN_TX	= 1U << 8, /* in transaction */
 	PERF_SAMPLE_BRANCH_NO_TX	= 1U << 9, /* not in transaction */
+	PERF_SAMPLE_BRANCH_COND		= 1U << 10, /* conditional branches */
 
-	PERF_SAMPLE_BRANCH_MAX		= 1U << 10, /* non-ABI */
+	PERF_SAMPLE_BRANCH_MAX		= 1U << 11, /* non-ABI */
 };
 
 #define PERF_SAMPLE_BRANCH_PLM_ALL \
-- 
1.7.11.7

