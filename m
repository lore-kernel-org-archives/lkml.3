Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3AXNcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:32:05 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:37354 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3AXNcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:32:00 -0500
MIME-Version: 1.0
In-Reply-To: <1357847443-3878-1-git-send-email-jacob.shin@amd.com>
References: <1357847443-3878-1-git-send-email-jacob.shin@amd.com>
Date: Thu, 24 Jan 2013 14:31:59 +0100
Message-ID: <CABPqkBS-cE3T6ccVDGtzgQBKM_bC9vugzWzP94ycYz4dWujp2g@mail.gmail.com>
Subject: Re: [PATCH RESEND V5 0/6] perf, amd: Enable AMD family 15h
 northbridge counters
From: Stephane Eranian <eranian@google.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 8:50 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> The following patchset enables 4 additional performance counters in
> AMD family 15h processors that count northbridge events -- such as
> number of DRAM accesses.
>
In order for me to test this patch set more thoroughly it would help if you
could also provide me a patch to add the Fam15h uncore events to libpfm4.
In the past, Robert Richter took care of this. I hope you can fill his role for
this. So please, if you could send me the patch quickly, that would help
the review of your patch.

Thanks.



> This patchset is based on previous work done by Robert Richter
> <rric@kernel.org> :
>
> https://lkml.org/lkml/2012/6/19/324
>
> The main differences are:
>
> * The northbridge counters are indexed contiguously right above the
>   core performance counters.
>
> * MSR address offset calculations are moved to architecture specific
>   files.
>
> * Interrups are set up to be delivered only to a single core.
>
> V5:
> Rebased against latest tip
>
> V4:
> * Moved interrupt core select set up back to event constraints
>   function, sicne during ->hw_config time we do not yet know on which
>   CPU the the event will run on.
> * Tested on and made minor revisions to make sure that the patchset is
>   compatible with upcoming AMD Family 16h processors, and will support
>   core and NB counters without any further patches.
>
> V3:
> Addressed the following feedback/comments from Robert's review
> * https://lkml.org/lkml/2012/11/16/484
> * https://lkml.org/lkml/2012/11/26/162
>
> V2:
> Separate out Robert's patches, and add properly ordered certificate of
> origins.
>
> Jacob Shin (4):
>   perf, amd: Use proper naming scheme for AMD bit field definitions
>   perf, x86: Move MSR address offset calculation to architecture
>     specific files
>   perf, x86: Allow for architecture specific RDPMC indexes
>   perf, amd: Enable northbridge performance counters on AMD family 15h
>
> Robert Richter (2):
>   perf, amd: Rework northbridge event constraints handler
>   perf, amd: Generalize northbridge constraints code for family 15h
>
>  arch/x86/include/asm/cpufeature.h     |    2 +
>  arch/x86/include/asm/perf_event.h     |   13 +-
>  arch/x86/include/uapi/asm/msr-index.h |    2 +
>  arch/x86/kernel/cpu/perf_event.c      |    2 +-
>  arch/x86/kernel/cpu/perf_event.h      |   25 ++-
>  arch/x86/kernel/cpu/perf_event_amd.c  |  318 +++++++++++++++++++++++++--------
>  6 files changed, 268 insertions(+), 94 deletions(-)
>
> --
> 1.7.9.5
>
>
