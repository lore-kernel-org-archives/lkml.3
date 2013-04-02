Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263Ab3DBRyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:54:14 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:9333 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759700Ab3DBRyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:54:12 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKN327-02-7X5-02
X-M-MSG: 
Date: Tue, 2 Apr 2013 12:54:05 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, <x86@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] perf, amd: Support for Family 16h L2I Performance
 Counters
Message-ID: <20130402175405.GA6435@jshin-Toonie>
References: <1364425624-7556-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1364425624-7556-1-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 06:07:01PM -0500, Jacob Shin wrote:
> Upcoming AMD Family 16h Processors provide 4 new performance counters
> to count L2 related events. Similar to northbridge counters, these new
> counters are shared across multiple CPUs that share the same L2 cache.
> This patchset adds support for these new counters and enforces sharing
> by leveraging the existing sharing logic used for the northbridge
> counters.

Ingo, please consider commiting to perf/core for 3.10. This patchset
is very similar to our northbridge counter support that went into 3.9:
https://lkml.org/lkml/2013/2/18/81

This series adds support for yet another set of new counters.

Thank you,

> 
> Jacob Shin (3):
>   perf, amd: Further generalize NB event constraints handling logic
>   perf, x86: Allow for multiple kfree_on_online pointers
>   perf, amd: Enable L2I performance counters on AMD Family 16h
> 
>  arch/x86/include/asm/cpufeature.h      |    2 +
>  arch/x86/include/asm/perf_event.h      |    4 +
>  arch/x86/include/uapi/asm/msr-index.h  |    4 +
>  arch/x86/kernel/cpu/perf_event.c       |    7 +-
>  arch/x86/kernel/cpu/perf_event.h       |   11 +-
>  arch/x86/kernel/cpu/perf_event_amd.c   |  227 +++++++++++++++++++++++++-------
>  arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
>  7 files changed, 199 insertions(+), 58 deletions(-)
> 
> -- 
> 1.7.9.5
> 

