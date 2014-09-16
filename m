Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaIPHA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:00:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43301 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaIPHAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:00:55 -0400
Date: Tue, 16 Sep 2014 09:00:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, kan.liang@intel.com
Subject: Re: [PATCH] perf/x86/uncore: update support for client uncore IMC PMU
Message-ID: <20140916070050.GB19849@gmail.com>
References: <20140915143832.GA3264@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915143832.GA3264@quad>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> 
> This patch restructures the memory controller (IMC) uncore
> PMU support for client SNB/IVB/HSW processors. The main change
> is that it can now cope with more than one PCI device ID per
> processor model. There are many flavors of memory controllers
> for each processor. They have different PCI device ID, yet
> they behave the same w.r.t. the memory controller PMU that
> we are interested in.
> 
> The patch now supports two distinct memory controllers for IVB
> processors: one for mobile, one for desktop.
> 
> Signed-off-by: Stephane eranian <eranian@google.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore_snb.c |   68 +++++++++++++++------
>  include/linux/pci_ids.h                           |    1 +
>  2 files changed, 51 insertions(+), 18 deletions(-)

Please run patches through scripts/checkpatch.pl before 
submission, in case it points out legit problems. Checkpatch 
emits 6 warnings for your patch, the first four are bogus, the 
last two are worth addressing:

WARNING: space prohibited between function name and open 
parenthesis '('
#77: FILE: arch/x86/kernel/cpu/perf_event_intel_uncore_snb.c:517:
+       for_each_imc_pci_id (p, desktop_imc_pci_ids) {

WARNING: Missing a blank line after declarations
#92: FILE: arch/x86/kernel/cpu/perf_event_intel_uncore_snb.c:528:
+       struct pci_driver *imc_drv = imc_uncore_find_dev();
+       if (!imc_drv)

Thanks,

	Ingo
