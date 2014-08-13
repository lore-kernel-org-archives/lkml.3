Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaHMRia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:38:30 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:49230 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaHMRi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:38:28 -0400
Date: Wed, 13 Aug 2014 13:38:24 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Rabin Vincent <rabin@rab.in>, Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Tomasz Figa <t.figa@samsung.com>, Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 0/8] arm: support CONFIG_RODATA
In-Reply-To: <1407949593-16121-1-git-send-email-keescook@chromium.org>
Message-ID: <alpine.LFD.2.11.1408131337360.1133@knanqh.ubzr>
References: <1407949593-16121-1-git-send-email-keescook@chromium.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014, Kees Cook wrote:

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
> Built with and without CONFIG_HIGHMEM, CONFIG_HIGHMEM_DEBUG, and
> CONFIG_NR_CPUS=32.
> 
> Thanks to everyone who has been testing this series and working on its
> various pieces!

For the whole series:

Acked-by: Nicolas Pitre <nico@linaro.org>



> 
> -Kees
> 
> v4:
> - expanded fixmap to 3MB to support 32 CPUs (robh)
> - corrected pmd-finding via vaddr instead of FIXMAP_START (robh)
> - switched structure size test to BUILD_BUG_ON (sboyd)
> - added locking annotations to keep sparse happy (sboyd)
> - adding missing "static" declarations noticed by sparse
> - reorganized fixmap portion of patches
> 
> v3:
> - more cleanups in switch to generic fixmap (lauraa, robh)
> - fixed kexec merge hunk glitch (will.deacon)
> - added tested-by tags where appropriate from v2 testing
> 
> v2:
> - fix typo in kexec merge (buildbot)
> - flip index order for highmem pte access (lauraa)
> - added kgdb updates (dianders)
> 
> 
