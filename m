Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbaJ3NoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:44:20 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43721 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759610AbaJ3NoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:44:04 -0400
Date: Thu, 30 Oct 2014 14:43:57 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: Re: I2C OF IRQ parsing issue due to probe ordering
Message-ID: <20141030134354.GA19802@ulmo.nvidia.com>
References: <2287003.09eTeKUr1V@avalon>
 <1441244.9DO8HMds24@avalon>
 <20141030132136.GA23852@katana>
 <2020186.tp9cWKgsNl@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <2020186.tp9cWKgsNl@avalon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 03:22:49PM +0200, Laurent Pinchart wrote:
> Hi Wolfram,
>=20
> On Thursday 30 October 2014 14:21:36 Wolfram Sang wrote:
> > > > See:
> > > > 	9ec36cafe43b of/irq: do irq resolution in platform_get_irq
> > > >=20
> > > > I suspect a similar thing could be done for I2C.
> > >=20
> > > That could work. We would need to introduce a new i2c_get_irq() funct=
ion
> > > though. Wolfram, would you be fine with that ?
> >=20
> > I'd think it will look pretty similar to platform_get_irq, no? That is
> > fine with me.
>=20
> It would, but as Thierry pointed out it should be possible to hide the de=
tails=20
> in the I2C core. I'll submit a patch shortly.

i2c_device_probe() seems exactly the right place to do this. It's in
fact the equivalent of what I had proposed in my original patch series
where this was done in platform_drv_probe().

Thierry

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUUkCaAAoJEN0jrNd/PrOhzgwQAILjAvOl6g5yQSNdJy/NBxT7
/w02zO5QzMWsWlQropceIhAQ6g/pO3ULs+HmrpKanmi1xjKsXubNos835uR8bpDS
gxP4YHOZ5V8WKNvU0yFHZ2nQSiw0FG3nCTY1TkUza0EykNZjNuAAOVIzZKcFbKY1
lrdEVU3KvwWup15NhfFH4HAZDZioRxuwhGszHzQI0om8II6+VCpxQXc5z+Fv2ZLs
5uRHGEQvr0ZLCoY9g8oetsqBei+8cpPyz1SvyyFKHPqfkplylU0fcXKS1lWZ2epm
LYdFl13MN5ytZWbH0A/p1oXlDvEy16zL+QgVVFYB+u0J+G5p16aRK8CoBobajKul
t//PRiXkEvaPL56gDhdUGeALmFJo0U7QKZ3dg+s5g9JTSCrSauEBp6C37kICvZ/B
7ZAXnfI4a8xiSBTLccwRF44Xabiw28vMQiV/hwnRg78NZ/0XtuCeqqMZ1Ggu1g4o
EMhcLpAOOQzL3yhMSSRZG8+p6rQOp49k1Tc6/cu1w40PIFadfcixQfLyvqmJ979k
yIapSbypR1Ueex4Ffwg9jAP0YB3+IrqjikUKtP24702M2Ui9nEQgk9s1NCj+pzup
AgmSGlcMWT6bmWBDu17DhK1+2Y1ICJy/G6Tu2JlErv1p0wPRVOlKZVhGOtc8/Npl
u8w4e7dxvcKtuU6rD+Bs
=BuxV
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
