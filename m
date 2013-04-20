Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab3DTVqj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 17:46:39 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:34750
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755435Ab3DTVqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 17:46:38 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLKPTL-02-3FR-02
X-M-MSG: 
Date: Sat, 20 Apr 2013 16:46:32 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] perf: Add hardware breakpoint address mask
Message-ID: <20130420214632.GA6155@jshin-Toonie>
References: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
 <1365528113-5458-2-git-send-email-jacob.shin@amd.com>
 <20130420162223.GA13393@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130420162223.GA13393@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 20, 2013 at 06:22:23PM +0200, Oleg Nesterov wrote:
> On 04/09, Jacob Shin wrote:
> >
> > @@ -612,6 +612,9 @@ static int hw_breakpoint_add(struct perf_event *bp, int flags)
> >  	if (!(flags & PERF_EF_START))
> >  		bp->hw.state = PERF_HES_STOPPED;
> >
> > +	if (bp->attr.bp_addr_mask && !arch_has_hw_breakpoint_addr_mask())
> > +		return -EOPNOTSUPP;
> > +
> 
> This is called by sched_in... Isn't it "too late" ?
> 
> Perhaps arch_validate_hwbkpt_settings() should validate mask/cpu_has_bpext?

Ah, yes okay. Should I do this for all the archs that HAVE_HW_BREAKPOINT ?

Or is creating HAVE_HW_BREAKPOINT_ADDR_MASK and in validate_hw_breakpoint:

  #ifndef HAVE_HW_BREAKPOINT_ADDR_MASK
  if (bp->attr.bp_addr_mask)
  	return -EOPNOTSUPP;
  #endif

Okay to do?


