Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab3KMRPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:15:23 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:9023
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932385Ab3KMRPO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:15:14 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(z579ehz98dIc89bh1432Ic1dM1447Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2149h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275dh1de097h186068hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h906i1155h192ch)
Date: Wed, 13 Nov 2013 09:14:59 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 5/7] clocksource/cadence_ttc: Overhaul clocksource
 frequency adjustment
References: <1383945677-29674-1-git-send-email-soren.brinkmann@xilinx.com>
 <1383945677-29674-6-git-send-email-soren.brinkmann@xilinx.com>
 <52827B11.5040308@linaro.org>
 <CAKohpo=KaM97jJ2MnZxSeBz=Mf9cSmzk_EFQTL=EVPPvSH=Wag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CAKohpo=KaM97jJ2MnZxSeBz=Mf9cSmzk_EFQTL=EVPPvSH=Wag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <2c13b204-2022-4091-95be-1749e8cc60b0@CH1EHSMHS026.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 01:33:52PM +0530, Viresh Kumar wrote:
> On 13 November 2013 00:31, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> > Hmm, it could be interesting if Viresh can give its opinion on this patch
> > [cc'ed].
> 
> I am not sure if I understood the problem completely, but if this is about
> not allowing frequency transitions from cpufreq when we have started to
> suspend our system, then you must have a look at this thread:
> 
> https://lkml.org/lkml/2013/10/24/369

Thanks for the link. I had problems in that direction at some point too.
But the current issue, is not cpufreq changing the frequency, but our
suspend code in prepare_late() causes a frequency change of this timer
when the PLLs are powered down (it's done through a CCF clk_set_parent()
operation).

	Sören


