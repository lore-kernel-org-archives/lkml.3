Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935844Ab3DHM3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:29:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44163 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935007Ab3DHM27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:28:59 -0400
Message-ID: <5162B7FF.7010603@canonical.com>
Date: Mon, 08 Apr 2013 14:28:47 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: x86/mm/pageattr: Code without effect?
References: <515E92CE.2000509@canonical.com> <20130405142104.GB29290@pd.tnic> <20130406145804.GJ3423@redhat.com> <20130406154751.GB3612@pd.tnic> <20130408115344.GA7513@gmail.com> <20130408115959.GB4395@pd.tnic>
In-Reply-To: <20130408115959.GB4395@pd.tnic>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig8DBCC990AE501458D21073D6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8DBCC990AE501458D21073D6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 08.04.2013 13:59, Borislav Petkov wrote:
> On Mon, Apr 08, 2013 at 01:53:44PM +0200, Ingo Molnar wrote:
>>
>> * Borislav Petkov <bp@alien8.de> wrote:
>>
>>>> have been the source of the confusion. Remove the noop initializatio=
n
>>>> accordingly.
>>>>
>>>> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
>>>
>>> Yeah, looks good to me. I've folded it into my pile of changes touchi=
ng this and=20
>>> there are no visible issues. [...]
>>
>> Logistics question: is this fix coming upstream-wards via your pile of=
 changes=20
>> anytime soon?
>=20
> Actually I was thinking Andrea would send it since it is his fix. And
> besides, my pile is still stinking. :-)
>=20
> AFAICT, the patch fixes a noop so the current code works anyway - IOW,
> it is basically a code correctness fix which doesn't have any other
> effect. What I mean by that is, no need to go in now for 3.9 and stable=
=2E
>=20
> Long story, short: best it would be, IMO, if Andrea would send it to
> you soonish but you apply it for 3.10 so that it sees a whole cycle of
> testing just in case - it is CPA code after all.

To me it would read as someone or something may use change page attribute=
 to set
PSE or GLOBAL (or any or the masked off bits from canon_pgprot) in an une=
xpected
way for a huge page as long as it is not split.
As Boris says, it has not happened as far as it is known. Probably even i=
f it
happens it is one of those "on the right day of week when the phase of th=
e moon
is right" errors...
To enforce the PSE bit here sounds reasonably right. And also apply
canon_pgprot, too. GLOBAL I don't know for sure.

By the way there is a usage of new_prot a bit down of try_preserve_large_=
page
which probably should be changed into req_prot, too. That was enforcing t=
he
canon_pgprot before the change. So that may be considered a regression to=
 before.

-Stefan
>=20
> Thanks.
>=20



--------------enig8DBCC990AE501458D21073D6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBCgAGBQJRYrf/AAoJEOhnXe7L7s6jHPMP/2aEmMFpiXx82WCQPrl6Sz3h
6ACADTSDcD3wbzEgGqAqBDP938tC4ACFXxMMXfUdlDQezIcKb5Q/ixg6XyPH6FJt
BZsNrw6n6nWBhJn7Ex8B0cyRO9SQM+UC28PX+kUah6sNSVIw6iqbPhfTjckwNwcp
ynABKRQKzMLWYGFY7uBz0yvvtcvv1oiuEc6srXVYPKCYpibv1Nfh+/LhGdGQzQU8
4wzvrOUWkAGKeQ5P7/xcOMA7mMCfYEgULDo2X8vUsD+V66UHTk62BVb+c2HrrSld
oJbC8y5R3pQPK2+NRfQFraCke7/KqB0am49EGdPFxLzSG9moGRIAzap4s+d4e3b2
poM45Q/g/3V0wd7DSlNGavzZvxox0ulw0tUwUDbL/ti8Ryn/nAeKDtsc/Aw+mDwl
HulsaiUiTwCYIzYLzDTG4iDPQ0cSXPcJMQZ4f/7b+2CQ5t26Nigj5ZB6gIQYcPYD
oncqnEOuhKNPo/D0B2wyxxwXEu/7L5JPYe782lhE+90SDdD5iUK7Hj5BNSs6V7Gx
qbgSxH2Rg/y/ShMN3tYFU05C3VYFt2Y17XoFKJIygtBAXC+flFuybm3A91AZ7jRX
J+n5SMtbhdCPY4fDEnGBr67wMJJdoMYTQuvirUkqTOskd9PI0YxOjxDO4J6xCB+j
tswIqkBUAt+MH1MPJI4Y
=VxOT
-----END PGP SIGNATURE-----

--------------enig8DBCC990AE501458D21073D6--
