Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaFWS1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:27:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43342 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbaFWS1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:27:30 -0400
Date: Mon, 23 Jun 2014 13:27:25 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <m.szyprowski@samsung.com>,
        <andrzej.p@samsung.com>
Subject: Re: [PATCH] usb: gadget: add claimed field in struct usb_ep
Message-ID: <20140623182725.GD5073@saruman.home>
Reply-To: <balbi@ti.com>
References: <1402906836-12733-1-git-send-email-r.baldyga@samsung.com>
 <20140619150853.GG23782@saruman.home>
 <53A7C42F.1060603@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F8dlzb82+Fcn6AgP"
Content-Disposition: inline
In-Reply-To: <53A7C42F.1060603@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--F8dlzb82+Fcn6AgP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 23, 2014 at 08:07:43AM +0200, Robert Baldyga wrote:
> On 06/19/2014 05:08 PM, Felipe Balbi wrote:
> > On Mon, Jun 16, 2014 at 10:20:36AM +0200, Robert Baldyga wrote:
> >> This field allows to mark ep as claimed in more clear way. Claiming
> >> endpoint by setting driver_data to non-null value is leaky solution
> >> and makes code unreadable.
> >=20
> > how come ? How can it be unreadable ? how can it be leaky ?
> >=20
>=20
> What if gadget will not assign any value to driver_data (just like
> Gadget Zero do)? Endpoint will be seen as not used, and autoconfig will

huh ??? The gadget isn't the endpoint user, the function is. Look at
f_sourcesink.c and f_loopback.c. If the function doesn't set anything to
driver_data, then that's a bug on the function which needs fixing.

Moreover, if there's a function which doesn't set driver_data, we could
just as well have a function which doesn't set "claimed", so the problem
is the same.

--=20
balbi

--F8dlzb82+Fcn6AgP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqHGNAAoJEIaOsuA1yqREhScQAKrlgENgZA4eLuIyKYtJV3L+
8Je8jN7UeVU+1Qk1FXXoVVSEhbhqhkUML5Zefb3avqmeljetWUEYu7oxXCDhP1P7
JyP5ntLO496paRG0cdeYlJqf7xDuZ6imlLM2Wdlq5uRGTTr+G3nH76vHAgM/OuO+
CwwEQinUP/b+waNWlfVj1JFFl5yUsMIM62NK/eHNSWFizkVa6u1W2J9Q80EIyWmC
QwQv5x2+d/sJzYkx0E6SkRdNEp73cgntT+y+QI9ntULHv+BeRlxVPUgN30gl+wXZ
MiFyyLVQS97askKvVKLV+fQQrkasBPfQ1/SmeqeO7w33iXNC/5+FzOSL+91MjeA5
gS1J3hZkUdH13nFneJBo94mLXrjPjbIie1yoCHQ24VWTX29ug1iAAyPDQ9WSGAdc
9yNujRLTe1DQz7UAmPjdzCFcbjNFPfTQp7k8RL+hXFIcJkFQFG7wbsYFlBSbm0/B
IZmqrZSb8sHlSGx+YTPdyO8Krmf2ADPgyuPERs4T+62b93mRLrHOinBROlxmgHOp
uHHM10EhPCoRFNsE3/WFbvohUomcJi3zdAqUX7/MNH1+98LQ5c3DzkEd6xWSLnZ9
Xp+5P9kNFHltmjUeYyN1wjfK+Imy1GzBmqJyvzFhnRwNhgMKIO8i+q7NDbluALoh
Aath511SkimAdtP9Lc+a
=hLQX
-----END PGP SIGNATURE-----

--F8dlzb82+Fcn6AgP--
