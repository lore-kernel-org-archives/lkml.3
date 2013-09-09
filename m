Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3IIM6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 08:58:43 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:58790 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3IIM6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 08:58:41 -0400
Date: Mon, 9 Sep 2013 14:57:46 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Arjun Gopalan <agopalan@nvidia.com>, Brian Swetland <swetland@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Paul Walmsley <pwalmsley@nvidia.com>
Subject: Re: permission to move definition of struct rpmsg_channel_info
Message-ID: <20130909125745.GD22197@ulmo>
References: <5220F099.1020002@nvidia.com>
 <CAK=WgbZ2JgtAonvdyeDZazYBGdKpPAieJtjzi7MM6nwqhVfs7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="48TaNjbzBVislYPb"
Content-Disposition: inline
In-Reply-To: <CAK=WgbZ2JgtAonvdyeDZazYBGdKpPAieJtjzi7MM6nwqhVfs7g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 08, 2013 at 02:27:11PM +0200, Ohad Ben-Cohen wrote:
> Hi Arjun,
>=20
> On Fri, Aug 30, 2013 at 9:20 PM, Arjun Gopalan <agopalan@nvidia.com> wrot=
e:
> >
> > Hi Ohad/Brian,
> >
> > I have been working on rpmsg and I need to be able to create static
> > rpmsg channels. Channel information needs to be specified by other
> > drivers and for this, the drivers need access to struct
> > rpmsg_channel_info.
>=20
> I'm not convinced how useful it is for other Linux drivers to create
> static rpmsg channels?
>=20
> Usually these channels reflect the existence of services running on
> the remote processor, and their creation (or lack thereof) should be
> specified in the remote image. This way an rpmsg channel is published
> iff there is a matching remote service.

If I understand correctly, the way that the services should be announced
is via RSC_VDEV entries in the resource table?

Looking at the remoteproc core and ELF loader, it seems like the way to
pass in the resource table is either via an extra ELF section or driver
specific. TI drivers seem to use ELF, but the STE modem driver seems to
employ some custom format.

=46rom what I understand this resource table can also be processed by the
host to provide some of the resources such as carveout memory. So that
the normal way for this to work would be something like:

	- load firmware image
	  - obtain pointer to resource table
	- process resource table
	  - allocate resources
	  - update table
	- upload firmware to remote processor

Upon which the remote processor probably needs to parse the resource
table to set itself up. Does that sound about right?

> The way we were planning to add static channels functionality (I
> should still have preliminary patches doing this somewhere but the
> entire work was put on hold since TI changed its focus) is by
> statically publishing them in the resource table, which is coupled
> with a specific remote image.

While I see that the format of all this is pretty well documented, are
there any standard tools that can be used to embed the resource table
into an ELF binary? I have a pretty good idea on how it could be done,
but I wonder if it might make sense to provide some kind of a standard
set of headers to make things easier so that not everyone has to
reinvent the wheel.

Looking at the remoteproc core, it seems that there's no direct way to
change the firmware running on a remoteproc at runtime. The firmware
image is bound to one specific struct rproc. Is there something
fundamental that would prevent us from adding some sort of hotplug
support so that we could reload the remote processor with a different
firmware using a different resource table at runtime? A remote processor
is only exposed via sysfs, so I assume that's probably where we'd need
to hook that up to?

Perhaps I should mention that I'm investigating on using remoteproc for
something semi-related to what Arjun is working on, so I expect most of
these questions to be relevant to his work as well.

Thierry

--48TaNjbzBVislYPb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLcXJAAoJEN0jrNd/PrOhjJsP/1onbGK6687RoHtUZGo+uyGe
/DMXQQtwVCj7zVP8sZ8F0K9sJwXmFENJ/ERVXnDzNGtzwkWFkGqM/En4XTDGrLqC
3GqG9Ji+IHqEuAdXkh+ujpjb9oiEVBydY3vnFF2JQqXF+8veO5UL9I4EJoESUvSA
IHO7ZW+hru3ZXvaEqHshXw9STD7a5OWd7ew2Z3CsrihChAwwy6Th1k265U9frkL+
DI8O+X6LgjKv+VQEpzSHe9m2xbTMg5nD6Kz7qrH5zdHO6Ct3gG8XVXUQkf5MARRj
ZrDRkxxMdPMcUGVuPTt8DfMqcWVAhk11RR8RI1pWhW8P7s93Ko91BNspwxGHETiZ
3MBgmuTXccLkzzCCtDX//XpKho4NPZu5C/7rf/rabdIfGMin982xjUuU6XTagPUR
bLRPlY1P/1fiRDGJLju+EvD5CEpI3O14PbcP+OgRUQ16KfqYu0akrRAFuEAptRV3
M7lRcxuB3D5sbKh1/W3kvNZK98xaMwA2jNsI/RGcrLcSg/SN7n3hJrB/yD+wfkkI
flrgJ+Kz9nMaMUifgCTBLg4HaucY+ubSIoPuFumAbwOvdWtgaEPCcWzzuSBEZr5e
/eS6XS+3Qv6ssVez1w3ltAcyf1iTDWmDOraR5gcFF8dT4pEVfu03c0LC+LxAW1mU
MO0HmmRcVhdarAjArB0t
=yVlK
-----END PGP SIGNATURE-----

--48TaNjbzBVislYPb--
