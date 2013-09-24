Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab3IXSbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 14:31:08 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:37992 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3IXSbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 14:31:05 -0400
Date: Tue, 24 Sep 2013 20:31:00 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Manish Badarkhe <badarkhe.manish@gmail.com>,
        Darbha Sriharsha <dsriharsha@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [Patch V2] drivers: power: Add support for bq24735 charger
Message-ID: <20130924183100.GB9911@mithrandir>
References: <1379607514-11200-1-git-send-email-rklein@nvidia.com>
 <20130919202706.GB4470@ulmo>
 <523B6257.4040302@nvidia.com>
 <20130920075302.GB8575@ulmo>
 <5241D62E.1060705@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
In-Reply-To: <5241D62E.1060705@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 24, 2013 at 02:13:02PM -0400, Rhyland Klein wrote:
> On 9/20/2013 3:53 AM, Thierry Reding wrote:
> >>>> +     name =3D charger_device->pdata->name;
> >>>> +     if (!name) {
> >>>> +             name =3D kasprintf(GFP_KERNEL, "bq24735-%s",
> >>>> +                              dev_name(&client->dev));
> >>>
> >>> Won't the device name already include bq24735 because of the driver
> >>> name?
> >>
> >> In my experience this comes up with a name like "bq24735-5-0009". Thats
> >> why I added the bq24735 in the beginning, so the name is more descript=
ive.
> >=20
> > Yes, you're right. Perhaps in that case it's even easier to just stick
> > with a static string such as "bq24735" or "bq24735-charger". It's likely
> > to be the only device of that type in a machine. If you want to include
> > the device name, perhaps something like "%s/bq24735" (5-0009/bq24735) is
> > clearer that 5-0009 is actually the bus-specific name.
> >=20
>=20
> So it turns out if I try to put in a '/' or '\' they are translated to
> '!' in sysfs, so the name comes out to be '5-0009!bq24735'. Perhaps
> 'bq24735@5-0009' to still signify that the 5-009 is more of an address
> than chip name? What do you think Thierry?

I hadn't thought about that. @ looks like a better separator indeed.

Thierry

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQdpkAAoJEN0jrNd/PrOhdi8P/2exuCTEB2qONKPn0Ba077aP
LpSefJRWAAKzNzBtLp64nU7aGjlTU7emD+GHD5j/Z6+XAVSO+5cMQarx5z0wzaxD
pBWkIzlHcIXhryiiHAatkFutfVKLwIe34XLZa7E3OUDF98DPL8iPckXkqVlAL5bm
i0ejGws3dDESpwZIV2i3JCMgK8NRHEfMu9KkOShtqGMCSM3CfRinm1daGNYvN2BQ
Z6TBi06bAOl8AvgvjGM4Y3+uOMGl/18bBV9UQqzk19sAF4F4PhbugSUleMq85x7l
+zHNvvnqKMxql46sDP8XfuJcBCqHBhKPQGU+wV3MC76cooLZFxRYhV2rFW/XVM+P
FofVggNG/tyZlTMdKbuwWoCjUY2U378O1ayuwXjyd+WDOff75kBdUA7UFcXG5smj
ybFTduNurDMM22LDRvAxRIeHV3sX0lo/i5A6kG2/XFhKqq6ho7XmMGyHmAK6vlfd
PJ7MideVDdvoEmx8Dr+ctc1RLaQ3ZtFK1PksnxTLmPNxHFbf02PV7L3lrLnxspXa
v+kEm5WlryziNtbub7o3LvBO+9E1xOmLrgEXRtIA+BlcomMIiUl6MVioKlPak0LL
LOpMUvwsqrbilcB86yExcveZXZ0CKKPrEejgwge1pEN8DstMGgIftAewFrYLcP/M
OTlWKjcT+SHj+ZGoEIa3
=pnC3
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
