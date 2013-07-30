Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab3G3ADh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 20:03:37 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:20809
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064Ab3G3ADg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 20:03:36 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Mon, 29 Jul 2013 17:03:15 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stuart Menefy <stuart.menefy@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <20130717210417.GP13667@xsjandreislx>
 <51E72DCA.9070500@codeaurora.org>
 <f5b76049-7e5b-4dd0-9863-19cfd1d599b9@TX2EHSMHS006.ehs.local>
 <51E7435B.3060605@codeaurora.org>
 <ff4d40be-7177-4a55-ab2f-dff11fa18642@DB9EHSMHS009.ehs.local>
 <51ED8DF2.60600@codeaurora.org>
 <20130722201348.GI453@xsjandreislx>
 <0735ab8c-0f80-4b64-b2b2-8d4553482c2a@CO9EHSMHS013.ehs.local>
 <51F66565.7010600@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <51F66565.7010600@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <8d56935e-2a20-46c7-b80a-f779572dd839@CO1EHSMHS014.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Mon, Jul 29, 2013 at 02:51:49PM +0200, Daniel Lezcano wrote:
(snip)
> 
> the CPUIDLE_FLAG_TIMER_STOP flag tells the cpuidle framework the local
> timer will be stopped when entering to the idle state. In this case, the
> cpuidle framework will call clockevents_notify(ENTER) and switches to a
> broadcast timer and will call clockevents_notify(EXIT) when exiting the
> idle state, switching the local timer back in use.

I've been thinking about this, trying to understand how this makes my
boot attempts on Zynq hang. IIUC, the wrongly provided TIMER_STOP flag
would make the timer core switch to a broadcast device even though it
wouldn't be necessary. But shouldn't it still work? It sounds like we do
something useless, but nothing wrong in a sense that it should result in
breakage. I guess I'm missing something obvious. This timer system will
always remain a mystery to me.

Actually this more or less leads to the question: What is this
'broadcast timer'. I guess that is some clockevent device which is
common to all cores? (that would be the cadence_ttc for Zynq). Is the
hang pointing to some issue with that driver?

	Thanks,
	Sören


