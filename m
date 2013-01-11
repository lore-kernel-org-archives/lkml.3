Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab3AKNzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:55:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab3AKNzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:55:19 -0500
Date: Fri, 11 Jan 2013 14:54:49 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/5] perf: Add support for hardware breakpoint
 address masks
Message-ID: <20130111135449.GD2847@krava.brq.redhat.com>
References: <1357848659-4786-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357848659-4786-1-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 02:10:54PM -0600, Jacob Shin wrote:
> The following patchset adds address masks to existing perf hardware
> breakpoint mechanism to allow trapping on an address range (currently
> only single address) on supported architectures.

I haven't found any spec for that, could you please direct me?

thanks,
jirka

> 
> perf uapi is updated, x86 AMD implementation (for AMD Family 16h and
> beyond) is provided, and perf tool has been extended to do:
> 
>   $ perf stat -e mem:0x1000:w:0xf a.out
>                               ^^^
>                               "don't care" bit mask
> 
>   which will count writes to [0x1000 ~ 0x1010)
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
>  arch/x86/include/asm/hw_breakpoint.h     |    6 ++++++
>  arch/x86/include/asm/processor.h         |    7 ++++++
>  arch/x86/include/uapi/asm/msr-index.h    |    6 ++++++
>  arch/x86/kernel/cpu/amd.c                |   21 ++++++++++++++++++
>  arch/x86/kernel/hw_breakpoint.c          |    5 +++++
>  include/linux/hw_breakpoint.h            |    6 ++++++
>  include/uapi/linux/perf_event.h          |    5 ++++-
>  kernel/events/hw_breakpoint.c            |    3 +++
>  tools/perf/Documentation/perf-record.txt |   14 ++++++++----
>  tools/perf/tests/parse-events.c          |   34 ++++++++++++++++++++++++++++++
>  tools/perf/util/parse-events.c           |    5 +++--
>  tools/perf/util/parse-events.h           |    2 +-
>  tools/perf/util/parse-events.y           |   14 ++++++++++--
>  16 files changed, 125 insertions(+), 10 deletions(-)
> 
> -- 
> 1.7.9.5
> 
> 
