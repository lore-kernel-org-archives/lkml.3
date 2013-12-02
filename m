Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3LBCZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 21:25:59 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:48210 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab3LBCZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 21:25:54 -0500
Date: Mon, 2 Dec 2013 11:25:51 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: takasi-y@ops.dti.ne.jp, SH-Linux <linux-sh@vger.kernel.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Mike Turquette <mturquette@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ARM: shmobile: kzm9d: Use common clock framework
Message-ID: <20131202022549.GA12357@verge.net.au>
References: <20131008143040.52f36df8edb7ab63224d8433@ops.dti.ne.jp>
 <20131008143403.c11f294c8a1701a2ab3bc5fd@ops.dti.ne.jp>
 <20131009034057.GO15065@verge.net.au>
 <CANqRtoQs+31mv0ZULOd3SGshkBkvp-kGoaVOSb10+Ncdp+WNXw@mail.gmail.com>
 <20131009065438.GA7220@verge.net.au>
 <CANqRtoSGFEjcBPDAtq3YCDbkiFCftyr8b=qniYqyMafng=zurw@mail.gmail.com>
 <20131009103915.GB17869@verge.net.au>
 <20131029044239.GC20432@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029044239.GC20432@verge.net.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 01:42:41PM +0900, Simon Horman wrote:
> On Wed, Oct 09, 2013 at 07:39:18PM +0900, Simon Horman wrote:
> > On Wed, Oct 09, 2013 at 04:29:56PM +0900, Magnus Damm wrote:
> > > Hi Simon,
> > > 
> > > On Wed, Oct 9, 2013 at 3:54 PM, Simon Horman <horms@verge.net.au> wrote:
> > > > On Wed, Oct 09, 2013 at 01:59:46PM +0900, Magnus Damm wrote:
> > > >> Hi Simon,
> > > >>
> > > >> On Wed, Oct 9, 2013 at 12:40 PM, Simon Horman <horms@verge.net.au> wrote:
> > > >> > On Tue, Oct 08, 2013 at 02:34:03PM +0900, takasi-y@ops.dti.ne.jp wrote:
> > > >> >> Use common clock framework version of clock
> > > >> >>  drivers/clk/shmobile/clk-emev2.c
> > > >> >> instead of sh-clkfwk version
> > > >> >>  arch/arm/mach-shmobile/clock-emev2.c
> > > >> >> when it is configured as a part of multi-platform.
> > > >> >>
> > > >> >> Signed-off-by: Takashi Yoshii <takasi-y@ops.dti.ne.jp>
> > > >> >
> > > >> > Thanks.
> > > >> >
> > > >> > I plan to add this patch to a new topic branch,
> > > >> > topic/emev2-common-clock, in the renesas tree and
> > > >> > queue it up from there for inclusion in mainline
> > > >> > if/when the first patch of this series is accepted
> > > >> > by Mike Turquette.
> > > >>
> > > >> Thanks for picking up patches, Simon.
> > > >>
> > > >> I think you can simply merge this patch after the following series:
> > > >>
> > > >> [PATCH 00/05] ARM: shmobile: KZM9D Multiplatform update
> > > >
> > > > This is already queued up.
> > > 
> > > Yes, I know, thanks for that. I tried to explain the dependency in the
> > > 00/00 cover letter but I will try to be more clear next time!
> > > 
> > > >> There are no build time dependencies on patch 1 and 2 so this patch
> > > >> can be merged independently. Regarding run-time operation, the
> > > >> multiplatform series above makes KZM9D DT reference only build for
> > > >> multiplatform, and in such case CCF is required.
> > > >>
> > > >> So if you want to keep KZM9D DT reference working until Mike Turquette
> > > >> accepts the CCF bits, then I recommend you to wait with "[PATCH 00/05]
> > > >> ARM: shmobile: KZM9D Multiplatform update" until all EMEV2 CCF bits
> > > >> have been merged.
> > > >>
> > > >> Another way is to merge "[PATCH 00/05] ARM: shmobile: KZM9D
> > > >> Multiplatform update" before the EMEV2 CCF bits, but if so you may as
> > > >> well merge this patch as well IMO. This
> > > >> multiplatform-update-series-merge-before-CCF plan will result in
> > > >> untestable KZM9D DT reference until EMEV2 CCF is merged. Either way is
> > > >> fine with me.
> > > >
> > > > I am mainly concerned that the bindings may change before
> > > > they are finally merged. And I thought it would be nice to avoid
> > > > having to fix up the usage of the bindings if they change.
> > > 
> > > Sure, but the code in this patch looks like it simply starts DT CCF
> > > probing regardless of what the bindings look like. So I don't think
> > > you will have to worry about actual bindings detail.
> > > 
> > > > But I'm happy to just queue-up patches 2 and 3 of this series
> > > > now if you prefer.
> > > 
> > > Well, I meant patch 3 only. Patch 1 and 2 are tied together by dependencies. =)
> > 
> > Thanks, I understand now.
> > 
> > I'll queue-up 3/3.
> 
> Which I did.
> 
> Then some time passed...
> 
> Mike has accepted my pull-request for patch 1 of this series
> and accordingly I have queued-up this patch for v3.14.
> It should appear in the devel branch the next time that I push it.

I was mistaken. It was not queued up  for v3.14.
And still has not been queued up.

I have un-queued this patch accordingly.
