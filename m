Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaIYN4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:56:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35547 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbaIYN4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:56:49 -0400
Date: Thu, 25 Sep 2014 08:56:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>, Michal Sojka <sojka@merica.cz>,
        <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Bryan Wu <cooloney@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.vokac@comap.cz>
Subject: Re: [PATCH v6 0/4] LED triggers for USB host and device
Message-ID: <20140925135632.GA28045@saruman>
Reply-To: <balbi@ti.com>
References: <Pine.LNX.4.44L0.1409241106100.1580-100000@iolanthe.rowland.org>
 <1411591401-5874-1-git-send-email-sojka@merica.cz>
 <20140924205936.GC17997@saruman>
 <20140924214155.GA30689@kroah.com>
 <20140924221830.GA27914@saruman>
 <20140924231550.GC27672@saruman>
 <20140925103623.GA28291@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <20140925103623.GA28291@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 25, 2014 at 12:36:23PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Sep 24, 2014 at 06:15:50PM -0500, Felipe Balbi wrote:
> > On Wed, Sep 24, 2014 at 05:18:30PM -0500, Felipe Balbi wrote:
> > > On Wed, Sep 24, 2014 at 11:41:55PM +0200, Greg Kroah-Hartman wrote:
> > > > On Wed, Sep 24, 2014 at 03:59:36PM -0500, Felipe Balbi wrote:
> > > > > On Wed, Sep 24, 2014 at 10:43:17PM +0200, Michal Sojka wrote:
> > > > > > This adds LED triggers for USB host and device. First two patch=
es
> > > > > > refactor UDC drivers as requested by Felipe Balbi, the next ren=
ames a
> > > > > > file and the last is the actual implementation of the LED trigg=
ers.
> > > > > >=20
> > > > > > Changes from v5:
> > > > > > - Refactoring of USB gadget completion split into two patches (=
Filipe
> > > > > >   Balbi)
> > > > > > - Removed check for non-NULL req->completion (Filipe Balbi)
> > > > > >=20
> > > > > > Changes from v4:
> > > > > > - Added performance numbers to the commit message of the last p=
atch
> > > > > >   (greg k-h).
> > > > > > - Replaced BUG_ON with pr_err (Alan Stern, greg k-h).
> > > > > > - Used proper coding style for switch statement (greg k-h).
> > > > > > - Added comment about NULL argument (greg k-h).
> > > > > > - EXPORT_SYMBOL changed to EXPORT_SYMBOL_GPL (greg k-h).
> > > > > > - Both triggers are now registerd even if host or gagdet subsys=
tem
> > > > > >   is not enabled (Bryan Wu, greg k-h).
> > > > > >=20
> > > > > > Changes from v3:
> > > > > > - usb_gadget_giveback_request() moved outside of CONFIG_HAS_DMA
> > > > > >   conditioned block.
> > > > > > - Added kernel-doc for usb_gadget_giveback_request() (Felipe Ba=
lbi).
> > > > > > - Removed outdated comment (Alan Stern).
> > > > > > - req->complete =3D=3D NULL is now a bug. Previously, this was =
ignored
> > > > > >   (Alan Stern).
> > > > > > - File rename moved to a separate commit (greg k-h).
> > > > > >=20
> > > > > > Changes from v2:
> > > > > > - Host/gadget triggers merged to a single file in usb/common/ (=
Felipe
> > > > > >   Balbi).
> > > > > > - UDC drivers refactored so that LED trigger works for all of t=
hem.
> > > > > >=20
> > > > > > Changes from v1:
> > > > > > - Moved from drivers/leds/ to drivers/usb/.
> > > > > > - Improved Kconfig help.
> > > > > > - Linked with other modules rather than being standalone module=
s.
> > > > > >=20
> > > > > > Michal Sojka (4):
> > > > > >   usb: gadget: Introduce usb_gadget_giveback_request()
> > > > > >   usb: gadget: Refactor request completion
> > > > > >   usb: Rename usb-common.c
> > > > > >   usb: Add LED triggers for USB activity
> > > > >=20
> > > > > Greg, how do you want to handle this one as it touched both host =
and
> > > > > gadget ? I could wait until you apply this series to your usb-nex=
t and
> > > > > based my pull request on that. That'll work as long as it doesn't=
 take
> > > > > too long for this to be merged.
> > > >=20
> > > > I can just take this now, for 3.18-rc1, you've already sent me your
> > > > patches for that release, so there shouldn't be any conflicts, righ=
t?
> > >=20
> > > that's better. Can you wait 1 day though ? I can run these through my
> > > build tests.
> >=20
> > running my build tests on top of v3.17-rc6 + these 4 patches. I'll
> > report back tomorrow. From a code perspective, though, they look
> > alright.
>=20
> Yes, will wait, thanks.

nothing interesting on my build tests. I have also tested the series
with my AM437x SK and I can see LED blinking with usb-gadget and
usb-host triggers.

For the whole series:

Tested-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUJB8QAAoJEIaOsuA1yqRErjwP/1MBkk3HSweKJhYvNDF7YElR
/BHMPtRNXNY/VYjgXdxy1WHi0q4ewdbPXOSkldI8u7Tr/8+F1hanqbl2KId1V8ok
MJJtFF0EAzHe4rdcw66ixsGl+FwVM/dJ4WU8zbF1dNd0DcXbYlEHtNWRi+5RSh1Q
4R2GWIijrHTfZbF4emWoQNCAuw+iBVFmBrIRQnVfny92s+niNXN5FfaZvo9rFFZ0
JeJUFWwxn9mTAxF0cuqFI3YZ9eVq8VcX3BSEa6XJpTNlTLg/O7h00n7mJ02wKmVw
fkt+G+KTqg206aBNPK5rDWNw+xOfmV0cJ4pYs4ZGddtHLfs88K/4gKDlfnGE/x2v
i5XykoiA/sarPpzvvJ5aFLoutVssfSXjMhpReSwAEuwZRgH452j1y6r8WI7x9Zos
6e3G70cWugOHDfXfOSwrF2nkf1xOnIhRs8EyB6SqLO29Ik7HZXmKGH9dqzgRmY8W
E3mBDmX1ePmfSilB2AaNrFx0Knj8cH2bZ0sqHPRuL4xxW2sCQ5hqerqUaZhiFEnC
yyTqePZx3bXNoD4vl5XtsX7GXhb/aLe55L6va6vex6N5iaJgVydXPHXqZHd5mmif
gy+ovgqpUDHnElpEKcAengbWqY2z71ceinY/c0FLUlV4KtApCHpaN6XCOVzQXbMp
rTn3xudKAJ0B/7kHKluH
=KEBL
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
