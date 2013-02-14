Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3BNHFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 02:05:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51709 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab3BNHFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 02:05:24 -0500
Date: Thu, 14 Feb 2013 08:05:20 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>, Andrew Murray <andrew.murray@arm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] of/pci: Provide support for parsing PCI DT ranges
 property
Message-ID: <20130214070520.GA29864@avionic-0098.mockup.avionic-design.de>
References: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de>
 <1360570940-17086-2-git-send-email-thierry.reding@avionic-design.de>
 <511949C7.7070604@gmail.com>
 <20130212064523.GA28850@avionic-0098.mockup.avionic-design.de>
 <511BA1E0.9000404@gmail.com>
 <20130213142521.GA6223@avionic-0098.mockup.avionic-design.de>
 <511BEF8D.7060506@gmail.com>
 <20130213212951.GA27849@avionic-0098.mockup.avionic-design.de>
 <20130213220956.DDEB43E3557@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20130213220956.DDEB43E3557@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:AGyEYUMy6Uu6zd17NoR8I2S723KYcdEPTyjbTDZ9JO3
 CQxPL7wMA19CgzbnV3Tyxv82j2wzLQodAIpTwFz5yzPb3kjRi1
 UXeWLqN4/+34epv+tJPR9hqKDva6gadX73rHdRk6s871vDXCzP
 Jss++AGkNUKoIfy7lkV9mwscXo4IX0FPOfsJZrCshmExo8htHg
 k0os87OlXDfQenxZSpiOAbr6dikg+N33xVo4L/ZH3r+00+Hyc2
 CwluwsVToHM79YpNGkToScPt9IQ0y1ss1D500zKFCyrat6gI+t
 +hwUM8sDUJ2Lt6ZH2OoLc4OZPmgLLZ0IS6EBpASQdnd9f7eO4g
 /APeZ9sLNJ1wleyZfDXneH5kzAqFd2KxRGj964LAlQUL9niOwo
 GVZBo8raIy9TV1hmo3v+7Kner6dOx72bnQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 13, 2013 at 10:09:56PM +0000, Grant Likely wrote:
