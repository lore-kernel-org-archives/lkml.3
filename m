Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaIFPfB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 11:35:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbaIFPe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 11:34:58 -0400
Message-ID: <540B2997.4070600@suse.de>
Date: Sat, 06 Sep 2014 17:34:47 +0200
From: =?ISO-8859-1?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@debian.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Pavel Machek <pavel@ucw.cz>, Fabio Estevam <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <201409051338.40988@pali> <20140905134542.GD20164@leverpostej> <201409051552.05447@pali>
In-Reply-To: <201409051552.05447@pali>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="pE1X2JNxeomeJklGBf0ox1ttu1vrDnR1o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pE1X2JNxeomeJklGBf0ox1ttu1vrDnR1o
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 05.09.2014 15:52, schrieb Pali Roh=E1r:
> On Friday 05 September 2014 15:45:42 Mark Rutland wrote:
>> On Fri, Sep 05, 2014 at 12:38:40PM +0100, Pali Roh=E1r wrote:
>>> On Wednesday 18 June 2014 18:54:24 Pali Roh=E1r wrote:
>>>> Machine name from board description is some generic name
>>>> on DT kernel. DT provides machine name property which is
>>>> specific for board, so use it instead generic one when
>>>> possible.
>>>>
>>>> Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>
>>>> ---
>>>>
>>>>  arch/arm/kernel/setup.c |    7 +++++--
>>>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/arm/kernel/setup.c
>>>> b/arch/arm/kernel/setup.c index 8a16ee5..fbc7b4f 100644
>>>> --- a/arch/arm/kernel/setup.c
>>>> +++ b/arch/arm/kernel/setup.c
>>>> @@ -875,10 +875,13 @@ void __init setup_arch(char
>>>> **cmdline_p)
>>>>
>>>>  	setup_processor();
>>>>  	mdesc =3D setup_machine_fdt(__atags_pointer);
>>>>
>>>> -	if (!mdesc)
>>>> +	if (mdesc)
>>>> +		machine_name =3D of_flat_dt_get_machine_name();
>>>> +	else
>>>>
>>>>  		mdesc =3D setup_machine_tags(__atags_pointer,
>>>>
>>>> __machine_arch_type); machine_desc =3D mdesc;
>>>> -	machine_name =3D mdesc->name;
>>>> +	if (!machine_name)
>>>> +		machine_name =3D mdesc->name;
>>>>
>>>>  	if (mdesc->reboot_mode !=3D REBOOT_HARD)
>>>>  =09
>>>>  		reboot_mode =3D mdesc->reboot_mode;
>>>
>>> So, do you really want to break userspace which reading file
>>> /proc/cpuinfo (after migration from boardcode --> DT)?
>>
>> You have no guarantee model name in the DT =3D=3D the name in a
>> board file anyhow, and trying to force that is wrong. So
>> further to Russell's reply, I must NAK this from a DT
>> perspective.
>>
>> Realistically your userspace is already broken if relying on
>> such things. You built something that only ever worked for a
>> particular arbitrary string. So it was already broken for
>> every other board, and there was never any guarantee that new
>> boards where your userspace could have worked would share the
>> same name.
>>
>> You're trying to fix the wrong side of the equation.
>=20
> So what is your suggestion for identifing board (name/type) which=20
> will work with any kernel (and will not be broken again by kernel=20
> later)?

/proc/device-tree/compatible should give you a nul-separated list of
compatible strings for the machine. Ideally they're even documented
under Documentation/devicetree/bindings/arm/.

But as Mark said, depending on what you are actually trying to
distinguish in userspace, there may be better ways.

Regards,
Andreas

--=20
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6rffer; HRB 16746 AG N=FCrnbe=
rg


--pE1X2JNxeomeJklGBf0ox1ttu1vrDnR1o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUCymbAAoJEPou0S0+fgE/z0gP/j5Dkw6N1kus7YhrzDJW8PC8
cpWZSFyBi/lNH6eDWBcOZ9o1A789+7UbnTlMLopi7I9AHBRZ0gq+hrdptadNKVIu
TcMqkh9zCjen9wZhlkfdsBxLOsxgAf1CTkaVpjrqkhuX23fS+b34wurzOhItIMT5
z42Ku9oGnzfF5rZZmYCVAqOgjT9s50fzdhudk21RpVm0izw+kCZTBsnYCTPPc2dW
Nt8OeI5AMedT3kDNOJIDNYTnbJ5fnbeu4yv/Ozvbi2EIDxcujLkuPdakjA4HPvnQ
1sMv0RUsmrfvQnkdqoTG/R3zQQ8ruSFQtXlUmeWlHSLnsWYJxpNMcwDL1LgKj2pG
/kMPGxiJUHMrdJEq46bb5DdcJJ79hak+ZGKnaA12lK6+cHo/3GfdJRHPXmSBE6O+
ezJryafZFV20n5kUpw+RnCDtod6T9UcZd0IsT+9MAePMpIGB2UWrEYJo1qxAg2V6
c+VA4DTchdsMThsOCFt3Cfca9Ow+spaCd0f6wOJtj8Vn0C9nT2rheWGV7WpZ3iRq
qpnFok4n+Z+9oKwat9I0cLPcdxGMeaZMh27PUa9sbVsQ3jtIOoLcykfliw1be/Wt
71MH5OHpv3rz6ofxxryK2IorLX0Y75+N2zH4nItVerQB+uj/07Cf/m7g5GE0CmsA
WNlkdepW+P2zxActSz5s
=Zz7n
-----END PGP SIGNATURE-----

--pE1X2JNxeomeJklGBf0ox1ttu1vrDnR1o--
