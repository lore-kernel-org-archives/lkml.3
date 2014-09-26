Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaIZF6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 01:58:10 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63016 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbaIZF6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 01:58:06 -0400
MIME-Version: 1.0
In-Reply-To: <1411067949-10913-1-git-send-email-keescook@chromium.org>
References: <1411067949-10913-1-git-send-email-keescook@chromium.org>
Date: Thu, 25 Sep 2014 22:58:05 -0700
X-Google-Sender-Auth: cwYUVET-xQlKToNSwj1X_FsJFw0
Message-ID: <CAGXu5j+v075p9j6tME5N1fN9WsX1YiBO-vYtP8MLM=eo5UsqHg@mail.gmail.com>
Subject: Re: [PATCH v6 0/8] arm: support CONFIG_RODATA
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Kees Cook <keescook@chromium.org>, Rabin Vincent <rabin@rab.in>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh@kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>, Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 12:19 PM, Kees Cook <keescook@chromium.org> wrote:
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
>
> Hopefully this should address Will's last concerns. :)
>
> Thanks!
>
> -Kees
>
> v6:
> - always run patch_text under stop_machine (will.deacon)
> - document set_fixmap's TLB flushing situation (will.deacon)

Hi Will,

Does this version look good to you? Should I turn it into a pull request?

Thanks!

-Kees

>
> v5:
> - clean up #includes in mmu.c (will.deacon)
> - optimize get_cr() test (will.deacon)
> - created free_tcmmem to avoid excessive #ifdefs (will.deacon)
> - explicitly test irqs_disabled in set_fixmap (will.deacon)
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



-- 
Kees Cook
Chrome OS Security