> On Wed, 13 Feb 2013 22:29:51 +0100, Thierry Reding <thierry.reding@avioni=
c-design.de> wrote:
> > On Wed, Feb 13, 2013 at 01:54:53PM -0600, Rob Herring wrote:
> > > On 02/13/2013 08:25 AM, Thierry Reding wrote:
> > > > On Wed, Feb 13, 2013 at 08:23:28AM -0600, Rob Herring wrote:
> > > >> On 02/12/2013 12:45 AM, Thierry Reding wrote:
> > > >>> On Mon, Feb 11, 2013 at 01:43:03PM -0600, Rob Herring wrote:
> > > >>>> On 02/11/2013 02:22 AM, Thierry Reding wrote:
> > > >>>>> From: Andrew Murray <andrew.murray@arm.com>
> > > >>
> > > >>>>> @@ -13,6 +13,7 @@
> > > >>>>>  #define OF_CHECK_COUNTS(na, ns)	(OF_CHECK_ADDR_COUNT(na) && (n=
s) > 0)
> > > >>>>> =20
> > > >>>>>  static struct of_bus *of_match_bus(struct device_node *np);
> > > >>>>> +static struct of_bus *of_find_bus(const char *name);
> > > >>>>
> > > >>>> Can you move this function up to avoid the forward declaration.
> > > >>>
> > > >>> It needs to be defined after the of_busses structure, which is de=
fined
> > > >>> below the CONFIG_PCI block where of_pci_process_ranges() is defin=
ed. I'd
> > > >>> have to move that one as well and add another #ifdef CONFIG_PCI s=
ection.
> > > >>> If you prefer that I can do that.
> > > >>
> > > >> Okay, it's fine as is.
> > > >>
> > > >>>>> +static struct of_bus *of_find_bus(const char *name)
> > > >>>>> +{
> > > >>>>> +	unsigned int i;
> > > >>>>> +
> > > >>>>> +	for (i =3D 0; i < ARRAY_SIZE(of_busses); i++)
> > > >>>>> +		if (strcmp(name, of_busses[i].name) =3D=3D 0)
> > > >>>>                                               ^
> > > >>>> space needed.
> > > >>>
> > > >>> I don't understand. Do you want the space to go between '.' and "=
name"?
> > > >>
> > > >> Must have been some dirt on my screen... Never mind.
> > > >>
> > > >> I'll apply these for 3.9.
> > > >=20
> > > > Great, thanks!
> > >=20
> > > Grant vetoed merging. We need to see the other architectures using th=
ese
> > > functions rather than add yet another copy.
> >=20
> > I think I've said this before, but converting the other architectures
> > isn't very trivial, mostly because each has a specific way of storing
> > the values read from these properties.
>=20
> Sorry to be harsh, but this isn't new information. I've had to deal with
> the pain more than once before of copied infrastructure that at some
> time in the future needs to be merged again. Just looking at your patch
> I can tell that it is directly derived from the powerpc
> pci_process_bridge_OF_ranges() and which microblaze has already has a
> verbatum copy of.
>=20
> So, no, I'm not okay with it for v3.9. I don't want more copies of the
> same code. This doesn't block your v3.10 drivers. When a better patch is
> ready we can set up a separate branch with just the new functions in it
> and the various subsystems can merge that in if needed to resolve
> dependencies.
>=20
> Instead, here is what you do; you've got the bones of a good approach,
> but you need to show how it is derived from the powerpc approach. I'll
> reply in specifics to the patches themselves, but I can definitely see
> large blocks of code that can be moved out of powerpc & microblaze and
> into drivers/of/address.c without getting into the platform-specific
> PCI representations that you're concerned about.
>=20
> Now, to be clear here, I'm asking you to change powerpc/microblaze code,
> but I am *not asking you to test it*. This is a code move exercises, and
> I will help you with it if you need.

Alright. I have no idea about how this is going to affect the timeframe,
though. Granted, this doesn't sound as painful as I had assumed, but it
is quite a bit of work and I have to see how I can squeeze it in with
everything else.

Thierry

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRHIywAAoJEN0jrNd/PrOhapwP/2LSWjwhY1tgW7xQJHa/OSLv
1Sq/wck3WoO4hbzCt8ecnSQ3TkWORW/HdiVIyUVSS74KaVLl6hOzqVoJ/OiJm8EN
eo2Bk+KFI6MJEeTY4iQoTH4FgQLI68552y2QU21W7N8SJ0uxbjgoOcT9PDmZgVI5
s1+LBu8HPW0KVSmt8eN6y86fjcN4E1p7iqOvrm/FKOcH60NnHSD+UP3WR8EJF/cf
fRnOKvSa88tlP8bOkWtP/ZWwdSIe2VNwsEXA+DrHlpiF1hwfHgT1Y8G4CQfP6OrY
BKFyce2IBgQkzLEA8ca/hqcWC2nA27ZoEX7lplRvdO+51JNf1HV0++6gPn6Jt8QP
YHUMdMV4YsK8kvQ6/qKsvkrRVzgozqKbmn23B8uSZxzY3nexXzVhn6CS3imsYZlv
A5W+cU5peOdSD+nhjd0oj1Eem81frZ9YOIN2Kq8L1TEz8JxbgO+QWE+vbg84Oh6I
OZxIQ2JHdwsspOkfC0MKPa/m7m77I1A933SHFmsUO2EA4faZaDCewJpHZuPFJQhD
u8YV0wa+038hljaqoscpLWw+l8Ntj69vfSH4V0v+azmlMIBg5EorZ6xCkb82RsC0
1GaXrJrxT13o7ozNH6RJCtI7aO5pW6MQwgt/Oe9zILJRieE8+8JXsPUsm3cS/YSQ
FyvU2OhgrmvSOLLdjI/I
=aXpj
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
