Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab3HIRsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 13:48:16 -0400
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:43480
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758469Ab3HIRsP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 13:48:15 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIc89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h906i1155h192ch)
Date: Fri, 9 Aug 2013 10:48:05 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>, <srinivas.kandagatla@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <15e19315-ce88-4d3c-bad9-0a37d9e52f6b@CO1EHSMHS007.ehs.local>
 <51F99747.4060901@linaro.org>
 <a48f159a-e88c-42fa-b76b-662302d3a585@AM1EHSMHS003.ehs.local>
 <51FA9AE8.1060004@linaro.org>
 <1c83c081-60c6-49e3-a85c-f64dd5be0e60@CH1EHSMHS030.ehs.local>
 <51FA9F54.3060704@linaro.org>
 <c44e700d-64da-487b-a975-1263d7505371@CH1EHSMHS043.ehs.local>
 <5204C54A.9020105@st.com>
 <5204FA5D.3060908@linaro.org>
 <20130809172757.GD14845@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130809172757.GD14845@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <3a4049f6-aad6-4730-86e3-210afbc3836b@DB9EHSMHS028.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 10:27:57AM -0700, Stephen Boyd wrote:
> On 08/09, Daniel Lezcano wrote:
> > 
> > yes, but at least the broadcast mechanism should send an IPI to cpu0 to
> > wake it up, no ? As Stephen stated this kind of configuration should has
> > never been tested before so the tick broadcast code is not handling this
> > case properly IMHO.
> > 
> 
> If you have a per-cpu tick device that isn't suffering from
> FEAT_C3_STOP why wouldn't you use that for the tick versus a
> per-cpu tick device that has FEAT_C3_STOP? It sounds like there
> is a bug in the preference logic or you should boost the rating
> of the arm global timer above the twd. Does this patch help? It
> should make the arm global timer the tick device and whatever the
> cadence timer you have into the broadcast device.

I'm not sure I'm getting this right. But neither the cadence_ttc nor the
arm_global_timer have the FEAT_C3_STOP flag set. So, shouldn't they be
treated equally even with your change?

	Sören


