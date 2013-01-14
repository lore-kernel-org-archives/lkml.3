Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab3ANRVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:21:44 -0500
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:50205
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757894Ab3ANRVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:21:42 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(z551biz98dI1818P1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-WSS-ID: 0MGMLJZ-02-KTO-02
X-M-MSG: 
Date: Mon, 14 Jan 2013 11:21:35 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 0/5] perf: Add support for hardware breakpoint
 address masks
Message-ID: <20130114172135.GA5806@jshin-Toonie>
References: <1357848659-4786-1-git-send-email-jacob.shin@amd.com>
 <20130111135449.GD2847@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130111135449.GD2847@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 02:54:49PM +0100, Jiri Olsa wrote:
> On Thu, Jan 10, 2013 at 02:10:54PM -0600, Jacob Shin wrote:
> > The following patchset adds address masks to existing perf hardware
> > breakpoint mechanism to allow trapping on an address range (currently
> > only single address) on supported architectures.
> 
> I haven't found any spec for that, could you please direct me?

Hello, (sorry for the late reply, was out of office on Friday)

Unfortunately, I don't have a public spec that I can share for the 
processor (AMD Family 16h) this feature first appears in yet. But once
the chip gets released sometime later, I will post a link to the 
document that will go public. Sorry .. :-(

But the patchset I think is pretty straight forward and there isn't
much more in the documentation, there are 4 MSRs (one for each DRn)
that software writes "don't care" masks (32 bits) to get the processor
to trap on range of addresses.

Thank you for taking the time to review the patchset ..

-Jacob

> 
> thanks,
> jirka
> 
> > 
> > perf uapi is updated, x86 AMD implementation (for AMD Family 16h and
> > beyond) is provided, and perf tool has been extended to do:
> > 
> >   $ perf stat -e mem:0x1000:w:0xf a.out
> >                               ^^^
> >                               "don't care" bit mask
> > 
> >   which will count writes to [0x1000 ~ 0x1010)
> > 
> > Jacob Shin (2):
> >   perf: Add hardware breakpoint address mask
> >   perf, x86: AMD implementation for hardware breakpoint address mask
> > 
> > Suravee Suthikulpanit (3):
> >   perf tools: Add breakpoint address mask to the mem event parser
> >   perf tools: Add breakpoint address mask syntax to perf list and
> >     documentation
> >   perf tools: Add breakpoint address mask test case to
> >     tests/parse-events
> > 
> >  arch/Kconfig                             |    4 ++++
> >  arch/x86/Kconfig                         |    1 +
> >  arch/x86/include/asm/cpufeature.h        |    2 ++
> >  arch/x86/include/asm/hw_breakpoint.h     |    6 ++++++
> >  arch/x86/include/asm/processor.h         |    7 ++++++
> >  arch/x86/include/uapi/asm/msr-index.h    |    6 ++++++
> >  arch/x86/kernel/cpu/amd.c                |   21 ++++++++++++++++++
> >  arch/x86/kernel/hw_breakpoint.c          |    5 +++++
> >  include/linux/hw_breakpoint.h            |    6 ++++++
> >  include/uapi/linux/perf_event.h          |    5 ++++-
> >  kernel/events/hw_breakpoint.c            |    3 +++
> >  tools/perf/Documentation/perf-record.txt |   14 ++++++++----
> >  tools/perf/tests/parse-events.c          |   34 ++++++++++++++++++++++++++++++
> >  tools/perf/util/parse-events.c           |    5 +++--
> >  tools/perf/util/parse-events.h           |    2 +-
> >  tools/perf/util/parse-events.y           |   14 ++++++++++--
> >  16 files changed, 125 insertions(+), 10 deletions(-)
> > 
> > -- 
> > 1.7.9.5
> > 
> > 
> 

