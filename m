Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab3E3NxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:53:05 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49929 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756669Ab3E3Nw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:52:58 -0400
Message-ID: <51A759A8.1040705@ti.com>
Date: Thu, 30 May 2013 09:52:40 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: keerthy <j-keerthy@ti.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <rui.zhang@intel.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 7/7] thermal: ti-soc-thermal: add DT example for DRA752
 chip
References: <1369840066-20357-1-git-send-email-eduardo.valentin@ti.com> <1369840066-20357-8-git-send-email-eduardo.valentin@ti.com> <51A71455.9000002@ti.com>
In-Reply-To: <51A71455.9000002@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2DOJICIONRFSMSMTKDJGQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2DOJICIONRFSMSMTKDJGQ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 30-05-2013 04:56, keerthy wrote:
> Hi Eduardo,
>=20
> On 05/29/2013 08:37 PM, Eduardo Valentin wrote:
>=20
>> Update documentation by adding an example for DRA752 on DT description=
=2E
>>
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: Rob Landley <rob@landley.net>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: J Keerthy <j-keerthy@ti.com>
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Cc: linux-doc@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt | 12 +++=
+++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/ti_soc_thermal.=
txt b/Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt
>> index 1629652..1953b33 100644
>> --- a/Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt
>> +++ b/Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt
>> @@ -59,3 +59,15 @@ bandgap {
>>  	compatible =3D "ti,omap5430-bandgap";
>>  	interrupts =3D <0 126 4>; /* talert */
>>  };
>> +
>> +DRA752:
>> +bandgap {
>> +	reg =3D <0x4a0021e0 0xc
>> +		0x4a00232c 0xc
>> +		0x4a002380 0x2c
>> +		0x4a0023C0 0x3c
>> +		0x4a002564 0x8
>> +		0x4a002574 0x50>;
>> +	compatible =3D "ti,dra752-bandgap";
>=20
>=20
> The general convention seems to be keeping it as dra7xx or dra7.
> Why add specific nodes like dra752? We can always reuse for
> forthcoming dra7 processors if the same address mapping and IP
> is retained right?
>=20
>>


In fact, I must agree with you that using a node such as dra752 is
restrictive. And I must also admit my original plan was to use dra7xx
naming convention. Not only on DT nodes, but in driver source code
symbols too. Well, this is about re-usability, right?

However, I took a step back and thought about the bandgap IP history.
Take that in mind, just look to the source code. We never succeed to
reuse nodes fully and it is because bandgap IPs do change from chip
version to chip version. That is also understandable as every chip has
its own thermal peculiarities. For instance, we do not have a omap4xxx
node because each OMAP4 chip has a different bandgap IP, with different
features.

I really would like to use a dra7xxx node, but that would contradict the
IP history :-). If we are trying to avoid patching the driver in the
future, I would say it is more likely to have a patch for another dra7
chip with specifics different from the current one than having a patch
reusing the existing dra752 node. This statement is obviously based on
driver and IP history (I might be wrong of course and the IP could
actually have reached a development stabilization point).

 +	interrupts =3D <0 126 4>; /* talert */
>=20
>=20
> The TRM does not have any term called talert. Can the comment
> be /* thermal_alert */ so it is easy to figure out what it is.
>=20


Indeed, TRM does not, in fact! But the TI thermal engineering community
have coined this term and I think it is quite common used (within that
community) and if you look to the driver code too, it is all over. I
believe there is no doubt that talert stands for thermal alert. The
driver code does have documentation about that.

>> +};
>=20
>=20
> Regards,
> Keerthy
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2DOJICIONRFSMSMTKDJGQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGnWagACgkQCXcVR3XQvP3yVAEApyBajpOt9VD2nqQiDYiRXwus
SAkUcaUOFmc9KHLW/vwBAInG6i1sGZzemg39P86zYKVfFhGJI+N3hxuWEED0MSQR
=L3SH
-----END PGP SIGNATURE-----

------enig2DOJICIONRFSMSMTKDJGQ--
