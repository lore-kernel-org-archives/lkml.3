Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbaF0ViB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 17:38:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46105 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaF0Vh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 17:37:58 -0400
Message-ID: <53ADE430.6020209@wwwdotorg.org>
Date: Fri, 27 Jun 2014 15:37:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        Joerg Roedel <joro@8bytes.org>, Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        devicetree@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 04/10] memory: Add Tegra124 memory controller support
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com> <1403815790-8548-5-git-send-email-thierry.reding@gmail.com> <9283417.yKmnrljUYI@wuerfel> <20140627111514.GE2797@ulmo>
In-Reply-To: <20140627111514.GE2797@ulmo>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="TbSh8CbnGl4I5cbR7oiQW815JJmtWRwJv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TbSh8CbnGl4I5cbR7oiQW815JJmtWRwJv
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/27/2014 05:15 AM, Thierry Reding wrote:
> On Fri, Jun 27, 2014 at 01:07:04PM +0200, Arnd Bergmann wrote:
>> On Thursday 26 June 2014 22:49:44 Thierry Reding wrote:
>>> +static const struct tegra_mc_client tegra124_mc_clients[] =3D {
>>> +       {
>>> +               .id =3D 0x01,
>>> +               .name =3D "display0a",
>>> +               .swgroup =3D TEGRA_SWGROUP_DC,
>>> +               .smmu =3D {
>>> +                       .reg =3D 0x228,
>>> +                       .bit =3D 1,
>>> +               },
>>> +               .latency =3D {
>>> +                       .reg =3D 0x2e8,
>>> +                       .shift =3D 0,
>>> +                       .mask =3D 0xff,
>>> +                       .def =3D 0xc2,
>>> +               },
>>> +       }, {
>>
>> This is a rather long table that I assume would need to get duplicated=

>> and modified for each specific SoC. Have you considered to put the inf=
ormation
>> into DT instead, as auxiliary data in the iommu specifier as provided =
by
>> the device?
>=20
> Most of this data really is register information and I don't think that=

> belongs in DT.

I agree. I think it's quite inappropriate to put information into DT
that could simply be put into a table in the driver. If the information
is put into DT, you have to define a fixed binding for it, munge the
table and data representation to fit DT's much less flexible (than C
structs/arrays) syntax, write a whole bunch of code to parse it back out
(at probably not do a good job with error-checking), all only to end up
with exactly the same C structs in the driver at the end of the process.
Oh, and if multiple SoCs use the same data values, you have to duplicate
those tables into at least the DTBs if not in the .dts files, whereas
with C you can just point at the same struct.

SoCs come out much less frequently than new boards (perhaps ignoring the
fact that we support a small subset of boards in mainline, so the
frequency isn't too dissimilar there). It makes good sense to put
board-to-board differences in DT, but I see little point in putting
static SoC information into DT.


--TbSh8CbnGl4I5cbR7oiQW815JJmtWRwJv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTreQwAAoJEJuNpwkmVCGc3xMP/jasqeisefLXjClmATi81K7C
HVR3B3q8CCg8m5Bu0MfW8w5Y5IuuEzfQce3KxYuAnFthO+C9BMZC69SB5dSc+5r9
f6l1cLqhE/WvM9OCnn72Yn1fe3GU/qOB4EAnT7UcBBTProTSraQPJfXUqzoIlFI+
Yi5oToZ7AQCuuC11PmxWW10XP+9JQYGdYbZT6DX1bzgmKF8o/qnxnfesEDGbCYMk
gEy/9gSKJ70qbO9F+sb0ca6asVQSJtJF5HzoosgkX1g21rTw9ehsNCJB0tnrakQA
kMyMMk3tjY362lsHf4FtJJb2hnZ2c2jSdnrA9L4XrqYwpB4euA/jTsOlUTq0o6BN
r/YT+f3Cnj+4viZiSGEmCmMoZN1LfoAsUQqOueRTKH24pLuzfOKKiKogy9w3Wb8C
zFust1l9qSpzp1rdz6qZKxyfNwNxciiyW5fkfIP2DLRflma+4sQCdW8IPRbN/rbW
2ItJUZruiiDguufYyyuvegrabZ/usj9yaNcyVTLJ1hf/+q5JIKMasIFl8p30DlA2
TLVJm5Lxc76eCkqHxMQL4AfNdTMrUsigTZDYQew7hdhU42C1UR005w6p8dVVw0i2
1A2aXvFNSQ/00xksLsiuryOEHG6kWKsEnY/LV3x3LY7gYO/CaDnFCr9B9LCMUdWn
LqdFpAb6wacRAxAuZRuD
=P+UN
-----END PGP SIGNATURE-----

--TbSh8CbnGl4I5cbR7oiQW815JJmtWRwJv--
