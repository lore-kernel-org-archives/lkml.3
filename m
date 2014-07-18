Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761027AbaGRJaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:30:08 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:46265 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756019AbaGRJaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:30:06 -0400
Message-ID: <53C8E90F.1010306@daenzer.net>
Date: Fri, 18 Jul 2014 18:29:51 +0900
From: =?windows-1252?Q?Michel_D=E4nzer?= <michel@daenzer.net>
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Random panic in load_balance() with 3.16-rc
References: <53C77BB8.6030804@daenzer.net> <20140717075820.GE19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140717075820.GE19379@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="MscwHF52i2lJBTMms9gFuFbHe3SMHcvgX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MscwHF52i2lJBTMms9gFuFbHe3SMHcvgX
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 17.07.2014 16:58, Peter Zijlstra wrote:
> On Thu, Jul 17, 2014 at 04:31:04PM +0900, Michel D=E4nzer wrote:
>>
>> I've been running into the panic captured in the attached picture (hop=
e
>> it's legible) randomly while running 3.16-rc4 and -rc5. I haven't
>> noticed any pattern as to when it happens; at least once it happened
>> while the box was basically sitting idle.
>>
>> dmesg, .config and /proc/cpuinfo attached as well; let me know if you
>> need anything else.
>=20
> Does lkml.kernel.org/r/20140716145546.GA6922@wolff.to cure things?

Yes, adding back

               cpumask_clear(sched_group_cpus(sg));

seems to do the trick, thanks.

There's a long weekend coming up for me, but after that I'll be happy to
test any better fix you guys come up with.


--=20
Earthling Michel D=E4nzer            |                  http://www.amd.co=
m
Libre software enthusiast          |                Mesa and X developer


--MscwHF52i2lJBTMms9gFuFbHe3SMHcvgX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iD8DBQFTyOkQWoGvjmrbsgARAtV4AJ0bi40Kiii2x+MLXTZLLA6j6w38IQCff0sC
G2nvJTdOx5Nwz5eGftRfins=
=cywA
-----END PGP SIGNATURE-----

--MscwHF52i2lJBTMms9gFuFbHe3SMHcvgX--
