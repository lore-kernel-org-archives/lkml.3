Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbaJXP0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:26:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33047 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbaJXP0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:26:19 -0400
Date: Fri, 24 Oct 2014 10:25:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 05/16] usb: dwc3: add quirks support to be compatible
 for kinds of SoCs
Message-ID: <20141024152553.GB26941@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-6-git-send-email-ray.huang@amd.com>
 <20141017144144.GA26260@saruman>
 <20141020060217.GA24357@hr-slim.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
In-Reply-To: <20141020060217.GA24357@hr-slim.amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2014 at 02:02:17PM +0800, Huang Rui wrote:
> On Fri, Oct 17, 2014 at 09:41:44AM -0500, Felipe Balbi wrote:
> > HI,
> >=20
> > On Fri, Oct 17, 2014 at 04:53:30PM +0800, Huang Rui wrote:
> > > This patch adds a quirks flag at dwc3 structure, and SoCs platform ve=
ndor is
> > > able to define this flag in platform data at bus glue layer. Then do =
some
> > > independent behaviors at dwc3 core level.
> > >=20
> > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > ---
> > >  drivers/usb/dwc3/core.c          | 2 ++
> > >  drivers/usb/dwc3/core.h          | 3 +++
> > >  drivers/usb/dwc3/dwc3-pci.c      | 9 +++++++++
> > >  drivers/usb/dwc3/platform_data.h | 2 ++
> > >  4 files changed, 16 insertions(+)
> > >=20
>=20
> <snip>
>=20
> > > diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/plat=
form_data.h
> > > index 7db34f0..1d3d65f 100644
> > > --- a/drivers/usb/dwc3/platform_data.h
> > > +++ b/drivers/usb/dwc3/platform_data.h
> > > @@ -24,4 +24,6 @@ struct dwc3_platform_data {
> > >  	enum usb_device_speed maximum_speed;
> > >  	enum usb_dr_mode dr_mode;
> > >  	bool tx_fifo_resize;
> > > +
> > > +	u32     quirks;
> >=20
> > I prefer to have one-bit fields like we already have for delayed_status,
> > ep0_bounced, ep0_expect_in, and so on. That makes it easier to support
> > the same quirks through devicetree as well.
> >=20
>=20
> So it should define like below:
>=20
> struct dwc3_platform_data {
>         ...
>         unsigned one_quirk:1;
> }
>=20
> Then also defined it in dwc3 structure. And when dwc3 probed, put this
> value from glue layer to dwc3, right?

that's correct.

--=20
balbi

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSm+BAAoJEIaOsuA1yqREhc4P/iMkoQnBTG9qDy9qgIgRdUoV
4RZzo8CdPs1cV6Erq+jDl6s+fpjgiGQ5ImOEb7g/0KezBvAWYtZxcx+uzYfTrMxM
M/oH9Xe1prDWFR7bX5iveK8hrkU1sjcdEQ0hF4rDcAbylEnA4tnCIZclp8El17fC
GagNwQRdI3nF5957j4GWerpuhTcm7tOkbSZTltBh6mu9GPgFwy++0eq0R0IxHcG5
vOnZ73aEusXX/6zUcw02LWYtB/u2L800nYoctdbypoQ45YQNGojiWGZweuqAgCN9
YfBkW9tIoAFf/601+hqji3KSqIPTlJJa9R1zFsUZ3Zb2H6EdTXkiZBl1xffcTLcY
TaBs+zdmipr5nFfk+KFK5B4Wvpbt0tbg3/Fh6yLTEkvNzX60qqE3Ttu63nas4ngW
rmCpxxyGXW7e6HXrUZTaU8beYBzUPHxyiL8OjCWHjWDeSkkSM59JcsVwLrrAhFzm
YQG5tzifLkFASANxmHlpdVdkKSkJ7kjxn6I8Vf9pf/RS2Hk2eLNXITRRpY3kTR2J
nRyNAet3qXqpy/q0QxQ5o4q7iwP+81DYvL1FxoCMh4VDO2Xo3Si6cAcgDMDQ05Uu
pcpu1cwBLSCTwYln/n1dyRbn8i0LOrj5Puw2vQUNQ18hsKi+SJb4o9el45Ontw2b
UsycxUOr9kaziE3x4RXT
=9mt3
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
