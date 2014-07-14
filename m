Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaGNJbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:31:51 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49748 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaGNJbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:31:42 -0400
Date: Mon, 14 Jul 2014 11:31:37 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5/8] of: Add Tegra124 EMC bindings
Message-ID: <20140714093136.GB9755@ulmo>
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
 <1405088313-20048-6-git-send-email-mperttunen@nvidia.com>
 <20140711145146.GA6523@ulmo>
 <53C00A57.5070102@kapsi.fi>
 <53C38D07.4030402@nvidia.com>
 <20140714081524.GI2081@ulmo>
 <53C39D98.9040802@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0ntfKIWw70PvrIHh"
Content-Disposition: inline
In-Reply-To: <53C39D98.9040802@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 12:06:32PM +0300, Mikko Perttunen wrote:
> On 14/07/14 11:15, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Mon, Jul 14, 2014 at 10:55:51AM +0300, Mikko Perttunen wrote:
> >>On 11/07/14 19:01, Mikko Perttunen wrote:
> >>>On 07/11/2014 05:51 PM, Thierry Reding wrote:
> >>>>On Fri, Jul 11, 2014 at 05:18:30PM +0300, Mikko Perttunen wrote:
> >>>>>...
> >>>>...
> >>>
> >>>In this case, all the registers that will be written are such that the
> >>>MC driver will never need to write them. They are shadowed registers,
> >>>meaning that all writes are stored and are only effective starting from
> >>>the next time the EMC rate change state machine is activated, so writi=
ng
> >>>them from anywhere except than the EMC driver would be pointless.
> >>>
> >>>I can find two users of these registers in downstream:
> >>>1) mc.c saves and loads them on suspend/restore (I don't know why, that
> >>>shouldn't do anything. They will be overridden anyway during the next
> >>>EMC rate change).
> >>>2) tegra12x_la.c reads MC_EMEM_ARB_MISC0 during a core_initcall to
> >>>calculate a value which it then writes to a register that is also
> >>>shadowed and that is part of downstream burst registers so that doesn't
> >>>do anything either.
> >>>
> >>>The reason I implemented two ways to specify the MC register area was
> >>>that this could be merged before an MC driver and retain
> >>>backwards-compatibility after the MC driver arrives.
> >>>
> >>>If this is not acceptable, we can certainly wait for the MC driver to =
be
> >>>merged first. (Although with the general rate of things, I hope I won't
> >>>be back at school at that point..) I assume that this is blocked on the
> >>>IOMMU bindings discussion? In that case, there are several options: the
> >>>MC driver could have its own tables for each EMC rate or we could just
> >>>make the EMC tables global (i.e. not under the EMC node). In any case,
> >>>the MC driver would need to implement a function that would just write
> >>>these values but be guaranteed to not do anything else, since that cou=
ld
> >>>cause nasty things during the EMC rate change sequence.
> >>
> >>Having taken another look at the code, I don't think the MC driver coul=
d do
> >>anything that bad. There are also two other places where the EMC driver
> >>needs to read MC registers: Inside the sequence, it reads a register but
> >>discards its contents. According to comments, this acts as a memory bar=
rier,
> >>probably for the preceding step that writes into MC memory. If the regi=
ster
> >>writes are moved to the MC driver, it could also handle that. In another
> >>place it reads the number of RAM modules from a MC register. The MC dri=
ver
> >>could export this as another function.
> >
> >Exporting this functionality from the MC driver is the right thing to do
> >in my opinion.
>=20
> Ok, let's do that then. Do you think I could make a bare-bones MC driver =
to
> support the EMC driver before your MC driver with IOMMU/LA is ready? Can =
the
> MC device tree node be stabilized yet? Of course, if things go well, that
> concern might turn out to be unnecessary.

Well, at this point this isn't 3.17 material anyway, so there's no need
to rush things. I'd prefer to take a patch on top of my proposed MC
driver patch in anticipation of merging that for 3.18. But if it turns
out that for whatever reason we can't do that, having a separate patch
makes it easy to extract the changes into a bare-bones driver.

Thierry

--0ntfKIWw70PvrIHh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTw6N4AAoJEN0jrNd/PrOh//IQAKKu+8XkU1NQ3I6maWLqiOs8
I3SnT9bBaQTukLfsIqh+t4t3CAXIJrzm7pC4VXRxG3o/ZmEC37KXiwb/Ryhqm84K
oUFtBaoFgTlyO/tM0m2nKJmv22zCF58t3fU+VsHgYpA/3Hddu7OWZUYTvFSEZF8U
qg4EsgbpV20MBmbHCnMgo1CYYn5ZT4Rd6HCb8djMkw2b0WjMtCf0wZwht8TbEifU
och/XL88TYoE9bgSiR9HmITrmhLLpdSCCiD1bEdhAZYZRRellYJfknS8slFkFaIs
p55WyrlZJBmPYPTtvkzmwUxjibPfgE5ZSIvR9JYCbYAbv2GB1tMHgUVT770vlMWQ
rWEVKtkEvRNnxHJq8lxBhBEGkwtmvWYsOEfsn+L3oDxWFxFDHyjda9ytY1AjgN+p
gwJR3gZDEALDT772RgFTuzMc5nfBA/Utl4EjNRS/hEyvDT8X2HJ9YtAEQeXxPCL/
+V3JG9yBnmMCB0CY/INIO9wzMU6dbKMIGxy126CI2S1IPFJttqPT4nM3UAQQ2nMy
FsLNZN9vAgyQIsA0oUu98em9qFwgVjXlP6k5l7T0IoZ2A69QHHFfofA69ZdjmWcD
/99XtyjROWw1AH79bIJVlY0g+BvzGs6Jn3BA02goXGo/OQH9Ya9lNHbSmZrQtkbt
+hP/XzSyF1PBSpwzba9O
=7mmC
-----END PGP SIGNATURE-----

--0ntfKIWw70PvrIHh--
