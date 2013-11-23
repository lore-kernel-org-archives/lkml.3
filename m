Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab3KWBbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 20:31:25 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:16364
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932089Ab3KWBbM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 20:31:12 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z579ehzbb2dI98dI9371Ic89bh1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2149h2146h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h906i1155h)
Date: Fri, 22 Nov 2013 17:30:59 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 5/7] clocksource/cadence_ttc: Overhaul clocksource
 frequency adjustment
References: <1383945677-29674-1-git-send-email-soren.brinkmann@xilinx.com>
 <1383945677-29674-6-git-send-email-soren.brinkmann@xilinx.com>
 <52827B11.5040308@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <52827B11.5040308@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <8cbd0206-ca30-48ae-8820-7d5c23b6fa3a@CO9EHSMHS022.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 08:01:37PM +0100, Daniel Lezcano wrote:
> On 11/08/2013 10:21 PM, Soren Brinkmann wrote:
> >The currently used method adjusting the clocksource to a changing input
> >frequency does not work on kernels from 3.11 on.
> >The new approach is to keep the timer frequency as constant as possible.
> >I.e.
> >  - due to the TTC's prescaler limitations, allow frequency changes
> >    only if the frequency scales by a power of 2
> >  - adjust the counter's divider on the fly when a frequency change
> >    occurs
> >
> >When suspending though, the driver should not prevent rate changes in
> >order to allow the system to enter its low power state. For that
> >reason a PM notifier is added so rate changes can be ignored during
> >suspend/resume.
> 
> It sounds very weird you have to add a PM notifier in this driver.
> 
> Have you been facing an issue or do you assume it could happen ?

As I said in my other email, we do have some issues related with
suspend. The construct with the PM notifier seemed to work but since we
upgraded our vendor tree to 3.12 I see issues with this code.

So, for now, I'll remove the PM notifier and associated code from this
patch.
I have to revisit the suspend case later.

	Thanks,
	Sören


