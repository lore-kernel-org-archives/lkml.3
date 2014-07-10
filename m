Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaGJPKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:10:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56899 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750945AbaGJPKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:10:06 -0400
Date: Thu, 10 Jul 2014 17:09:45 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: a case for a common efuse API?
Message-ID: <20140710150945.GF27469@lukather>
References: <53BC4DD7.20906@codeaurora.org>
 <20140709083509.GQ13423@lukather>
 <53BDD0F3.7040906@codeaurora.org>
 <20140710142616.GD27469@lukather>
 <53BEB443.9000606@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l+goss899txtYvYf"
Content-Disposition: inline
In-Reply-To: <53BEB443.9000606@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l+goss899txtYvYf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 10, 2014 at 06:41:55PM +0300, Grygorii Strashko wrote:
> On 07/10/2014 05:26 PM, Maxime Ripard wrote:
> >On Wed, Jul 09, 2014 at 04:32:03PM -0700, Stephen Boyd wrote:
> >>On 07/09/14 01:35, Maxime Ripard wrote:
> >>>Hi Stephen,
> >>>
> >>>On Tue, Jul 08, 2014 at 01:00:23PM -0700, Stephen Boyd wrote:
> >>>>Hi,
> >>>>
> >>>>On MSM chips we have some efuses (called qfprom) where we store things
> >>>>like calibration data, speed bins, etc. We need to read out data from
> >>>>the efuses in various drivers like the cpufreq, thermal, etc. This
> >>>>essentially boils down to a bunch of readls on the efuse from a handf=
ul
> >>>>of different drivers. In devicetree this looks a little odd because
> >>>>these drivers end up having an extra reg property (or two) that points
> >>>>to a register in the efuse and some length, i.e you see this:
> >>>>
> >>>>	thermal-sensor@34000 {
> >>>>		compatible =3D "sensor";
> >>>>		reg =3D <0x34000 0x1000>, <0x10018 0xc>;
> >>>>		reg-names =3D "sensor", "efuse_calib";
> >>>>	}
> >>>>
> >>>>
> >>>>I imagine in DT we want something more like this:
> >>>>
> >>>>	efuse: efuse@10000 {
> >>>>		compatible =3D "efuse";
> >>>>		reg =3D <0x10000 0x1000>;
> >>>>	}
> >>>>
> >>>>	thermal-sensor@34000 {
> >>>>		compatible =3D "sensor";
> >>>>		reg =3D <0x34000 0x1000>;
> >>>>		efuse =3D <&efuse 0x18>;
> >>>>	}
>=20
> Why don't use "syscon" framework for your needs? (mfd/syscon.c)

Because syscon is restricted to MMIO, and not really meant to be used
for this.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--l+goss899txtYvYf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTvqy5AAoJEBx+YmzsjxAg9FEP/AzTKdqhMRjA29BuXRb3H+w4
faFCHslPItZ4KDb84Wy+UT3SI7DTTzg+oUFH4csXHUhm4xWEGcKstOQA/c3SULgC
CBAnFlqLRdExiKticYxmtjnqI1K70DwnkjH/Lts9ICdHqaOhvwcs77C5dc46jsAs
sKd15NAAvFTXidNwtU37iOR2ZY3DiWJfAcpSeUa1TtK+GzSMskTxX8Tnm0q97hFG
MgHjDLCXsHbM2t1en5zCCAgJ5GXw9p3B2urweEvQW/bzc1ybTxp/mfvHLIvM93vF
K9ie02+ErG3ML4K80Ts/OXbskNa2Q4GT7CPIleHC2Ic/urfsJrsWv7cJpCUXU29S
wuPSHfGdbtfIgbsTpIrF/TzqKEFmcoLTqHdS2umhrweAg9l/lnLiL8Ffk56wbbD5
oUlpwJtB8vKCEwTvbv82hJKHyq0bmgjiiD7md6XbsgjDhMtzVCziJOBndHozVbEM
m7cm396lA9L38pRiBCYuPxwqnDO83McyZERtZDognUh3eH4aLCkqA1EQQxYBGyvG
hiX6LqjSx1HvnvLtFMgq5GXDzfmk0fXnptxwm4TQgrUqWR6X2yHzyw2aN15FO0Bi
mMuY13Fq1jyOKATZMxwIO9ZTNogWK5+vjLb2Ss/OrsEMPOEIDmXDBPc+i8MZs+OM
pQTmDg/2NFF6CohLfrX7
=BgiY
-----END PGP SIGNATURE-----

--l+goss899txtYvYf--
