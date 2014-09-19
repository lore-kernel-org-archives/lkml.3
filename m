Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbaISX0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 19:26:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:16464 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbaISX0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 19:26:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,558,1406617200"; 
   d="asc'?scan'208";a="575959069"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH 7/7] sched: Silence nested-externs warnings
Thread-Topic: [PATCH 7/7] sched: Silence nested-externs warnings
Thread-Index: AQHP1B6e1FZqApYsAUeDZBBK/84gU5wJho6AgAAI0oA=
Date: Fri, 19 Sep 2014 23:26:28 +0000
Message-ID: <4950B4DF-F8A7-4978-B901-CB35EA1B1F5B@intel.com>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <1411140580-20909-8-git-send-email-jeffrey.t.kirsher@intel.com>
 <20140919225453.GJ2832@worktop.localdomain>
In-Reply-To: <20140919225453.GJ2832@worktop.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.17.5]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_D8662EEB-57AD-48EA-9B68-0FCF113D7C74";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_D8662EEB-57AD-48EA-9B68-0FCF113D7C74
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 19, 2014, at 3:54 PM, Peter Zijlstra <peterz@infradead.org> =
wrote:

> On Fri, Sep 19, 2014 at 08:29:40AM -0700, Jeff Kirsher wrote:
>> From: Mark Rustad <mark.d.rustad@intel.com>
>>=20
>> Use diagnostic control macros to ignore nested-externs warnings
>> in this case.
>>=20
>> CC: Ingo Molnar <mingo@redhat.com>
>> CC: Peter Zijlstra <peterz@infradead.org>
>> CC: Brian Norris <computersforpeace@gmail.com>
>> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> ---
>> include/linux/sched.h | 2 ++
>> 1 file changed, 2 insertions(+)
>>=20
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 5c2c885..ed52c76 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -832,7 +832,9 @@ static inline int sched_info_on(void)
>> #ifdef CONFIG_SCHEDSTATS
>> 	return 1;
>> #elif defined(CONFIG_TASK_DELAY_ACCT)
>> +	DIAG_PUSH DIAG_IGNORE(nested-externs)
>> 	extern int delayacct_on;
>> +	DIAG_POP
>> 	return delayacct_on;
>=20
> Who has this nested extern warn on in anycase?

They appear in W=3D2 builds, so you do have to ask for them.

> I've never seen it
> generate a warning. Also WTF is DIAG_PUSH/POP, its not a GCC thing
> afaict.

The first patch in the series adds macros to use the gcc/clang pragmas =
to control these things. Both compilers have the capability. The macros =
generate nothing for compilers that lack it.

In any case, this particular one will be resolved instead of silenced.

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_D8662EEB-57AD-48EA-9B68-0FCF113D7C74
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUHLujAAoJEDwO/+eO4+5umMUP/2SCVWRQgxC650JAl39EOOwG
xKkRgPQLvdjRqa0Oo8ZmmKkWB3l7UKXUALgQgsTlBxz3iA/Z5NlyQMgJr9lAC8t1
YCYtXhHTLTEXv/lHYcGFLqDylqCS75DzdERfRfq+NEv/tuFQ8OKfPdE9cfa0ASYi
jkURRvM+P0ibDa8J7z6fyPD7ydnx1CfX6rqIXzRU7k7TscyEORS5liLBikdNEPOd
4YZIfmYScfyAobdcQSaAVgiooJe95rIk3Qd3Sz+a8OonJnQ6Nv+8js3AV5hsUgrb
d5HI8rVew0hWNif8IopWIiYqsgl/rTp9oqbHjeUsoHJZVlGaroeJqMaNeVw4z2BA
Y23UkWz4CU1r8QsCsbbvH00jtmYX7v+FYYKXKEO6Qno+CxyufQkqI+VO+cJqyPZE
rNamL1p5yOlBP5z1/mg/ETn8NTUuFrIrcThzDePw1Vj967IXhBi9p3ayvFXvR5Y1
ZgI1gJxdHfCHmrd13oV1CKlb4TjQwH0cXhc36FN/rBuFSQaTm764oNCAHesvh0Bj
3JmhchkJ3AKk5P9r++ii0+gxRqXKJy1jFNYxanJtUnSWm7XVURKVKJygFY0aVZiY
Qynh55a8S7vcOCI/VIHJyqfibSATJRV7E26zyfZYe9lHDhYG9Z0KHkUmxDKuutXl
4P4P8KU5VrQnlLdGYYkS
=Wmh/
-----END PGP SIGNATURE-----

--Apple-Mail=_D8662EEB-57AD-48EA-9B68-0FCF113D7C74--
