Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab3H1PsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:48:15 -0400
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:10753
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677Ab3H1PsN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:48:13 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dIc89bh936eI1432I14ffIzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h906i1155h192ch)
Date: Wed, 28 Aug 2013 08:48:03 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Mike Turquette <mturquette@linaro.org>,
        James Hogan <james.hogan@imgtec.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>
Subject: Re: linux-next: manual merge of the clk tree with Linus' tree
References: <20130827190304.c3f2f891f20d078d66b703b1@canb.auug.org.au>
 <521C7AF0.1020903@imgtec.com>
 <20f57100-4440-4353-9c84-6e5781f7c6d3@DB9EHSMHS025.ehs.local>
 <20130827165319.8231.9@quantum>
 <20130828100431.3005d52d77c565c241399269@canb.auug.org.au>
 <20130828172225.97f295645c9de0bbd2979fcd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130828172225.97f295645c9de0bbd2979fcd@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <e0d9bd21-a5dd-496c-aa3b-38ef55b34de5@DB8EHSMHS028.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 05:22:25PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> On Wed, 28 Aug 2013 10:04:31 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Tue, 27 Aug 2013 09:53:19 -0700 Mike Turquette <mturquette@linaro.org> wrote:
> > >
> > > Quoting Sören Brinkmann (2013-08-27 08:44:11)
> > > > On Tue, Aug 27, 2013 at 11:09:52AM +0100, James Hogan wrote:
> > > > > On 27/08/13 10:03, Stephen Rothwell wrote:
> > > > > > Hi Mike,
> > > > > > 
> > > > > > Today's linux-next merge of the clk tree got a conflict in
> > > > > > drivers/clk/zynq/clkc.c between commits 252957cc3a2d ("clk/zynq/clkc: Add
> > > > > > dedicated spinlock for the SWDT") and 765b7d4c4cb3
> > > > > > ("clk/zynq/clkc: Add CLK_SET_RATE_PARENT flag to ethernet muxes") from
> > > > > > Linus' tree and commit 819c1de344c5 ("clk: add CLK_SET_RATE_NO_REPARENT
> > > > > > flag") from the clk tree.
> > > > > > 
> > > > > > I fixed it up (see below and in a couple of places I chose
> > > > > > CLK_SET_RATE_NO_REPARENT over CLK_SET_RATE_PARENT, which may, of course,
> > > > > > be wrong) and can carry the fix as necessary (no action is required).
> > > > > 
> > > > > The case you mentioned looks correct to me.
> > > > > 
> > > > > I can't see todays -next yet, but if by "choose CLK_SET_RATE_NO_REPARENT
> > > > > over CLK_SET_RATE_PARENT" you mean one branch adds CLK_SET_RATE_PARENT,
> > > > > clk-next adds CLK_SET_RATE_NO_REPARENT, and the resolution ends up with
> > > > > only CLK_SET_RATE_NOREPARENT then that sounds wrong, as the two flags
> > > > > are orthogonal.
> > > > 
> > > > I can just agree, the case included in the mail looks correct, but in
> > > > case of other conflicts both flags should be set. Just like in the case
> > > > shown here.
> > > 
> > > Stephen's fix is correct. The Zynq patches came in as fixes so I think
> > > this will be a rare event.
> > 
> > Can you guys discuss this and come up with a single answer.  I read the above as:
> > 
> > (for the two places I used CLK_SET_RATE_NO_REPARENT where the two
> > branches each added that and CLK_SET_RATE_NOREPARENT respectively)
> > 
> > "Stephen was wrong"
> > "Stephen should have taken both"
> > "Stephen was right"
> > 
> > :-)
> > 
> > I can fix up my merge resolution if you tell me the correct fix.  Also,
> > you will need to know so that you can tell Linus (or whoever else has to
> > resolve these conflicts).
> 
> OK, I thought about it some more and the resolution now looks like
> below.  Is this correct/better?

Yes, looks correct to me.

	Sören


