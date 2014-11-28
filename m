Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaK1Kyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:54:53 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29003 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbaK1Kyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:54:51 -0500
Date: Fri, 28 Nov 2014 18:51:43 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
CC: Marc Zyngier <Marc.Zyngier@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "Olof Johansson" <olof@lixom.net>, Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] arm64: ARM: Fix the Generic Timers interrupt active
 level description
Message-ID: <20141128185143.00ee05b5@xhacker>
In-Reply-To: <20141128103843.GW828@e106497-lin.cambridge.arm.com>
References: <1417105283-19575-1-git-send-email-Liviu.Dudau@arm.com>
	<54776FE0.8030600@arm.com>
	<20141128111252.4a6e8892@xhacker>
	<20141128103843.GW828@e106497-lin.cambridge.arm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-11-28_05:2014-11-27,2014-11-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1411280110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2014 02:38:43 -0800
Liviu Dudau <Liviu.Dudau@arm.com> wrote:

> On Fri, Nov 28, 2014 at 03:12:52AM +0000, Jisheng Zhang wrote:
> > Dear Marc and Liviu,
> > 
> > On Thu, 27 Nov 2014 10:39:28 -0800
> > Marc Zyngier <marc.zyngier@arm.com> wrote:
> > 
> > > On 27/11/14 16:21, Liviu Dudau wrote:
> > > > The Cortex-A5x TRM states in paragraph "9.2 Generic Timer functional
> > > > description" that generic timers provide a level not edge interrupt
> > > > output. Fix the device trees to correctly describe this.
> > > > 
> > > > While doing this update the CPU mask to match the number of described
> > > > CPUs as well as the DT bindings documentation for Generic Timers.
> > > > 
> > > > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > > 
> > > Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> > > 
> > > 	M.
> > > 
> > > > ---
> > > > 
> > > > Arnd, Olof: This is on top of linux-next/master as it patches Juno's
> > > > as well as all the other ARM DTs.
> > > > 
> > > > --
> > > > 
> > > >  Documentation/devicetree/bindings/arm/arch_timer.txt | 8 ++++----
> > > >  arch/arm64/boot/dts/arm/foundation-v8.dts            | 8 ++++----
> > > >  arch/arm64/boot/dts/arm/juno.dts                     | 8 ++++----
> > > >  arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts           | 8 ++++----
> > > >  4 files changed, 16 insertions(+), 16 deletions(-)
> > > > 
> > > > diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt
> > > > b/Documentation/devicetree/bindings/arm/arch_timer.txt index
> > > > 37b2caf..6d2aa87 100644 ---
> > > > a/Documentation/devicetree/bindings/arm/arch_timer.txt +++
> > > > b/Documentation/devicetree/bindings/arm/arch_timer.txt @@ -27,10
> > > > +27,10 @@ Example: timer {
> > > >  		compatible = "arm,cortex-a15-timer",
> > > >  			     "arm,armv7-timer";
> > > > -		interrupts = <1 13 0xf08>,
> > > > -			     <1 14 0xf08>,
> > > > -			     <1 11 0xf08>,
> > > > -			     <1 10 0xf08>;
> > > > +		interrupts = <1 13 0xf04>,
> > > > +			     <1 14 0xf04>,
> > > > +			     <1 11 0xf04>,
> > > > +			     <1 10 0xf04>;
> > > >  		clock-frequency = <100000000>;
> > > >  	};
> > > >  
> > 
> > Does it mean we also need to fix the interrupt level description under
> > arch/arm/boot/dts? I found they are also wrong or I misunderstand
> > something?
> 
> Hi Jisheng,
> 
> It looks like Marc and I managed to confuse ourselves. The TRM for GIC-500
> and GIC-400 (basically covering most of GICv1 and > GICv2) clearly says
> that for *PPIs* the level triggered interrupts are active-LOW.
> 
> So, this patch is invalid and my v1 version is correct, but Marc tells that
> in that case the GIC driver needs patching (which I'm going to look into).
> 

Got it. Thanks for clarification.
