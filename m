Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab3LWJHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 04:07:37 -0500
Received: from s3.neomailbox.net ([178.209.62.157]:30231 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3LWJHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 04:07:36 -0500
Message-ID: <52B7FD01.9080006@meshcoding.com>
Date: Mon, 23 Dec 2013 10:06:09 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Ding Tianhong <dingtianhong@huawei.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        "David S. Miller" <davem@davemloft.net>,
        b.a.t.m.a.n@lists.open-mesh.org, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/21] batman-adv: slight optimization of addr compare
References: <52B7C5C5.2050304@huawei.com> <52B7F853.8050806@meshcoding.com> <1387789163.22671.62.camel@joe-AO722>
In-Reply-To: <1387789163.22671.62.camel@joe-AO722>
X-Enigmail-Version: 1.6
OpenPGP: id=43FD7307
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UrOqT5uE10Nd8lfvCtatB3Qf56c8b66We"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UrOqT5uE10Nd8lfvCtatB3Qf56c8b66We
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 23/12/13 09:59, Joe Perches wrote:
> On Mon, 2013-12-23 at 09:46 +0100, Antonio Quartulli wrote:
>> On 23/12/13 06:10, Ding Tianhong wrote:
>>
>> [...]
>>
>>> --- a/net/batman-adv/originator.c
>>> +++ b/net/batman-adv/originator.c
>>> @@ -41,7 +41,7 @@ int batadv_compare_orig(const struct hlist_node *no=
de, const void *data2)
>>>  	const void *data1 =3D container_of(node, struct batadv_orig_node,
>>>  					 hash_entry);
>>> =20
>>> -	return (memcmp(data1, data2, ETH_ALEN) =3D=3D 0 ? 1 : 0);
>>> +	return ether_addr_equal_unaligned(data1, data2) ? 1 : 0;
>>
>> ether_addr_equal_unaligned() returns a bool value which is implicitly
>> converted to 1 or 0: there is no need for the ternary if anymore.
>=20
> Should these use batadv_compare_eth?
>=20

That makes sense.

I was wondering whether we should get rid of batadv_compare_eth() at all
and always use ether_addr_equal_unaligned(). The "unaligned explanation"
is part of the name, so there is no need to use a commented helper anymor=
e.

However, until that moment it is better to get stuck to
batadv_compare_eth().


Ding, can you also follow Joe's suggestion for this patch please?


Thanks,


--=20
Antonio Quartulli


--UrOqT5uE10Nd8lfvCtatB3Qf56c8b66We
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSt/0FAAoJEEKTMo6mOh1VaVEP/0PGkACnAF0LGFxzG8ekri8p
w7Lzvf/FYRuygr5EPhIR5AuCrkUTvQjg0KMJzCDd7pzZIDrLP/KDYeLrWcQJtho/
2x6qNSEibnOCMXILp+G6fg6gv9w7jrGpA7/R1srEVieWg34eYweTwJcZDhsxHolz
lm+FwJeOtyCbsElc6U0xqKL4LIO2RO5k4dk7qB6CLaiznHMFhQrY26tpTKOgoJZf
EndaYw8dcbSQcKdX4THnZyVuLdg/xkitNDLJPmQswR3IO9fwVHGdgJY8qPBz34vR
YKpT0bbWHX0roOI27T/lNSep/0oYkpLoZKsaEDQq03bOl3rP1rEZG+LHJANj7ZlY
s6F6DkjZlLdC6fjVLYEcEjsWXBLSg5iMgZk4gpZlWBOfvVDsDPXzIgAG6Sn4uyUc
eFhutbpHnzyGscsb3rE8z0PcUD9KJrleJSycDDQl3pDo2pgKhmB1vKosGn6euUWr
5cL56xpKkjSmAO2wvT9Qyq6i3lWW/oCWIVubhxOxtIvZjW8EA/zI44XRYK8woL+1
3rclpZefB1QVswhtMjopDDkGShLpCzsCsgsnN21KB224ld1pBTznJVZp3TNRdwpb
Q+t3oYjp7Tu0Q6jpTBFpGk4r+xU05eIIPY08PHM4dwC9ElXsczqdSg76m3OkKGvc
JpFglcfoNsnKDvFcuuAo
=O7kh
-----END PGP SIGNATURE-----

--UrOqT5uE10Nd8lfvCtatB3Qf56c8b66We--
