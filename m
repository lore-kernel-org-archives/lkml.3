Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaCKIdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 04:33:13 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:42506 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaCKIdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 04:33:08 -0400
Message-ID: <531ECA33.8050803@monstr.eu>
Date: Tue, 11 Mar 2014 09:32:51 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        Punnaiah Choudary Kalluri 
	<punnaiah.choudary.kalluri@xilinx.com>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "kpc528@gmail.com" <kpc528@gmail.com>,
        "kalluripunnaiahchoudary@gmail.com" 
	<kalluripunnaiahchoudary@gmail.com>,
        "punnaia@xilinx.com" <punnaia@xilinx.com>
Subject: Re: [RFC PATCH] edac: zynq: Added EDAC support for zynq ddr ecc controller
References: <4adb2b4b-2ad6-42b9-929e-cc062f817245@TX2EHSMHS021.ehs.local> <20140310105655.GH14999@e106331-lin.cambridge.arm.com> <531DA900.5060202@monstr.eu> <fa35006e-055d-4ef2-9b65-a0f8cc6a0c8f@AM1EHSMHS016.ehs.local>
In-Reply-To: <fa35006e-055d-4ef2-9b65-a0f8cc6a0c8f@AM1EHSMHS016.ehs.local>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="3dbUwieR7F5EVM6DstcsT09KmBooOenbK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3dbUwieR7F5EVM6DstcsT09KmBooOenbK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 03/10/2014 11:32 PM, S=C3=B6ren Brinkmann wrote:
> On Mon, 2014-03-10 at 12:58PM +0100, Michal Simek wrote:
>> On 03/10/2014 11:56 AM, Mark Rutland wrote:
>>> On Sun, Mar 09, 2014 at 02:57:16AM +0000, Punnaiah Choudary Kalluri w=
rote:
>>>> Added EDAC support for reporting the ecc errors of zynq ddr controll=
er.
>>>> The ddr ecc controller corrects single bit errors and detects double=
 bit
>>>> errors
>>>>
>>>> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
>>>> ---
>>>>  .../devicetree/bindings/edac/zynq_edac.txt         |   18 +
>>>>  drivers/edac/Kconfig                               |    7 +
>>>>  drivers/edac/Makefile                              |    1 +
>>>>  drivers/edac/zynq_edac.c                           |  613 +++++++++=
+++++++++++
>>>>  4 files changed, 639 insertions(+), 0 deletions(-)
>>>>  create mode 100644 Documentation/devicetree/bindings/edac/zynq_edac=
=2Etxt
>>>>  create mode 100644 drivers/edac/zynq_edac.c
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/edac/zynq_edac.txt b/=
Documentation/devicetree/bindings/edac/zynq_edac.txt
>>>> new file mode 100644
>>>> index 0000000..c21ff83
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/edac/zynq_edac.txt
>>>> @@ -0,0 +1,18 @@
>>>> +Zynq EDAC driver, it does reports the DDR ECC single bit errors tha=
t are
>>>> +corrected and double bit ecc errors that are detected by the DDR EC=
C controller.
>>>> +ECC support for DDR is available in half-bus width(16 bit) configur=
ation only.
>>>> +
>>>> +Required properties:
>>>> +- compatible: Should be "xlnx,ps7-ddrc" or "xlnx,ps7-ddrc-1.00.a"
>>>
>>> Is this an or or a xor?
>>
>> Compatible string should be just xlnx,zynq-ddrc-1.00.a.
>> Nothing with ps7.
>=20
> Isn't this vendor IP? IMHO, this should be something completely
> different. Or if you want some Zynq-specific compat string it should
> refer to an actual version string associated with Zynq. 1.00.a is not,
> AFAIK.

I have checked with Punnaiah that this is Synopsys DDR memory controller.=

Zynq is based on 1.4 version with some customization.
It means I think reasonable solution is
call it drivers/edac/synopsys_edac.c
rename zynq_ in driver to synopsys_ and
use xlnx,zynq-ddrc-1.00.a compatible string because zynq is not using
clean synopsys version.

I am not getting point why you don't like 1.00.a suffix here.
Because of historical point of view compatible strings should be differen=
t
for early silicon, silicon v1, silicon v2, silicon v3, etc
but we haven't used it at all that's why we can use xilinx scheme
which we are using for our soft IPs.

Does it sound reasonable?

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--3dbUwieR7F5EVM6DstcsT09KmBooOenbK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMeyjMACgkQykllyylKDCGCdQCeK8CWXc9HZeiQMIsnQTtK2PyN
KkYAn01PI6POUb/yfXPn5iSvlSjdB1zs
=eOSS
-----END PGP SIGNATURE-----

--3dbUwieR7F5EVM6DstcsT09KmBooOenbK--
