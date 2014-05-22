Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaEVDuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 23:50:51 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:35972 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaEVDuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 23:50:50 -0400
Message-ID: <537D73A6.2050403@linux.vnet.ibm.com>
Date: Thu, 22 May 2014 09:18:54 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mpe@ellerman.id.au, benh@kernel.crashing.org
Subject: Re: [V6 01/11] perf: Add PERF_SAMPLE_BRANCH_COND
References: <1400666396-1682-1-git-send-email-khandual@linux.vnet.ibm.com> <1400666396-1682-2-git-send-email-khandual@linux.vnet.ibm.com> <20140521113025.GC2485@laptop.programming.kicks-ass.net>
In-Reply-To: <20140521113025.GC2485@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052203-1396-0000-0000-000004E469E0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 05:00 PM, Peter Zijlstra wrote:
> On Wed, May 21, 2014 at 03:29:46PM +0530, Anshuman Khandual wrote:
>> This patch introduces new branch filter PERF_SAMPLE_BRANCH_COND which
>> will extend the existing perf ABI. Various architectures can provide
>> this functionality with either with HW filtering support (if present)
>> or with SW filtering of captured branch instructions.
> 
> The Changelog fails to mention what _this_ functionality is.
> 

Peter,

Hope this new change log below makes more sense.

---------------------------------------------------------------------------
commit af75191bb7ad36cba7d75c2741c93dfbdaf09da3
Author: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Date:   Mon Jul 22 12:22:27 2013 +0530

    perf: Add new conditional branch filter PERF_SAMPLE_BRANCH_COND
    
    This patch introduces new branch filter PERF_SAMPLE_BRANCH_COND which
    will extend the existing perf ABI. This will filter branches which are
    conditional. Various architectures can provide this functionality either
    with HW filtering support (if present) or with SW filtering of captured
    branch instructions.
    
    Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
    Reviewed-by: Stephane Eranian <eranian@google.com>
    Reviewed-by: Andi Kleen <ak@linux.intel.com>

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 853bc1c..696f69b4 100644
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

