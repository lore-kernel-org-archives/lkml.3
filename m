Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaKEOE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:04:29 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:65195 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaKEOE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:04:28 -0500
Date: Wed, 5 Nov 2014 15:04:25 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Herrmann <dh.herrmann@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC 1/2] core: Add generic object registry implementation
Message-ID: <20141105140418.GA18067@ulmo>
References: <1415118568-18771-1-git-send-email-thierry.reding@gmail.com>
 <545A19C8.6090508@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Content-Disposition: inline
In-Reply-To: <545A19C8.6090508@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 05, 2014 at 01:36:24PM +0100, Andrzej Hajda wrote:
> On 11/04/2014 05:29 PM, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > Add a generic implementation of an object registry. This targets drivers
> > and subsystems that provide auxiliary objects that other drivers need to
> > look up. The goal is to put the difficult parts (keep object references,
> > module usage count, ...) into core code so that individual subsystems do
> > not have to deal with them.
> >=20
> > The intention is for subsystems to instantiate a struct registry and use
> > a struct registry_record embedded into a subsystem-specific structure to
> > provide a subsystem-specific API around that.
>=20
>=20
> As I understand you want to use this registry for panels and bridges.
> Could you explain the idea and describe example scenario when these
> refcountings are useful. I guess it should be when panel attached to
> drmdrv want to disappear.

Correct. When a panel driver is unloaded it frees memory associated with
the panel. The goal of this registry is for the panel object to stay
around until all references are gone.

> Real lifetime of panel is limited by probe/remove callbacks of panel
> driver, do you want to prolong it behind these limits?

Yes.

> Do you want to have zombie panels, without hardware they abstract? For
> what purpose?

So that display drivers don't try to access objects that have been
freed.

> What do you want to do with panel ops? Do they need support both life
> states?

That's a slightly separate issue for which David Herrmann had a solution
in mind. As I understand it, the idea would be for these objects to gain
revoke support. The goal is that once the underlying object disappears,
calling any of the operations involved would fail (with something like a
-ENODEV). It's a little more complicated than that because the device
could disappear right in the middle of such an operation, but that's
precisely what revoke should allow us to do. Readding David for
visibility.

> Anyway implementation currently seems to be broken,

DRM panels are currently completely broken. If you remove the driver for
a panel the display driver that uses this panel will simply crash the
next time it tries to do anything with the panel. This type of registry
is the first step in trying to fix this.

>                                                     you try to refcount
> objects which are usually embedded in driver priv data, which disappears
> during remove callback of the driver.

A second step in fixing this will be to convert drivers to no longer
free the panel but rather drop their reference to the panel that they've
registered. This will make sure that memory doesn't get freed until all
references are gone.

Note that this means that drivers will also need to be converted not to
use devm_* helpers since that conflicts with the reference counted life-
times of these record objects.

Thierry

--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUWi5mAAoJEN0jrNd/PrOhSpYQALH8pOxcW7bqyF99NHfCbWN7
TzzU5QutUznRPQPM8S6LP18hMr5Km/RbBCqS+o3CqH5R+4yrs1XHlYmaCheD5HiD
itWe5WScPHMjx8VL3KrqA1CElr/cqUUhY9QJ9MeWHYklMBK5lUMJjsormnMp5ME3
befsn/DQGxjloBMoU3LQtzvHuG/+QsbAdHu5CHq1eDbtTDG9bZZ1ZLiiB3ftho5o
RCp43olfRhGoeKSM1op/oZ+RVe+/EmojkE7DFt0zvWeQJPn+WFDU7rRyurJXcQ2H
bKajBRneh/MHy6CL9eGHF7kFlO56LsXaPPyUWAQhbXkk9P5A313n73LRlCz2qs0V
yLp9QGoiFadCNyVGUPgq70HmkiR/auv5RRHVx/30yjI4uRfd817MotHCcUydEuU5
QC+PHM0pAgW+h9ua4B6VYVbb4yGEoU5BpgNTff8vvm85e8hAwOTech4X6C1r52FC
RpfH45HpeBGywkVpMBhfYJDcaRc2sc7V6vHO+7a5/2GGxLqcWxhGgDnhIXWqkGb9
Mis1ZFEVgTRoMoEEtBlt87gA82Z6Idd9MNrRyMbJq0F6zmHfkdFuhV9ZXWXhEWrY
kE+a1dr15BYQwBe315f3BIUZMQ9GlmjdBqEk1TkEHxncP65oqrl5cKEwdbxUWmfu
dsmgWCmn7Ew1ErWdtviK
=SR63
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--
