Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3IJNz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:55:59 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:40462 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab3IJNz6 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:2>);
	Tue, 10 Sep 2013 09:55:58 -0400
Message-Id: <522F410702000078000F1EE0@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 10 Sep 2013 14:55:51 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ingo Molnar" <mingo@kernel.org>
Cc: "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "Mike Galbraith" <bitbucket@online.de>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 7/7] sched, x86: Optimize the preempt_schedule()
 call
References: <20130910130811.507933095@infradead.org>
 <20130910132011.474646746@infradead.org> <20130910134247.GC7537@gmail.com>
In-Reply-To: <20130910134247.GC7537@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10.09.13 at 15:42, Ingo Molnar <mingo@kernel.org> wrote:

> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> +	.macro SAVE_ALL
>> +	pushl_cfi %eax
>> +	CFI_REL_OFFSET eax, 0
>> +	pushl_cfi %ebp
>> +	CFI_REL_OFFSET ebp, 0
>> +	pushl_cfi %edi
>> +	CFI_REL_OFFSET edi, 0
>> +	pushl_cfi %esi
>> +	CFI_REL_OFFSET esi, 0
>> +	pushl_cfi %edx
>> +	CFI_REL_OFFSET edx, 0
>> +	pushl_cfi %ecx
>> +	CFI_REL_OFFSET ecx, 0
>> +	pushl_cfi %ebx
>> +	CFI_REL_OFFSET ebx, 0
>> +	.endm
>> +
>> +	.macro RESTORE_ALL
>> +	popl_cfi %ebx
>> +	CFI_RESTORE ebx
>> +	popl_cfi %ecx
>> +	CFI_RESTORE ecx
>> +	popl_cfi %edx
>> +	CFI_RESTORE edx
>> +	popl_cfi %esi
>> +	CFI_RESTORE esi
>> +	popl_cfi %edi
>> +	CFI_RESTORE edi
>> +	popl_cfi %ebp
>> +	CFI_RESTORE ebp
>> +	popl_cfi %eax
>> +	CFI_RESTORE eax
>> +	.endm
> 
> Side note: shouldn't the pushl_cfi and popl_cfi macros be adjusted, 
> instead of open coding it?

If you mean the open coding of CFI_REL_OFFSET and CFI_RESTORE,
then no - there may be pushes/pops that don't save the caller's
register values (i.e. where solely the frame pointer adjustment
matters).

If you meant something else, please clarify what.

Jan

