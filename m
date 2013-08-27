Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3H0Po2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:44:28 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:42523
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752192Ab3H0Po1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:44:27 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2dI98dIc89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h906i1155h192ch)
Date: Tue, 27 Aug 2013 08:44:11 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: James Hogan <james.hogan@imgtec.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mike Turquette <mturquette@linaro.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>
Subject: Re: linux-next: manual merge of the clk tree with Linus' tree
References: <20130827190304.c3f2f891f20d078d66b703b1@canb.auug.org.au>
 <521C7AF0.1020903@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <521C7AF0.1020903@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <20f57100-4440-4353-9c84-6e5781f7c6d3@DB9EHSMHS025.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 11:09:52AM +0100, James Hogan wrote:
> On 27/08/13 10:03, Stephen Rothwell wrote:
> > Hi Mike,
> > 
> > Today's linux-next merge of the clk tree got a conflict in
> > drivers/clk/zynq/clkc.c between commits 252957cc3a2d ("clk/zynq/clkc: Add
> > dedicated spinlock for the SWDT") and 765b7d4c4cb3
> > ("clk/zynq/clkc: Add CLK_SET_RATE_PARENT flag to ethernet muxes") from
> > Linus' tree and commit 819c1de344c5 ("clk: add CLK_SET_RATE_NO_REPARENT
> > flag") from the clk tree.
> > 
> > I fixed it up (see below and in a couple of places I chose
> > CLK_SET_RATE_NO_REPARENT over CLK_SET_RATE_PARENT, which may, of course,
> > be wrong) and can carry the fix as necessary (no action is required).
> 
> The case you mentioned looks correct to me.
> 
> I can't see todays -next yet, but if by "choose CLK_SET_RATE_NO_REPARENT
> over CLK_SET_RATE_PARENT" you mean one branch adds CLK_SET_RATE_PARENT,
> clk-next adds CLK_SET_RATE_NO_REPARENT, and the resolution ends up with
> only CLK_SET_RATE_NOREPARENT then that sounds wrong, as the two flags
> are orthogonal.

I can just agree, the case included in the mail looks correct, but in
case of other conflicts both flags should be set. Just like in the case
shown here.

	Sören


