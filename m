Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab3DOR2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:28:50 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:48249
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754894Ab3DOR2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:28:49 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLB4IT-01-56E-02
X-M-MSG: 
Date: Mon, 15 Apr 2013 12:28:03 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] perf: Add support for hardware breakpoint address
 masks
Message-ID: <20130415172803.GA18406@jshin-Toonie>
References: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 12:21:48PM -0500, Jacob Shin wrote:
> The following patchset adds address masks to existing perf hardware
> breakpoint mechanism to allow trapping on an address range (currently
> only single address) on supported architectures.
> 
> perf uapi is updated, x86 AMD implementation (for AMD Family 16h and
> beyond) is provided, and perf tool has been extended to do:
> 
>   $ perf stat -e mem:0x1000:w:0xf a.out
>                               ^^^
>                               "don't care" bit mask
> 
>   which will count writes to [0x1000 ~ 0x1010)

Ping .. Ingo?

> 
> Jacob Shin (2):
>   perf: Add hardware breakpoint address mask
>   perf, x86: AMD implementation for hardware breakpoint address mask
> 
> Suravee Suthikulpanit (3):
>   perf tools: Add breakpoint address mask to the mem event parser
>   perf tools: Add breakpoint address mask syntax to perf list and
>     documentation
>   perf tools: Add breakpoint address mask test case to
>     tests/parse-events
> 
>  arch/Kconfig                             |    4 ++++
>  arch/x86/Kconfig                         |    1 +
>  arch/x86/include/asm/cpufeature.h        |    2 ++
>  arch/x86/include/asm/debugreg.h          |    7 ++++++
>  arch/x86/include/asm/hw_breakpoint.h     |    6 ++++++
>  arch/x86/include/uapi/asm/msr-index.h    |    6 ++++++
>  arch/x86/kernel/cpu/amd.c                |   19 +++++++++++++++++
>  arch/x86/kernel/hw_breakpoint.c          |    5 +++++
>  include/linux/hw_breakpoint.h            |    6 ++++++
>  include/uapi/linux/perf_event.h          |    5 ++++-
>  kernel/events/hw_breakpoint.c            |    3 +++
>  tools/perf/Documentation/perf-record.txt |   14 ++++++++----
>  tools/perf/tests/parse-events.c          |   34 ++++++++++++++++++++++++++++++
>  tools/perf/util/parse-events.c           |    5 +++--
>  tools/perf/util/parse-events.h           |    2 +-
>  tools/perf/util/parse-events.y           |   14 ++++++++++--
>  16 files changed, 123 insertions(+), 10 deletions(-)
> 
> -- 
> 1.7.9.5
> 

