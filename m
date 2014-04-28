Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbaD1K47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:56:59 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:56048 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaD1K4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:56:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        kgene.kim@samsung.com, Shaik Ameer Basha <shaik.ameer@samsung.com>,
        prathyush.k@samsung.com, grundler@chromium.org, joro@8bytes.org,
        supash.ramaswamy@linaro.org, linux-kernel@vger.kernel.org,
        pullip.cho@samsung.com, tomasz.figa@gmail.com, sachin.kamat@linaro.org,
        iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        s.nawrocki@samsung.com, a.motakis@virtualopensystems.com,
        Varun.Sethi@freescale.com, joshi@samsung.com, t.figa@samsung.com,
        rahul.sharma@samsung.com, Hiroshi Doyu <hdoyu@nvidia.com>,
        Will Deacon <will.deacon@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH v12 11/31] documentation: iommu: add binding document of Exynos System MMU
Date: Mon, 28 Apr 2014 12:56:03 +0200
Message-ID: <6544270.ddFBoY6LMm@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140428103919.GF19455@ulmo>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com> <4447051.OnJtcFSqFV@wuerfel> <20140428103919.GF19455@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:qFTflV221idwNLBUOP2dQQAIZHC36PsGsyI6C8P2Kux
 0Vy6X2MEZurVd9W6qfg/kIAtMAKfJuEzl+3uW2zaLd1cb7TS13
 jAE1F5MQaGrZ64Nz3KePocSvu/Ripp7uw7sQ0Wk77yThfv6D7i
 FPCFsXKftmJJ0LqiezY//3BVwojQdnO6KorqqRXw4ou1O7/h5R
 kayBTVH5KkMt8oKN/bhmrmah9J6LuX5lY7Zv1JU4+jo78p5IFm
 28v/5XxWBA7CO9ptdmXQ1I9OgFgwSMWAgE9THEpTW8tRk9QmDe
 JkRj7ObOAhfnpIhCqrLKCmP71zxtshxgK2Vo65jXjb4OzxsXKn
 KWUngO8dM+mR4pewHP7w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2014 12:39:20 Thierry Reding wrote:
> On Sun, Apr 27, 2014 at 08:23:06PM +0200, Arnd Bergmann wrote:
> > On Sunday 27 April 2014 13:07:43 Shaik Ameer Basha wrote:
> > > +- mmu-masters: A phandle to device nodes representing the master for which
> > > +               the System MMU can provide a translation. Any additional values
> > > +              after the phandle will be ignored because a System MMU never
> > > +              have two or more masters. "#stream-id-cells" specified in the
> > > +              master's node will be also ignored.
> > > +              If more than one phandle is specified, only the first phandle
> > > +              will be treated.
> > 
> > This seems completely backwards: Why would you list the masters for an IOMMU
> > in the IOMMU node?
> > 
> > The master should have a standard property pointing to the IOMMU instead.
> > 
> > We don't have a generic binding for IOMMUs yet it seems, but the time is
> > overdue to make one.
> > 
> > Consider this NAKed until there is a generic binding for IOMMUs that all
> > relevant developers have agreed to.
> 
> I'd like to take this opportunity and revive one of the hibernating
> patch sets that we have for Tegra. The last effort to get things merged
> was back in January I think. I haven't bothered to look up the reference
> since it's probably good to start from scratch anyway.
> 
> The latest version of the binding that was under discussion back then I
> think looked something like this:
> 
> 	device@... {
> 		iommus = <&iommu [spec]>[, <&other_iommu [other_spec]>...];
> 	};
> 
> And possibly with a iommu-names property to go along with that. The idea
> being that a device can be a master on possibly multiple IOMMUs. Using
> the above it would also be possible to have one device be multiple
> masters on the same IOMMU.

Yes, that seems reasonable. Just one question: How would you represent a
device that has multiple masters, with at least one connected to an IOMMU
and another one connected to memory directly, without going to the IOMMU?

> On Tegra the specifier would be used to encode a memory controller's
> client ID. One discussion point back at the time was to encode the ID as
> a bitmask to allow more than a single master per entry. Another solution
> which I think is a little cleaner and more generic, would be to use one
> entry per master and use a single cell to encode the client ID. Devices
> with multiple clients to the same IOMMU could then use multiple entries
> referencing the same IOMMU.

I'm not completely following here. Are you talking about the generic
binding, or the part that is tegra specific for the specifier?

My first impression is that the generic binding should just allow an
arbitrary specifier with a variable #iommu-cells, and leave the format
up to the IOMMU driver. A lot of drivers probably only support one
master, so they can just set #iommu-cells=<0>, others might require
IDs that do not fit into one cell.

	Arnd

