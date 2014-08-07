Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbaHGUn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 16:43:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43076 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaHGUn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 16:43:57 -0400
Message-ID: <53E3E50B.7050105@codeaurora.org>
Date: Thu, 07 Aug 2014 13:43:55 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
CC: Liu hua <sdu.liu@huawei.com>, Mark Salter <msalter@redhat.com>,
        Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Rob Herring <robh@kernel.org>,
        Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/8] arm: support CONFIG_RODATA
References: <1407423713-4160-1-git-send-email-keescook@chromium.org>
In-Reply-To: <1407423713-4160-1-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/2014 8:01 AM, Kees Cook wrote:
> This is a series of patches to support CONFIG_RODATA on ARM, so that
> the kernel text is RO, and non-text sections default to NX. To support
> on-the-fly kernel text patching (via ftrace, kprobes, etc), fixmap
> support has been finalized based on several versions of various patches
> that are floating around on the mailing list. This series attempts to
> include the least intrusive version, so that others can build on it for
> future fixmap work.
> 
> The series has been heavily tested, and appears to be working correctly:
> 
> With CONFIG_ARM_PTDUMP, expected page table permissions are seen in
> /sys/kernel/debug/kernel_page_tables.
> 
> Using CONFIG_LKDTM, the kernel now correctly detects bad accesses for
> for the following lkdtm tests via /sys/kernel/debug/provoke-crash/DIRECT:
>         EXEC_DATA
>         WRITE_RO
>         WRITE_KERN
> 
> ftrace works:
>         CONFIG_FTRACE_STARTUP_TEST passes
>         Enabling tracing works:
>                 echo function > /sys/kernel/debug/tracing/current_tracer
> 
> kprobes works:
>         CONFIG_ARM_KPROBES_TEST passes
> 
> kexec works:
>         kexec will load and start a new kernel
> 
> Thanks to everyone who has been testing this series and working on its
> various pieces!
> 
> -Kees
> 
> v2:
> - fix typo in kexec merge (buildbot)
> - flip index order for highmem pte access (lauraa)
> - added kgdb updates (dianders)
> 

At least twice I managed to boot a build with CONFIG_DEBUG_RODATA where
both  cat /sys/kernel/debug/kernel_page_table and JTAG were showing no
sections marked as read only. I haven't been able to reproduce it though
so I'm tempted to account for it as incorrect testing on my part. I'll
play around with it some more but if you haven't heard anything more
you can add

Tested-by: Laura Abbott <lauraa@codeaurora.org>

For boot up test, kernel_page_table/JTAG page table verification and
simple kprobes test. 

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
