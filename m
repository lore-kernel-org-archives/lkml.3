Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936221Ab3DQPgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:36:37 -0400
Received: from [207.46.163.26] ([207.46.163.26]:58906 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S934559Ab3DQPge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:36:34 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLEONE-01-7ER-02
X-M-MSG: 
Date: Wed, 17 Apr 2013 10:35:36 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] perf, amd: support for AMD NB and L2I "uncore"
 counters.
Message-ID: <20130417153536.GA9111@jshin-Toonie>
References: <1366046483-1765-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1366046483-1765-1-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 12:21:21PM -0500, Jacob Shin wrote:
> Per Ingo and Peter Z's request:
>   https://lkml.org/lkml/2013/4/10/267
> 
> This patchset removes the NB counter support from perf_event_amd.c and
> creates a new PMU instead to add support for both AMD NB and L2I
> counters.

Hi Peter Z., could you please take a look over this when you get the
chance? Each new set of counters are now their own struct pmu as you
requested.

Thank you,

-Jacob

> 
> Jacob Shin (2):
>   perf, amd: remove NB counter support from perf_event_amd.c
>   perf, amd: support for AMD NB and L2I "uncore" counters.
> 
>  arch/x86/include/asm/cpufeature.h           |    2 +
>  arch/x86/include/uapi/asm/msr-index.h       |    4 +
>  arch/x86/kernel/cpu/Makefile                |    2 +-
>  arch/x86/kernel/cpu/perf_event_amd.c        |  138 +--------
>  arch/x86/kernel/cpu/perf_event_amd_uncore.c |  442 +++++++++++++++++++++++++++
>  5 files changed, 454 insertions(+), 134 deletions(-)
>  create mode 100644 arch/x86/kernel/cpu/perf_event_amd_uncore.c
> 
> -- 
> 1.7.9.5
> 

