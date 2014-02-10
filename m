Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaBJRq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:46:27 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:55390
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753695AbaBJRqU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:46:20 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dIc89bh148cI1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h906i1155h)
Date: Mon, 10 Feb 2014 09:46:07 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 5/7] clocksource/cadence_ttc: Use only one counter
References: <1391466877-28908-1-git-send-email-soren.brinkmann@xilinx.com>
 <1391466877-28908-6-git-send-email-soren.brinkmann@xilinx.com>
 <alpine.DEB.2.02.1402042138480.24986@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402042138480.24986@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <6429e1bb-d4ad-4bf2-bd75-456324f45629@CO9EHSMHS016.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Tue, Feb 04, 2014 at 09:41:53PM +0100, Thomas Gleixner wrote:
> On Mon, 3 Feb 2014, Soren Brinkmann wrote:
> 
> > Currently the driver uses two of the three counters the TTC provides to
> > implement a clocksource and a clockevent device. By using the TTC's
> > match feature we can implement both use cases using a single counter
> > only.
> 
> Are you entirely sure that this match feature is free of the infamous
> HPET match feature issues?
> 
> See arch/x86/kernel/hpet.c: hpet_next_event()
> 
> If yes, please add a comment. If no ....
Good catch. Looks like the comparator compares on == as well. So, I
assume it may show similar issues. I'll have to spend some more time
looking into this.

Thanks for applying the first two patches of the series.

	Thanks,
	Sören


