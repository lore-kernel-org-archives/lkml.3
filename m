Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaJQPKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:10:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58492 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaJQPKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:10:47 -0400
Date: Fri, 17 Oct 2014 10:10:26 -0500
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
Subject: Re: [PATCH v2 00/16] usb: dwc3: add support for AMD NL SoC
Message-ID: <20141017151026.GN26260@saruman>
Reply-To: <balbi@ti.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/TUrtqMIkCP4YtJm"
Content-Disposition: inline
In-Reply-To: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/TUrtqMIkCP4YtJm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 17, 2014 at 04:53:25PM +0800, Huang Rui wrote:
> The series of patches add AMD NL SoC support for DesignWare USB3 OTG
> IP with PCI bus glue layer. This controller supported hibernation, LPM
> erratum and used the 2.80a IP version and amd own phy. Current
> implementation support both simulation and SoC platform. And already
> tested with gadget zero and msc tool.  It works well on file storage
> gadget.

patches look much, much nicer there are still a few things to fix. A
global set of issues which I see:

1) Let's get confirmation that all those quirks will be needed in
production as well, I have a feeling quite a few of them won't be.

2) All quirks should become 1-bit fields insteads of single-bits on a
32-bit variable.

3) All quirks should have DeviceTree counterparts. They should all
become boolean properties should we can:

	dwc->tx_deemphasis_quirk =3D of_property_read_bool(node,
		"snps,tx_deemphasis_quirk");

> These patches are generated on balbi/testing/next
>=20
> Changes from v1 -> v2
> - remove dual role function temporarily
> - add pci quirk to avoid to bind with xhci driver
> - distinguish between simulation board and soc
> - break down all the special quirks
>=20
>=20
> Patch 1:
> - add PCI device id into pci bus glue

this guy should be the last in the series, with all AMD quirks being
enabled at once. This will avoid bisection points where AMD's platforms
don't work.

> Patch 2:

this should become as patch one :-)

> - add PCI quirk to avoid to bind with xhci
>=20
> Patch 3:
> - enable hibernation
>=20
> Patch 4:
> - distinguish between simulation board and soc
>=20
> Patch 5:
> - add quirks flag to be compatible for kinds of soc
>=20
> Patch 6 - 16:
> - as felipe's suggestion, break down all the special quirks of amd nl
>=20
>=20
> Patch set already passed all the MSC testing, detailed result is below:
>=20
> root@hr-ub:/home/ray/felipe/usb-tools# ./msc.sh -o /dev/sdb1
> test 0e: simple 64k read/write
> test  0: sent      62.50 MB read      22.00 MB/s write      16.33 MB/s ..=
=2E success

Are you still running with VERBOSE_DEBUG on USB2 ? Here's what I get on
USB2 connected to my PC with DWC3 running on a single-core cortex-a9
board:

$ ./msc -t0 -o /dev/sdh -s 65536 -c 5000
test  0: sent     312.50 MB read      31.63 MB/s write      29.10 MB/s ... =
success

And with RAM as backend:

$ ./msc -t0 -o /dev/sdh -s 65536 -c 5000
test  0: sent     312.50 MB read      31.64 MB/s write      29.04 MB/s ... =
success

cheers

--=20
balbi

--/TUrtqMIkCP4YtJm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQTFiAAoJEIaOsuA1yqREpxYQAKb0mo7Peg3eyQgcm+bALpcq
/x70lR7SJQRk9eSWuHA/VIJ5cBtTDYnwILAD6e4fT+1VGTMV6Z1raqi7GPMyWzv9
sXHktZccJalLAhaRCLWL8kjAr1JzhvDB5mQ9vkNGcX94bx9rTaXbhyoDUgWKunj2
inIei2pxqEZ/+yVrk6kh5G6C7YmQ4R+OUuCaB4Ix5t+hNrh/6labx6heSZfETcNC
WjNesMnr/4BUyrDZr1wo++VJYl3z46ukjASLnlEzldMAJekbaSGS6sZALfUqADuD
1BnYRAcmy3YvKD7lfBr2ocOSF50+1byM9SJZucId1iu3jSpdV7iOlkj0cikwZWa6
Oony54PHJlNdTzbPyfDMJ08Gj7Sdog3wecyQjGkmfbGvbMDCbWVLvHMdL1bfZn6W
CDMtRRYEi6w/dRPm+KiyIzYSR0hPt802D8gII916w2RBUq04/15y7AjSzk4frDZy
YDOZoHSLbvie9/hg7IasnWt5yV2Xc2RQhHWiGuw/9O7tnHCehml9noppy7BjlOux
7YR6+2KlguskKcTpbVawqjmgvPLnqeAysJ8BCAasTRJlvg7xGXYfU8IJ6MZpG87k
vskHydbQNG8NV0L1mWTdNwjzMiwQdAJPwsox0CA3eX9d2WT/cteEJfQFczQtI6Ae
YZFERZINKg3Ip8+6l9eX
=0DTv
-----END PGP SIGNATURE-----

--/TUrtqMIkCP4YtJm--
