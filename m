Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbaF3Sdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:33:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37562 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaF3Sdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:33:50 -0400
Date: Mon, 30 Jun 2014 13:33:37 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <m.szyprowski@samsung.com>,
        <andrzej.p@samsung.com>
Subject: Re: [PATCH] usb: gadget: add claimed field in struct usb_ep
Message-ID: <20140630183337.GS31442@saruman.home>
Reply-To: <balbi@ti.com>
References: <1402906836-12733-1-git-send-email-r.baldyga@samsung.com>
 <20140619150853.GG23782@saruman.home>
 <53A7C42F.1060603@samsung.com>
 <20140623182725.GD5073@saruman.home>
 <53A96C23.8040800@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7L9kolmstoDTZ4pm"
Content-Disposition: inline
In-Reply-To: <53A96C23.8040800@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7L9kolmstoDTZ4pm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2014 at 02:16:35PM +0200, Robert Baldyga wrote:
> On 06/23/2014 08:27 PM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Mon, Jun 23, 2014 at 08:07:43AM +0200, Robert Baldyga wrote:
> >> On 06/19/2014 05:08 PM, Felipe Balbi wrote:
> >>> On Mon, Jun 16, 2014 at 10:20:36AM +0200, Robert Baldyga wrote:
> >>>> This field allows to mark ep as claimed in more clear way. Claiming
> >>>> endpoint by setting driver_data to non-null value is leaky solution
> >>>> and makes code unreadable.
> >>>
> >>> how come ? How can it be unreadable ? how can it be leaky ?
> >>>
> >>
> >> What if gadget will not assign any value to driver_data (just like
> >> Gadget Zero do)? Endpoint will be seen as not used, and autoconfig will
> >=20
> > huh ??? The gadget isn't the endpoint user, the function is. Look at
> > f_sourcesink.c and f_loopback.c. If the function doesn't set anything to
> > driver_data, then that's a bug on the function which needs fixing.
> >=20
> > Moreover, if there's a function which doesn't set driver_data, we could
> > just as well have a function which doesn't set "claimed", so the problem
> > is the same.
> >=20
>=20
> I mean the function, not the gadget. Sorry for confusion.
> Mechanism I developed marks endpoint as claimed *inside autoconfig
> function*. It's significant difference, because there's not possible to
> forget to mark that endpoint is claimed. When endpoint is returned from
> autoconfig function, it belongs to function, and the function doesn't
> need to do anything to claim obtained endpoint - it's already done.

we still might need to keep driver_data though. Some functions might
need it. But now that you explained your goal, I can see how that might
help. Please send a complete patchset also with the implementation for
ep_autoconfig so we can all review your idea.

cheers

--=20
balbi

--7L9kolmstoDTZ4pm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTsa2BAAoJEIaOsuA1yqREwGYP/AkEZ75r1GYUb+w/Ar1Dl3j5
fBDGVvjA5n5HTMhsEWLgWRCX1XmNPgAWpRZ3knn6w2GCGUt58F2QWMgT/828pFtt
GuCiBlXMtgFKVPCOXNZI5BfZeupbo2dSUbNgVdlvj0CYIMD0/YVFKsrVasoJeV3j
npJwzqjJIll6GnVGNTEuYHjeUV0L1mjS2gr6BBEkXL4jZgy+vjx3rXa3ufvSGhTY
2V/DgI6uiRZPcZa53+IM+zlAejOnzd3kyuoyz+O63BUxgNJj5UZ2kWt8vRuWIiW/
4kCBa/IvfTDMpy0thnOjM/IxByjihMVIhjoAYhr0N4S2BhMbJxAl6aCVhoCEqdA9
/fDxiER2AZqF6ggI0ZJLQgyfdYh8cv2gZ8qwzvui+6Es6B+lY4BESu4OBVyofVl0
sXLdgz+F9bIKF2ff00sK8OtBchGFWceI95ih7eB3yB3t2L0OQVobSITtdudVWhVH
nwCXgjOFk0LWAzIN3CCM08l/80Q4KcyD3ow/KWZTb+Abrscq5WsBW/1XRQ2zB/9T
RbKyo3I1ldLYHVi5W9d9GDeGz40y7b8xRUlxeBgYrkdfXLEu8WDo7xSRuzDY0RYB
35SPH3x2Dpivznw4Wtg097IfFzdi7M7KbAo6+mmtjF9ypkrnd/RV5tbrA23Xyws2
9e8HRHJA/CkGbznY8SAr
=PG0v
-----END PGP SIGNATURE-----

--7L9kolmstoDTZ4pm--
