Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaIAL1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:27:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57011 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaIAL1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:27:03 -0400
Message-ID: <54045803.70705@monstr.eu>
Date: Mon, 01 Sep 2014 13:26:59 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] ARM: zynq: DT: Add Ethernet phys
References: <53F5D8D9.7040604@suse.de> <f166a186-301c-4288-97cf-71f8173c07e7@BN1AFFO11FD010.protection.gbl> <CAGVrzcYWN83tznwvw1M9V_mwWgobs2kwtRvEj4stqE=XGC10fg@mail.gmail.com> <20140825174610.GA13737@obsidianresearch.com> <53FB9AC4.8010704@gmail.com> <660fe929-1f16-4e22-8bd3-0388cd363978@BY2FFO11FD038.protection.gbl> <540099AF.4020005@suse.de> <e52ebd6c-2f0d-4ea9-a01f-882212956ace@BL2FFO11FD029.protection.gbl> <20140829173102.GA30917@obsidianresearch.com> <5400C53D.70501@gmail.com> <20140829232203.GA17664@obsidianresearch.com> <54011E31.8060409@gmail.com>
In-Reply-To: <54011E31.8060409@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="b115GkuvilLIJPvAOFSIChDD4dAxNlkw1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--b115GkuvilLIJPvAOFSIChDD4dAxNlkw1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/30/2014 02:43 AM, Florian Fainelli wrote:
> On 08/29/2014 04:22 PM, Jason Gunthorpe wrote:
>> On Fri, Aug 29, 2014 at 11:23:57AM -0700, Florian Fainelli wrote:
>>> On 08/29/2014 10:31 AM, Jason Gunthorpe wrote:
>>>> On Fri, Aug 29, 2014 at 08:35:36AM -0700, S=C3=B6ren Brinkmann wrote=
:
>>>>
>>>>> The compatible string is listed as optional property for PHYs. So, =
not
>>>>> having one is an option, I guess. But, I'd also prefer to at least =
keep
>>>>> the -c22 one, since I saw problems when I tried using -c45 (the Zed=
 phy
>>>>> should support it...).
>>>>
>>>> -c45 and -c22 use a completely different MDIO protocol, Zed doesn't
>>>> have a 10GE port, so it certainly doesn't use -c45.
>>>
>>> Most recent 1GbE PHYs should also implement clause 45. It is a nice
>>> improvement if you are using lot of transactions, otherwise clause 45=

>>> over clause 22 is suitable and supported by the PHY library (for EEE =
in
>>> particular).
>>
>> Oh, that is interesting, I haven't actually seen one of those yet..
>>
>> Hum. So that is messy, even if the Zed phy supports the C45 format,
>> the macb driver (and by my reading, the Zynq hardware) lacks the
>> capability to generate C45 frames.
>=20
> We should restrict ourselves to clause 45 over clause 22 compatibility
> mode, which requires no MDIO bus driver changes.
>=20
>>
>> It could be supported, but you'd have to use the GPIO bitbang MDIO
>> driver to talk to the phy.
>>
>> So... that makes the compatible string for the phy even more
>> confusing. 'Describe The HW' says it should have both c22 and c45
>> listed - however we don't have software support in Linux to negotiate
>> c22 and c45 support between the phy bus driver and attached phy :(
>=20
> Right now, if you set the c45 compatible string, the MDIO bus driver an=
d
> the PHY must support native c45 transactions to set phydev->is_c45, if
> one or the other, or neither of those work, we will fallback to c22.
>=20
> The part that is not figured out properly yet is how do we want to
> handle functions (e.g: EEE) that are only accessible using c45 (native
> or in compatible mode), since the PHY library uses two pairs of
> accessors, with the native accessors not falling back to the indirect
> accessor...

ok. I have read all responses listed here and still IMHO the best resolut=
ion
is not to add any compatible string.
I agree with Florian that we can have shorten boot time when idAAAA.BBBB =
is used
but also we are not checking that phy can be detect.

I believe all my points in my response are still valid and we have 3 opti=
ons.
1. not to add any compatible string and use autodetection
2. Add idAAAA.BBBB to shorten boot up time
3. Add c22
4. Add c22 and idAAAA.BBBB

My preference is 1. because there could be problem with MII setting
and autodetection is good proof that everything is working.
If any user wants to have short boot up time it can specify ID in DTS
and also I believe DTS will be much longer because of some IPs in PL.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--b115GkuvilLIJPvAOFSIChDD4dAxNlkw1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlQEWAMACgkQykllyylKDCEOlgCfepKdCxF79ho0IP1VA92Wk9sf
7PMAnA9/z39AyPFI/wZ9pin/XKkqo0Up
=EkEs
-----END PGP SIGNATURE-----

--b115GkuvilLIJPvAOFSIChDD4dAxNlkw1--
