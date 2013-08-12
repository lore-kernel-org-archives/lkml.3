Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab3HLQRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:17:38 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:39444 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755995Ab3HLQRh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:17:37 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI9371Ic89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h906i1155h192ch)
Date: Mon, 12 Aug 2013 09:17:28 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, <srinivas.kandagatla@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <a48f159a-e88c-42fa-b76b-662302d3a585@AM1EHSMHS003.ehs.local>
 <51FA9AE8.1060004@linaro.org>
 <1c83c081-60c6-49e3-a85c-f64dd5be0e60@CH1EHSMHS030.ehs.local>
 <51FA9F54.3060704@linaro.org>
 <c44e700d-64da-487b-a975-1263d7505371@CH1EHSMHS043.ehs.local>
 <5204C54A.9020105@st.com>
 <5204FA5D.3060908@linaro.org>
 <20130809172757.GD14845@codeaurora.org>
 <c1e112a3-cfed-4e53-951e-b1a9208d7dc8@TX2EHSMHS038.ehs.local>
 <5209088E.20404@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5209088E.20404@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <ca0a49c2-37c8-4ff8-bc02-22158633d469@TX2EHSMHS012.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 06:08:46PM +0200, Daniel Lezcano wrote:
> On 08/12/2013 06:03 PM, Sören Brinkmann wrote:
> > On Fri, Aug 09, 2013 at 10:27:57AM -0700, Stephen Boyd wrote:
> >> On 08/09, Daniel Lezcano wrote:
> >>>
> >>> yes, but at least the broadcast mechanism should send an IPI to cpu0 to
> >>> wake it up, no ? As Stephen stated this kind of configuration should has
> >>> never been tested before so the tick broadcast code is not handling this
> >>> case properly IMHO.
> >>>
> >>
> >> If you have a per-cpu tick device that isn't suffering from
> >> FEAT_C3_STOP why wouldn't you use that for the tick versus a
> >> per-cpu tick device that has FEAT_C3_STOP? It sounds like there
> >> is a bug in the preference logic or you should boost the rating
> >> of the arm global timer above the twd. Does this patch help? It
> >> should make the arm global timer the tick device and whatever the
> >> cadence timer you have into the broadcast device.
> > 
> > I finally got to test your patch. Unfortunately, it makes the system
> > hang even earlier:
> 
> [ ... ]
> 
> Can you boot with maxcpus=1 and then give the result of timer_list ?

That doesn't seem to help anymore. It hangs too. Same picture w/ and w/o
'maxcpus', except for
	[    0.000000] Kernel command line: console=ttyPS0,115200 earlyprintk maxcpus=1


	Sören


