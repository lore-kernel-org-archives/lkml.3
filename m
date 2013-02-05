Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab3BEKdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:33:43 -0500
Received: from multi.imgtec.com ([194.200.65.239]:30661 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab3BEKdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:33:39 -0500
Message-ID: <5110DFEF.8000505@imgtec.com>
Date: Tue, 5 Feb 2013 10:33:19 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        <linux-kbuild@vger.kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Jonas <jonas.bonn@gmail.com>
Subject: Re: [PATCH 1/1] depmod: pass -P $CONFIG_SYMBOL_PREFIX
References: <1359625303-11842-1-git-send-email-james.hogan@imgtec.com> <201302030117.26295.vapier@gentoo.org>
In-Reply-To: <201302030117.26295.vapier@gentoo.org>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig8AF80F9161654CFAD145A4B6"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_05_10_33_27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig8AF80F9161654CFAD145A4B6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On 03/02/13 06:17, Mike Frysinger wrote:
> On Thursday 31 January 2013 04:41:43 James Hogan wrote:
>> --- a/Makefile
>> +++ b/Makefile
>>
>> +ifneq ($(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX)),)
>> +  depmod_args =3D -P $(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
>> +endif
>> ...
>>  # Run depmod only if we have System.map and depmod is executable
>>  quiet_cmd_depmod =3D DEPMOD  $(KERNELRELEASE)
>>        cmd_depmod =3D $(CONFIG_SHELL) $(srctree)/scripts/depmod.sh $(D=
EPMOD) \
>> -                   $(KERNELRELEASE)
>> +                   $(KERNELRELEASE) $(depmod_args)
>=20
> scripts/Makefile.lib just does:
> 	ifdef CONFIG_SYMBOL_PREFIX
> so you should do the same

arch/openrisc/Kconfig now defines SYMBOL_PREFIX as "", so this isn't
sufficient (arguably it probably shouldn't be defined empty like that?)

>=20
> that said, cmd_depmod is just a shell command.  and you're running anot=
her=20
> script helper (depmod.sh).  how about passing it unconditionally ?
> 	cmd_depmod =3D ... -P "$(CONFIG_SYMBOL_PREFIX)"
>=20
> since the default will be "no prefix", using -P "" is the same thing.

Yep, I could do this, but depmod.sh would need modifying to drop it if
the prefix is empty, otherwise you get the following from depmod:
FATAL: -P only takes a single char

I don't mind adding that, but what do you think?

>=20
>> --- a/scripts/depmod.sh
>> +++ b/scripts/depmod.sh
>>
>>  DEPMOD=3D$1
>> -KERNELRELEASE=3D$2
>> +shift
>> +KERNELRELEASE=3D$1
>> +shift
>=20
> you can do:
> 	DEPMOD=3D$1
> 	KERNELRELEASE=3D$2
> 	shift 2

neat, thanks

>=20
>> +# older versions of depmod don't support -P <symbol-prefix>
>> +# support was added in module-init-tools 3.13
>> +if test "$1" =3D "-P"; then
>> +	release=3D$("$DEPMOD" --version)
>> +	package=3D$(echo "$release" | cut -d' ' -f 1)
>> +	if test "$package" =3D "module-init-tools"; then
>> +		version=3D$(echo "$release" | cut -d' ' -f 2)
>> +		later=3D$({ echo "$version"; echo "3.13"; } | sort -V | tail -n 1)
>=20
> you could do instead:
> 	later=3D$(printf '%s\n' "$version" "3.13" | sort -V | tail -n 1)

yep, definitely better, thanks

>=20
>> +		if test "$later" !=3D "$version"; then
>> +			# module-init-tools < 3.13, drop the next 2 args
>> +			shift
>> +			shift
>> +		fi
>=20
> shift 2

ok

Thanks for the suggestions

Cheers
James


--------------enig8AF80F9161654CFAD145A4B6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJREN/2AAoJEKHZs+irPybfpVAQAJPWZzwxyhC9iNkpqkDmp4hB
hzWv8c2Bxe2C6cp3fhipwCTJ+tkdYVvSE+JcBM1P7uO5PIvdpo1U4P7+CgKIZn3K
tRHbZZv3lEeU/gZr1kb7x7Urue1kU3dQk1AZegIPEXwbLZHdpKiT17TXKzuf8XzE
Z2IrJfV/pN8QFScN2mbCq/ZuP8nC+R3YoD5vrP+seaeR/+z5h9L9Zkzk9ywkV/bN
hlC/6cTf5yOrvB3aHJL6XpZt6K+MPFT/TdLlaKC4PZAdYLinu3m8rUfC0nqSUvY8
NHK9GKgV75Or+PUBBliUmOYH0pGZ12rhHS+iVrSgO9Dv7sRbJ7d6eBD8GT0012vm
lglI0OBc3bdsUKu7KU/8p27KmYJt4KjezwafqcJRBjOO3WONCyLNog9s3ykmHD18
lZWLiu10MWZCz6ETxBFheibB8qwxTaX2OyLkIa21vpKiWeZsk52kB/PwQCsiZuTW
U9MfQTPQ9BoeShETv7TzM0Ui5Bcix0wUqKr6AtDOV0aRYJEfumkbVjDKv0Tur0Z5
qrs89ixyDn6HAzejMUDR/9j/fjQAJh9m2rRlygXw5zpprsv36xV3GMr+APTut4Up
5mjBv5C9zWguDfgWxh3EG/67GpKWsJB0R8nIStJMNFpHMIX2W+VF388atcqlS4dQ
z1ArrM8MIPTdGaguBjy5
=aE8K
-----END PGP SIGNATURE-----

--------------enig8AF80F9161654CFAD145A4B6--

