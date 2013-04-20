Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab3DTWsJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 18:48:09 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:40740
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755902Ab3DTWsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 18:48:07 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VPS-8(zz98dI1432I14e3M4015Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLKSNY-01-3Y5-02
X-M-MSG: 
Date: Sat, 20 Apr 2013 17:47:57 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] perf: Add hardware breakpoint address mask
Message-ID: <20130420224757.GB6155@jshin-Toonie>
References: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
 <20130420165334.GA14814@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130420165334.GA14814@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 20, 2013 at 06:53:34PM +0200, Oleg Nesterov wrote:
> On 04/09, Jacob Shin wrote:
> >
> > The following patchset adds address masks to existing perf hardware
> > breakpoint mechanism to allow trapping on an address range (currently
> > only single address) on supported architectures.
> >
> > perf uapi is updated, x86 AMD implementation (for AMD Family 16h and
> > beyond) is provided, and perf tool has been extended to do:
> >
> >   $ perf stat -e mem:0x1000:w:0xf a.out
> >                               ^^^
> >                               "don't care" bit mask
> >
> >   which will count writes to [0x1000 ~ 0x1010)
> 
> Please help me understand...
> 
> Assuming that cpu_has_bpext == T, suppose that
> 
> 	bp_addr		= 0x1001;
> 	bp_bp_addr_mask	= 0xf;
> 
> Is it the same as 0x1000/0xf above?
> 
> IOW, what exactly this mask means? I guess, mem:ADDR:w:MASK
> should trigger the trap if CPU writes to the addr and
> 
> 	(addr & ~MASK) == (ADDR & ~MASK)
> 
> correct?

Yes that is correct.

> 
> And does attr.bp_len "contribute" to the mask?
> 
> I mean, if bp_len == X86_BREAKPOINT_LEN_8, does this mean that
> bp_bp_addr_mask and (bp_bp_addr_mask | 7) have the same effect?

Yes it has the same effect.

Thanks,

-Jacob

