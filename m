Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab3H1NcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:32:07 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:59724 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3H1NcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:32:03 -0400
Date: Wed, 28 Aug 2013 15:31:28 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] PCI: tegra: replace devm_request_and_ioremap by
 devm_ioremap_resource
Message-ID: <20130828133127.GE604@ulmo>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376911241-27720-2-git-send-email-Julia.Lawall@lip6.fr>
 <20130819120249.GA5740@ulmo>
 <CAErSpo5oOnfhi+aRi-Z3kCwS1VpYSO6FX5O_MOZmWNLcfhhA9w@mail.gmail.com>
 <20130819201224.GC5191@mithrandir>
 <CAErSpo6U9i16gdaYGpWqgLaFteXpy1erCUw55SqkHLcbypP=vA@mail.gmail.com>
 <20130827081443.GI8686@ulmo>
 <521CCF9B.9000004@wwwdotorg.org>
 <CAErSpo461H=3qD5Xb7rKkMcQ1_ipyAQ5Tv2VhZD4j578A+Bd9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AsxXAMtlQ5JHofzM"
Content-Disposition: inline
In-Reply-To: <CAErSpo461H=3qD5Xb7rKkMcQ1_ipyAQ5Tv2VhZD4j578A+Bd9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AsxXAMtlQ5JHofzM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2013 at 12:03:01PM -0600, Bjorn Helgaas wrote:
> On Tue, Aug 27, 2013 at 10:11 AM, Stephen Warren <swarren@wwwdotorg.org> =
wrote:
> > On 08/27/2013 02:14 AM, Thierry Reding wrote:
> >> On Mon, Aug 19, 2013 at 02:49:07PM -0600, Bjorn Helgaas wrote:
> >>> On Mon, Aug 19, 2013 at 2:12 PM, Thierry Reding
> >>> <thierry.reding@gmail.com> wrote:
> >>>> On Mon, Aug 19, 2013 at 02:04:24PM -0600, Bjorn Helgaas wrote:
> >>>>> On Mon, Aug 19, 2013 at 6:02 AM, Thierry Reding
> >>>>> <thierry.reding@gmail.com> wrote:
> >>>>>
> >>>>>> Bjorn, how do you want to handle patches to the Tegra PCIe
> >>>>>> driver in the future? Do you want me to prepare a branch
> >>>>>> and pull from that or would you rather just take simple
> >>>>>> patches?
> >>>>>
> >>>>> I'm in the habit of applying patches from email, so that's
> >>>>> easy for me.  But a branch would be OK, too.
> >>>>
> >>>> Patches work for me too. Is this cleanup patch something that
> >>>> you'd be comfortable with applying after 3.12-rc1 or would you
> >>>> rather defer it to 3.13?
> >>>
> >>> I'm not really sure how we should manage drivers/pci/host/*.
> >>> Those files are mostly arch code, and I'm not sure it's useful
> >>> for me to be in the middle of managing them.
> >>>
> >>> I assume Stephen or somebody has a tree with the pci-tegra.c
> >>> stuff that's in -next right now; it seems like it'd be simplest
> >>> to just add this patch there and merge in during the v3.12 merge
> >>> window.
> >>
> >> If Stephen's fine with it I suppose we could take pci-tegra.c
> >> driver changes through the Tegra tree. But I think it'd be good if
> >> we could still Cc you on patches so you're aware of what we're
> >> doing (that is the same for all drivers drivers/pci/host/*). And
> >> we're going to need your Acked-by on the patches as well.
>=20
> I think you have my Acked-by for this case already (from Aug 20).  And
> feel free to copy me on anything you like; my delete key works well :)
>=20
> > I can push Tegra PCIe patches through the arm-soc tree before
> > 3.12-rc1, but after that point, I think it's best if they go through
> > the PCIe tree, unless there's some cross-subsystem dependency for a
> > specific patch, and with the new PCIe driver, that's less likely.
>=20
> I'm OK with merging things through my tree.  It just seemed like there
> was a lot of recent Tegra activity that included a few Tegra PCI
> changes, and no benefit to trying to split the PCI stuff from the
> non-PCI stuff.  Hopefully it will calm down, because I don't have time
> to be in the middle of major Tegra stuff.

Yes, I think it will calm down. The difficulty this time around was that
there were various dependencies across multiple trees that needed to be
coordinated. As Stephen already mentioned, part of the reason to move
the driver out of arch/arm/mach-tegra was to make it stand on its own.

Thierry

--AsxXAMtlQ5JHofzM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSHfuvAAoJEN0jrNd/PrOhj20QAKmPJGBaZfgQ1W/fv4VB6cMc
rXAsqY4hUXmWJOHVNMxWocOo0tQE3P7nR5oWXduIxRrcGGYdbiXnylfR1NTcesQr
YRIrUDi3uO1fVgte6WanomavCgTzxpWb1GPwFB0Apk2oR+JkpFQo0vgV6pJIEnJa
K3zCPWeHqFBJaKQSHyzCwQ8VVlXe1q2PbQGX4yKMiFNT8tcTKuP9ZUKwejhclgUh
p9ZLZl/wDJLuVYQSAb2GJNV3PYS7vdKJpZpNayAr1hz/GjDnBxfbVRFH4YuoZcjG
UyJ3X2Dqz91qFYoE46C/QjJGhlv897GzOSQIvm/wcSI7XEbhoDzIQURd19DTMD/2
5JTmeJ5uM7Qwn4ztRywJFVhGHHtTPKmk2wbL7XevShh7r7DvVivARVJrBh+o0P66
9K+DhxL1gnp8UVLOhQbEAGh6ZjAiVEOYuqn2jV4DZKGGlKpu3uunGdKlZm9qMKpX
SWKaW40ZYo5pi38mWPbGGQf2tIoqZQY5Qu29qCnDjUxz9vN+bJbBXtKy6hOUC3VL
gsBKLShilouLxX5NhuaJRoNMAZG5KWYyqTGbD3r5L6cszUS9/tF7Z40Pzhv1TFkh
QZ4Nrh/GMcDs3mmanUddqJ8Dnexj1t3lFyQnUGIm0S0klnUi/35qLaTeieH9Du51
vGSEHjkn+4rMHAENx2be
=+qsl
-----END PGP SIGNATURE-----

--AsxXAMtlQ5JHofzM--
