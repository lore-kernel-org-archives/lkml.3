Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030Ab3DASbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:31:38 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:24979
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758991Ab3DASbh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:31:37 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh936eI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah906i1155h)
Date: Mon, 1 Apr 2013 11:31:32 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Shawn Guo <shawn.guo@linaro.org>, Rajendra Nayak <rnayak@ti.com>,
        Andrew Lunn <andrew@lunn.ch>, James Hogan <james.hogan@imgtec.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] clk: divider: Tolerate 0 divider for one based
 dividers
References: <dbceb80f-0303-4ba0-acd8-336dd85444ae@DB8EHSMHS017.ehs.local>
 <20130322171141.834.32801@quantum>
 <c9f78c47-4926-4233-8cc3-51e0a4cc9c5e@AM1EHSMHS003.ehs.local>
 <20130401182522.8177.96562@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130401182522.8177.96562@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <edf8905f-2bd1-4a1d-b6a2-85e921365d88@CO1EHSMHS004.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Mon, Apr 01, 2013 at 11:25:22AM -0700, Mike Turquette wrote:
> Quoting Sören Brinkmann (2013-03-22 11:00:15)
> > Since some of our dividers have a reset value of 0, I see this warning
> > during boot up. My intention here is to get rid of the warning for clocks
> > which deem 0 a valid divider value.
> > I thought, reusing the ONE_BASED flag might be okay, since all such
> > dividers have this redundant 0 state and might handle it similar.
> > Otherwise a new flag might be required.
> > 
> 
> Hi Soren,
> 
> A flag will be necessary.  I just checked some documentation for the
> divider outputs for OMAP's PLLs and (which use the common clk_divider
> type) and programming zero into those dividers is not allowed.  At reset
> the divider registers are set to 1.
> 
> So it is unsafe to simply reuse the ONE_BASED flag.
> 
> Let's keep the current behavior as the default and introduce a new flag
> to handle the special case of a zero divider.  Would you like to take a
> crack at it?  It might also be nice to update the WARN message with a
> hint to take a look at your new flag in case future platforms hit the
> same issue as you.
Okay, sounds good. I should be able to get something ready within this
week.
Does anybody have suggestions for naming the new flag?
CLK_DIVIDER_ZERO_OKAY was my original suggestionn I think.

	Sören


