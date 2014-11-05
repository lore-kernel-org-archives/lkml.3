Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaKETH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 14:07:56 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57050 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaKETHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 14:07:54 -0500
Date: Wed, 5 Nov 2014 13:08:21 -0600
From: Felipe Balbi <balbi@ti.com>
To: Neil Zhang <zhangwm@marvell.com>
CC: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] usb: gadget: don't create new string_container if
 already exist
Message-ID: <20141105190821.GF6548@saruman>
Reply-To: <balbi@ti.com>
References: <1414496039-5655-1-git-send-email-zhangwm@marvell.com>
 <544F95C3.2080306@samsung.com>
 <9034CBD80F070943B59700D7F8149ED9024ED2A5B7@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="twz1s1Hj1O0rHoT0"
Content-Disposition: inline
In-Reply-To: <9034CBD80F070943B59700D7F8149ED9024ED2A5B7@SC-VEXCH4.marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--twz1s1Hj1O0rHoT0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 04, 2014 at 03:05:57AM -0800, Neil Zhang wrote:
>=20
> > -----Original Message-----
> > From: Andrzej Pietrasiewicz [mailto:andrzej.p@samsung.com]
> > Sent: 2014=E5=B9=B410=E6=9C=8828=E6=97=A5 21:10
> > To: Neil Zhang; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> > Cc: balbi@ti.com; gregkh@linuxfoundation.org
> > Subject: Re: [PATCH] usb: gadget: don't create new string_container if =
already
> > exist
> >=20
> > Hi,
> >=20
> > W dniu 28.10.2014 o 12:33, Neil Zhang pisze:
> > > Don't create new usb_gadget_string_container if the current strings
> > > are already exist in the usb_composite_dev.
> > > Otherwise the ids_tab will overflow soon if we bind / unbind usb
> > > functions frequently like android does.
> >=20
> > The problem you are describing does not exist in mainline kernel, where
> > functions are always unbound as part of the whole gadget's unbind - reg=
ardless
> > of whether it is a legacy gadget or configfs-composed gadget. When the =
whole
> > gadget is unbound, composite_dev_cleanup() is called which zeroes cdev-
> > >next_string_id and frees all gadget strings containers.
> >=20
>=20
> Yes, you are right that the current mainline won't suffer this issue.
> But it will be needed if we want to implement similar features like andro=
id do.

once you have the features, then implement it. I don't want any unused
code here, specially since it won't be tested by anything.

> It will only remove config rather than whole gadget driver.

also, this is just wrong. You can't remove just one configuration, you
need to remove the whole thing and the host needs to see a
disconnection.

--=20
balbi

--twz1s1Hj1O0rHoT0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWnWlAAoJEIaOsuA1yqREmdoP/0+Fk2/Bxcw91ybFxvVhwTMp
FmaEJF0bsdhv990eArF9SNNPJlTtYa1EN7KqKEt/I0T1LumCfI3RBzyGTv5BOrpS
4Tmyw6nS8o5HNr8H655KOk2pqUQma6hpu+LQ0pWt4mBfFPfOq1pLc8EGqLU/eXSa
YsFQmGk+vRt3ejOyXiUb/qlJXCUdpKUYrYkEiXI6SWinGLtJLF3OY1XAEJqSZ0uG
jC2M2+9IGMjZ7jvFOOTQG0f0pjxIOKZJusQuXiKLisd9UCUMimOPtkQm97GA0YdV
JfzdubT4Ia85SedmPoIhCyUWL2n9N3LtJNVI06YlooJ9eX5iNQ2AiOVHLl1xmo4s
13C0eAKc47G/oCDIFJ8Nnt+OOi7KG1LzYSpX+2AVg60QlwhMiw4Mjle2VYeFOeD9
acfbuIH43ywbyjCFT02B82C/RKcelCaSleQqCTClkZvUDeP0sjIRGmTwMLHnWUa6
VOPDTleJHMUCeRns5p/R3FeCMq/XAsqM+ZVq7e5k+tOB+tsrTJfQesh2jqld8WdD
tqIt6gAZk6MRabZvCsl5l89NwEHlnNix/ZgwS5TT4/HObJEmXvtcpIo5mTtE8kdS
nInUBLnL+yHIu+Lv5fbzvk1hzpZcboFmyZ5HCUvwOo1j1patS9Dt4Zo3/1dmVxY8
Ug7/HFi4esr8xZ5ybJCB
=n6RB
-----END PGP SIGNATURE-----

--twz1s1Hj1O0rHoT0--
