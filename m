Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaKFJse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 04:48:34 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:42643 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaKFJs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 04:48:29 -0500
Date: Thu, 6 Nov 2014 10:48:22 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [RFC 1/2] core: Add generic object registry implementation
Message-ID: <20141106094820.GH26297@ulmo>
References: <1415118568-18771-1-git-send-email-thierry.reding@gmail.com>
 <545A19C8.6090508@samsung.com>
 <20141105140418.GA18067@ulmo>
 <545A49AF.9080901@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8/pVXlBMPtxfSuJG"
Content-Disposition: inline
In-Reply-To: <545A49AF.9080901@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8/pVXlBMPtxfSuJG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 05, 2014 at 05:00:47PM +0100, Andrzej Hajda wrote:
> On 11/05/2014 03:04 PM, Thierry Reding wrote:
> > On Wed, Nov 05, 2014 at 01:36:24PM +0100, Andrzej Hajda wrote:
> >> On 11/04/2014 05:29 PM, Thierry Reding wrote:
> >>> From: Thierry Reding <treding@nvidia.com>
> >>>
> >>> Add a generic implementation of an object registry. This targets driv=
ers
> >>> and subsystems that provide auxiliary objects that other drivers need=
 to
> >>> look up. The goal is to put the difficult parts (keep object referenc=
es,
> >>> module usage count, ...) into core code so that individual subsystems=
 do
> >>> not have to deal with them.
> >>>
> >>> The intention is for subsystems to instantiate a struct registry and =
use
> >>> a struct registry_record embedded into a subsystem-specific structure=
 to
> >>> provide a subsystem-specific API around that.
> >>
> >>
> >> As I understand you want to use this registry for panels and bridges.
> >> Could you explain the idea and describe example scenario when these
> >> refcountings are useful. I guess it should be when panel attached to
> >> drmdrv want to disappear.
> >=20
> > Correct. When a panel driver is unloaded it frees memory associated with
> > the panel. The goal of this registry is for the panel object to stay
> > around until all references are gone.
> >=20
> >> Real lifetime of panel is limited by probe/remove callbacks of panel
> >> driver, do you want to prolong it behind these limits?
> >=20
> > Yes.
> >=20
> >> Do you want to have zombie panels, without hardware they abstract? For
> >> what purpose?
> >=20
> > So that display drivers don't try to access objects that have been
> > freed.
>=20
> Why do not just release panel references from drm_dev, I have
> successfully implemented dsi panels this way, thanks to dsi bus specific
> attach/detach callbacks and drm hotplug mechansim.

Like you say yourself, that's something that work only for DSI. Any
other type of panel can't do this.

> My point is we do not need to make the whole tricky double refcounting,

There's no double refcounting. We have no refcounting at all at the
moment.

> with total redesign of panels, revoke, zombies, etc.... It is enough to

It's not a total redesign. It just makes it more mature and implements
features that I think are useful (and needed) but that were left out for
the sake of simplicity. Now it turns out that this is actually quite
fragile and easy to get wrong.

> have just hot plug/unplug callbacks. This is why I have proposed few
> months ago interface_tracker framework. It can add hot(un)plug
> capability in a generic way to any framework.

That's something that this object registry could easily implement as
well. But instead of passing around void * and type IDs as in the
interface tracker it could deal with real objects for proper type-
safety.

Thierry

--8/pVXlBMPtxfSuJG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUW0PkAAoJEN0jrNd/PrOhRqoP/19i1wySX4YsgH1G9dl1EGyG
SkIAPRk86FMhlyjzmv9F77IzMjodd1Wh4v+sjB+y1dRTZGXLWQPEbqGfV8m+1GaF
IsrQL5EsRhR5xRR//Wx5e51zzdZ0NMbtgTdgnTargfnZ1kWCaucCBTs47mPrnYHt
polG3eprOJ3yFFqzRC1iD7fGJv//OpnrFM3cocf2L/V9jmJVOX4Fm0w/CamqVdjK
VPfqqDrlremNZ7JbM26ICuWvivp2TeKOWbzavh7EyTIl7XBfWzX2fr/uANBf56Ph
SP1WwevALoOAf3SHqoXA1x2k9KLBtIY7/btsjC+nXnUdrG+W9naY8XPQPKhvQfOV
Kb+lATdAw3vQ8jJ1Gpu5prniWeJTCPWJOv4AJqMBEEXZxJ/f2Dzuh00sPjEqImox
6ZMdQdQbiwUoUUu/QoSy/Sh3n5Ym7xRsVfPkqbEL9DImvPjA/BPLFA3BE+IXGoX1
71q3Ruceo26YHXDV/URvaGhu5d9O1eYJi6hpk6vb4RdlEX2nYr5rJLgAb3dewTl6
eyPnn4Hn07qqR9VwVK1NPlwTD2AuZAmHW9VddsUy2bEO5+9nysXfy7cXt1VEQ9BF
twR3+lEdW1ToO+rArt2n5zFLjJ4HdB4RhDFW7eF493q9ShETEPnOHcYHxBlAe89x
evkADcE/Y3onFA7yN7Jh
=7ZxB
-----END PGP SIGNATURE-----

--8/pVXlBMPtxfSuJG--
