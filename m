Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab3LLMPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:15:22 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19436 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3LLMPR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:15:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Dec 2013 04:17:56 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Stephen Warren <swarren@nvidia.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 12 Dec 2013 13:14:04 +0100
Subject: Re: [PATCHv6+ 01/13] of: introduce
 of_property_for_earch_phandle_with_args()
Thread-Topic: [PATCHv6+ 01/13] of: introduce
 of_property_for_earch_phandle_with_args()
Thread-Index: Ac73M6xBtzD4c4etRZeCfL/c7F0lZg==
Message-ID: <20131212.141404.684884000513445038.hdoyu@nvidia.com>
References: <20131211132845.5461FC4061A@trevor.secretlab.ca><20131211.153338.2186623380643957232.hdoyu@nvidia.com><20131212113417.BDCD0C40637@trevor.secretlab.ca>
In-Reply-To: <20131212113417.BDCD0C40637@trevor.secretlab.ca>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely <grant.likely@linaro.org> wrote @ Thu, 12 Dec 2013 12:34:17 +0100:

> On Wed, 11 Dec 2013 14:33:38 +0100, Hiroshi Doyu <hdoyu@nvidia.com> wrote:
> > Hi Grant,
> >
> > Grant Likely <grant.likely@linaro.org> wrote @ Wed, 11 Dec 2013 14:28:45 +0100:
> >
> > > On Thu, 21 Nov 2013 11:57:00 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > > > On 11/21/2013 10:17 AM, Hiroshi Doyu wrote:
> > > > > Iterating over a property containing a list of phandles with arguments
> > > > > is a common operation for device drivers. This patch adds a new
> > > > > of_property_for_each_phandle_with_args() macro to make the iteration
> > > > > simpler.
> > > > >
> > > > > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> > > > > ---
> > > > > v6+:
> > > > > Use the description, which Grant Likely proposed, to be full enough
> > > > > that a future reader can figure out why a patch was written.
> > > > >   http://lists.linuxfoundation.org/pipermail/iommu/2013-November/007062.html
> > ...
> >
> > > That's right, I forgot I said that. Yes please fix the implementation.
> >
> > Here's the latest. I'll include this with the next v7 series.
> >
> > Can I get your Acked-by with this?
> >
> > --8<----
> >
> > From 8f7c0404aa68f0e8dbe0babc240590f6528ecc1f Mon Sep 17 00:00:00 2001
> > From: Hiroshi Doyu <hdoyu@nvidia.com>
> > Date: Fri, 15 Nov 2013 10:52:53 +0200
> > Subject: [PATCH] of: introduce of_property_for_each_phandle_with_args()
> >
> > Iterating over a property containing a list of phandles with arguments
> > is a common operation for device drivers. This patch adds a new
> > of_property_for_each_phandle_with_args() macro to make the iteration
> > simpler.
> >
> > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> > Cc: Rob Herring <robherring2@gmail.com>
> > ---
> > v7:
> > Fixed some minors pointed by Rob and Stephen.
> >
> > v6++++:
> > Iterate without intrducing a new struct.
> >
> > v6+++:
> > Introduced a new struct "of_phandle_iter" to keep the state when
> > iterating over the list.
> >
> > v6++:
> > Optimized to avoid O(n^2), suggested by Stephen Warren.
> > http://lists.linuxfoundation.org/pipermail/iommu/2013-November/007066.html
> >
> > I didn't introduce any struct to hold params and state here.
> >
> > v6+:
> > Use the description, which Grant Likely proposed, to be full enough
> > that a future reader can figure out why a patch was written.
> >
> > v5:
> > New patch for v5.
> >
> > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> > ---
> >  drivers/of/base.c  | 46 ++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/of.h | 32 ++++++++++++++++++++++++++++++++
> >  2 files changed, 78 insertions(+)
> >
> > diff --git a/drivers/of/base.c b/drivers/of/base.c
> > index f807d0e..cd4ab05 100644
> > --- a/drivers/of/base.c
> > +++ b/drivers/of/base.c
> > @@ -1201,6 +1201,52 @@ void of_print_phandle_args(const char *msg, const struct of_phandle_args *args)
> >       printk("\n");
> >  }
> >
> > +const __be32 *of_phandle_iter_next(const char *cells_name, int cell_count,
> > +                                const __be32 *cur, const __be32 *end,
> > +                                struct of_phandle_args *out_args)
> 
> Having to pass in cells_name, cell_count, cur and end each time seems a
> little odd. Can a state structure be used instead?
> 
> struct of_phandle_iter_state {
>         const char *cells_name;
>         int cells_count;
>         const __be32 *cur;
>         const __be32 *end;
>         struct of_phandle_args out_args;
> }
> 
> Make the caller provide one of those and fill it in with the init
> function.

I rewrote this a few times and so now I have a few version of this
implementations :-) The above proposal is similar to the version v6+++
mentioned in the above patch note:

> > v6+++:
> > Introduced a new struct "of_phandle_iter" to keep the state when
> > iterating over the list.

which is:

  [RFC][PATCHv6+++ 01/13] of: introduce of_property_for_earch_phandle_with_args()
    http://lists.linuxfoundation.org/pipermail/iommu/2013-November/007087.html

Stephen seemed to prefer the version without state struct. I like the
idea to not pass the same arguments repeatly. Instead, wrapping them
in a struct with state may look better.

So if Stephen agrees, I'll rewrite the version with state struct
again.
