Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030711Ab3DSOlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:41:11 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:3008
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030552Ab3DSOlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:41:09 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zz98dI936eI1432I4015I111aIzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLIBGA-02-5DX-02
X-M-MSG: 
Date: Fri, 19 Apr 2013 09:41:00 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf, amd: support for AMD NB and L2I "uncore"
 counters.
Message-ID: <20130419144100.GA2894@jshin-Toonie>
References: <1366046483-1765-1-git-send-email-jacob.shin@amd.com>
 <1366046483-1765-3-git-send-email-jacob.shin@amd.com>
 <1366284534.19383.13.camel@laptop>
 <20130418163315.GA7903@jshin-Toonie>
 <1366374436.24945.6.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1366374436.24945.6.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 02:27:16PM +0200, Peter Zijlstra wrote:
> On Thu, 2013-04-18 at 11:33 -0500, Jacob Shin wrote:
> 
> > Okay, here is V2 which does that. Thanks again in advance for taking
> > the time to look it over.
> 
> Awesome, looks good on a first read.. I'm assuming you've tested things
> and they actually work too? :-)

Yes of course, tested on:
1. Older families without these new counters to make sure there is no
   regression.
2. Family 15h, only has NB counters
3. Family 16h, has both NB and L2 counters

> 
> > From d68225744196d8b0d60a1bc33ae9abdbffbd9bc9 Mon Sep 17 00:00:00 2001
> > From: Jacob Shin <jacob.shin@amd.com>
> > Date: Sun, 14 Apr 2013 04:12:42 -0500
> > Subject: [PATCH 2/2] perf, amd: support for AMD NB and L2I "uncore" counters.
> > 
> > Add support for AMD Family 15h [and above] northbridge performance
> > counters. MSRs 0xc0010240 ~ 0xc0010247 are shared across all cores
> > that share a common northbridge.
> > 
> > Add support for AMD Family 16h L2 performance counters. MSRs
> > 0xc0010230 ~ 0xc0010237 are shared across all cores that share a
> > common L2 cache.
> > 
> > We do not enable counter overflow interrupts. Sampling mode and
> > per-thread events are not supported.
> > 
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thank you again, for taking the time.

Ingo, I hope it's not too late to make it into perf/core for 3.10.

Thanks,

-Jacob

