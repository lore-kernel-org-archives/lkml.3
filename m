Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab3H0Qx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:53:27 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:39355 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3H0QxZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:53:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: =?utf-8?q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        James Hogan <james.hogan@imgtec.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20f57100-4440-4353-9c84-6e5781f7c6d3@DB9EHSMHS025.ehs.local>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>
References: <20130827190304.c3f2f891f20d078d66b703b1@canb.auug.org.au>
 <521C7AF0.1020903@imgtec.com>
 <20f57100-4440-4353-9c84-6e5781f7c6d3@DB9EHSMHS025.ehs.local>
Message-ID: <20130827165319.8231.9@quantum>
User-Agent: alot/0.3.4
Subject: Re: linux-next: manual merge of the clk tree with Linus' tree
Date: Tue, 27 Aug 2013 09:53:19 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sören Brinkmann (2013-08-27 08:44:11)
> On Tue, Aug 27, 2013 at 11:09:52AM +0100, James Hogan wrote:
> > On 27/08/13 10:03, Stephen Rothwell wrote:
> > > Hi Mike,
> > > 
> > > Today's linux-next merge of the clk tree got a conflict in
> > > drivers/clk/zynq/clkc.c between commits 252957cc3a2d ("clk/zynq/clkc: Add
> > > dedicated spinlock for the SWDT") and 765b7d4c4cb3
> > > ("clk/zynq/clkc: Add CLK_SET_RATE_PARENT flag to ethernet muxes") from
> > > Linus' tree and commit 819c1de344c5 ("clk: add CLK_SET_RATE_NO_REPARENT
> > > flag") from the clk tree.
> > > 
> > > I fixed it up (see below and in a couple of places I chose
> > > CLK_SET_RATE_NO_REPARENT over CLK_SET_RATE_PARENT, which may, of course,
> > > be wrong) and can carry the fix as necessary (no action is required).
> > 
> > The case you mentioned looks correct to me.
> > 
> > I can't see todays -next yet, but if by "choose CLK_SET_RATE_NO_REPARENT
> > over CLK_SET_RATE_PARENT" you mean one branch adds CLK_SET_RATE_PARENT,
> > clk-next adds CLK_SET_RATE_NO_REPARENT, and the resolution ends up with
> > only CLK_SET_RATE_NOREPARENT then that sounds wrong, as the two flags
> > are orthogonal.
> 
> I can just agree, the case included in the mail looks correct, but in
> case of other conflicts both flags should be set. Just like in the case
> shown here.

Stephen's fix is correct. The Zynq patches came in as fixes so I think
this will be a rare event.

Regards,
Mike

> 
>         Sören
