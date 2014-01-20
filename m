Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaATL24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:28:56 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55346 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbaATL2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:28:53 -0500
Message-ID: <52DD0869.10803@imgtec.com>
Date: Mon, 20 Jan 2014 11:28:41 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Antonio Quartulli <antonio@meshcoding.com>
CC: Chen Gang <gang.chen.5i5j@gmail.com>, David Miller <davem@davemloft.net>,
        <mareklindner@neomailbox.ch>, <sw@simonwunderlich.de>,
        <b.a.t.m.a.n@lists.open-mesh.org>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-metag@vger.kernel.org>
Subject: Re: [PATCH linux-next] net: batman-adv: use "__packed __aligned(2)"
 for each structure instead of "__packed(2)" region
References: <52DA65F4.5070501@gmail.com> <52DA7B9E.4040202@meshcoding.com> <4915262.qEFumRrH4p@radagast> <52DB9B39.9090502@meshcoding.com>
In-Reply-To: <52DB9B39.9090502@meshcoding.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="7Io76bbmjhjPP46d6rdkmNvaLnFt81GA6"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2014_01_20_11_28_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7Io76bbmjhjPP46d6rdkmNvaLnFt81GA6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Antonio,

On 19/01/14 09:30, Antonio Quartulli wrote:
> On 19/01/14 02:10, James Hogan wrote:
>> It appears that the following gcc patch adds support for #pragma pack:=

>> http://gcc.gnu.org/ml/gcc-patches/2006-10/msg01115.html
>>
>> I gave it a quick spin on metag gcc (which is unfortunately stuck on a=
n old=20
>> version) and it seems to fix my simple test case so that #pragma pack(=
2)=20
>> becomes equivalent to __packed __aligned(2) (for sizeof and __alignof_=
_).
>>
>=20
> Then I personally think that it is better to fix metag gcc instead of
> changing the kernel.

Indeed it makes sense to patch metag gcc to be safe in the presence of
unportable code like this.

> Actually there are many different spots where "#pragma pack" is used.
> batman-adv is just the only one having compile time checks for structur=
e
> sizes.

Well the only vaguely interesting one I can find outside of drivers is
in fs/udf, and even that seems specific to CD-ROMs and DVDs.

If you care about portability then Chen's patch looks reasonable to me.

Cheers
James


--7Io76bbmjhjPP46d6rdkmNvaLnFt81GA6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJS3QhxAAoJEKHZs+irPybf8XUQALMq71nsIxtg+4blW6SX3b4D
/5+lIHezcn7fExlExW4LjnjJb3t1jfYNZGeAW6Ek9Y58EyXHmloPfytkJ+BM2saB
WTzRTGn0uKlxAITVvR52QH2pZp6mS/5J0hcVaABf/hq85iq+sSKjtveMiopdJKoY
vUr4hRdQH01r7nOVsM9hTJZKMxXmAvcr1tTaKv65pZD78GWvXSws+oscUqdSe8uw
koHAO0hroC8HYT5ZGthpIXFL4/WT3c0CyRvR2oFPdO0OB/zEj2X4RtkitBHL6B+Y
ps/66uTU/zkljqtQ7lxujGdZ4iFL65GmkFoHiTnEt2ulWneMt5FI3KWG1kMC9+rI
9QRFbpJauo93Gw/xzFBL3rQvRY+WWhh3gWiSJ+tL2Q9eNmjwCJfKRmIVXArVugSJ
a6s1lMhA8Wabk0mVx2tfFyKoB5kSymzNunDjjslo40jlTWyHIMtBGZeHw4/KLGzA
sX+zlv2bjWfkrXhIYctorbybQslbc8lXPtcZVdaQcZCO+r0eT66wIxOXoFNSzBh8
HY7T68URxz3Wm4bdbkExk9dZqyK2Db6ejEcApHUn1TOpscoeWWwtpyd2xM+6j1eR
+FVcujHzl3ReYA7RyQfnR3xkVUHkONfQzkrxSeNuvE1bdrY8qcz3dBjJlLC+GMhA
TWxGDvU610FPo7Dx85qo
=dYNL
-----END PGP SIGNATURE-----

--7Io76bbmjhjPP46d6rdkmNvaLnFt81GA6--

