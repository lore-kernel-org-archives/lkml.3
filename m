Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbaENRKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:10:24 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44734 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbaENRKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:10:23 -0400
Message-ID: <5373A34B.1010008@oracle.com>
Date: Wed, 14 May 2014 13:09:31 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>
Subject: Re: perf: use after free in perf_remove_from_context
References: <5370EBE9.6@oracle.com> <20140514162943.GR30445@twins.programming.kicks-ass.net> <53739A9A.5010703@oracle.com> <20140514163535.GS30445@twins.programming.kicks-ass.net> <53739BF2.1030100@oracle.com> <20140514165205.GU30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140514165205.GU30445@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="j39oWk5B5K1nQHLH1pH1lTC7sQeqVCtB5"
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--j39oWk5B5K1nQHLH1pH1lTC7sQeqVCtB5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/14/2014 12:52 PM, Peter Zijlstra wrote:
> On Wed, May 14, 2014 at 12:38:10PM -0400, Sasha Levin wrote:
>> ./trinity -xinit_module -xreboot -xshutdown -xunshare -xnfsservctl -xc=
lock_nanosleep -xuselib -xumount -xmount -m --quiet --dangerous -C 400 -l=
 off
>>
>> Note that I run it as root in a disposable VM. Running that as root on=
 your
>> machine will likely kill it.
>=20
> Right, so i'll start with !root running. That said, I seem to get an
> endless stream of double free or corrupt msgs:
>=20
> trinity$ ./trinity -xinit_module -xreboot -xshutdown -xunshare -xnfsser=
vctl -xclock_nanosleep -xuselib -xumount -xmount -m --quiet  -C 400 -l of=
f
>=20
> ...
>=20
> *** Error in `./trinity': double free or corruption (top): 0x0000000001=
35af60 ***
> [main] Random reseed: 3671679404
> [main] Random reseed: 67838733
> *** Error in `./trinity': double free or corruption (top): 0x0000000001=
35ef60 ***
> [main] Random reseed: 943044433
> *** Error in `./trinity': double free or corruption (top): 0x0000000001=
2bb210 ***
> [main] Random reseed: 3627649145
> *** Error in `./trinity': double free or corruption (top): 0x0000000001=
39dbe0 ***
> [main] Random reseed: 935036390
> [main] Random reseed: 3922349807
> [main] Random reseed: 835563887
> *** Error in `./trinity': double free or corruption (top): 0x0000000001=
323890 ***
> [main] Random reseed: 974945617
> *** Error in `./trinity': double free or corruption (top): 0x0000000001=
308190 ***
> [main] Random reseed: 2912296953
> [main] Random reseed: 681900861
>=20
>=20
> Is this 'expected' behaviour?

I've talked about it with Dave a while ago, he said it happens because th=
e threads that
do all the testing sometimes corrupt themselves which result in that erro=
r. It shouldn't
be harmful as the thread will just get killed and a fresh one will be sta=
rted in it's
place.

Since then I set MALLOC_CHECK_=3D0 to avoid seeing that in my logs.

So yes, it's probably a good thing you're seeing that.


Thanks,
Sasha


--j39oWk5B5K1nQHLH1pH1lTC7sQeqVCtB5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTc6NUAAoJEN6mb/eXdyzcplYP/RCMM8uioeoQXcddSV2CaPXk
Z6iW77ef/+fhsChd0UPEXr9BUUuwuK4O2N92HS1v6jhob5NUUJxV+EacSpGeXjCt
EsVxpV37hwrF49aA+8WFczA/7x6bKtVWCpWssHNHspELaAag91iZ0YUXAFgLRApF
YYmBKEV7H3WjfrA9Tq74fOEb/XthoBZHzr9K0N3KIrnFrn7z8nvzOjOWG+vv0BHA
9Y7gGlMOWJYwqJLbYkcO7Sryc4Qru6eRrP0UkM9IeoLvGjxf6vA2+y+nyskgqqEK
KHtIPc4p32wbLU9hWImuRQ1xwY8Ft1vVlNWmlPh8EShTpURw5+99sg4jT7C1oGvR
LITALZHOtHL8osh/dTEoY1EYRez710YGMcdLw26xeE/AqwQeu1gWbCpoE9yTWxKb
f1sE0HvJKYGviDuYyqRUV8DAMbwYG6KNelZ8r+trZDmNmMgpEMwhlEktuHQrrURh
1tHFJrzMy832pUHQ/oZOS8SxxZZWAmbIlWPCX8brlmn/t964Za4OrDIBfZQ1OKgC
siilK3XApsQBWITtCiNDRQGhqHd/b+ClOS1yRDsscExtl0y6Ei3KZE54796bu4NZ
LOLMNagDrsSttT6AP8gfdVdrd9DZVueHJm9kvdWWNmTdkh7c5UjEDBsenLqJMiN6
woLr6k2YaIkY8yKYK0YD
=LB9H
-----END PGP SIGNATURE-----

--j39oWk5B5K1nQHLH1pH1lTC7sQeqVCtB5--
