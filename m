Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab3JJNFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 09:05:16 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:36082 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab3JJNFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 09:05:14 -0400
Message-ID: <5256A571.3070600@synopsys.com>
Date: Thu, 10 Oct 2013 18:32:41 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>, Paul Mundt <paul.mundt@gmail.com>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3]  Move ARCH specific fpu_counter out of task_struct
References: <1381218389-16585-1-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1381218389-16585-1-git-send-email-vgupta@synopsys.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.243]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 01:16 PM, Vineet Gupta wrote:
> Hi,
> 
> When debugging a ARC SMP 3.11 build failure due to a ST insn dealing with
> task_struct.thread going out of range, I spotted @fpu_counter in task_struct
> which only SH/x86 happen to use, and can be easily moved out into corresponding
> ARCH specific thread_struct. This saves 4 bytes per task_struct instantiated,
> for all the other 18 arches.
> 
> While the change is relatively strightforward, I've failed to connect with
> SH arch folks / Paul Mundt, latter's SH email keeps bouncing back.
> Hence I'm taking the liberty to use his alternate email (as listed on his
> github page) and I appologize in advance if this causes any inconvenience.
> 
> Changes in v2:
> - Rabased to 3.12-rc4
> - Added ACK from Ingo on patch 2/3
> 
> Version 1 can be found here:
> https://lkml.org/lkml/2013/9/17/49
> 
> Thx,
> -Vineet
> 
> 
> Vineet Gupta (3):
>   sh: Move fpu_counter into ARCH specific thread_struct
>   x86: Move fpu_counter into ARCH specific thread_struct
>   sched: Remove ARCH specific fpu_counter from task_struct
> 
>  arch/sh/include/asm/fpu.h           |  2 +-
>  arch/sh/include/asm/processor_32.h  | 10 ++++++++++
>  arch/sh/include/asm/processor_64.h  | 10 ++++++++++
>  arch/sh/kernel/cpu/fpu.c            |  2 +-
>  arch/sh/kernel/process_32.c         |  6 +++---
>  arch/x86/include/asm/fpu-internal.h | 10 +++++-----
>  arch/x86/include/asm/processor.h    |  9 +++++++++
>  arch/x86/kernel/i387.c              |  2 +-
>  arch/x86/kernel/process_32.c        |  4 ++--
>  arch/x86/kernel/process_64.c        |  2 +-
>  arch/x86/kernel/traps.c             |  2 +-
>  include/linux/sched.h               |  9 ---------
>  12 files changed, 44 insertions(+), 24 deletions(-)
> 

Ingo, Andrew - do you think this series can be merged for 3.13. Is there anything
else I need to do here.

-Vineet
