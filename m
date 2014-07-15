Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbaGOLSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:18:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:18607 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758039AbaGOLSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:18:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,665,1400050800"; 
   d="scan'208";a="562002851"
Message-ID: <53C50DCC.9020000@intel.com>
Date: Tue, 15 Jul 2014 14:17:32 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf: Fix missing vdso name in mmap events for x86
References: <1405419844-3915-1-git-send-email-adrian.hunter@intel.com> <20140715110852.GI6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140715110852.GI6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 02:08 PM, Peter Zijlstra wrote:
> On Tue, Jul 15, 2014 at 01:24:04PM +0300, Adrian Hunter wrote:
>> Commit 78d683e838a60ec4ba4591cca4364cba84a9e626
>> added vm_ops->name as an alternative to arch_vma_name
>> but did not update perf events use of arch_vma_name().
>>
>> Commit a62c34bd2a8a3f159945becd57401e478818d51c
>> removed "[vdso]" as a name returned by the x86 version of
>> arch_vma_name(), so the perf event for the vdso mapping
>> no longer had the correct name.
>>
>> Fix by making perf events also use vm_ops->name.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> 
> I've already got:
> http://lkml.kernel.org/r/1405353439-14211-1-git-send-email-jolsa@kernel.org
> 

Sorry, didn't see that.

