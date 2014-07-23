Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbaGWDxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 23:53:31 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:49830 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756208AbaGWDx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 23:53:28 -0400
Message-ID: <53CF31AE.30403@daenzer.net>
Date: Wed, 23 Jul 2014 12:53:18 +0900
From: =?windows-1252?Q?Michel_D=E4nzer?= <michel@daenzer.net>
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
References: <53C77BB8.6030804@daenzer.net> <20140717075820.GE19379@twins.programming.kicks-ass.net> <53C8E90F.1010306@daenzer.net> <53CE00EF.70108@daenzer.net>
In-Reply-To: <53CE00EF.70108@daenzer.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="5FWoGmOBwGcQXcdIGTfGiPOhhsInrdSmC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5FWoGmOBwGcQXcdIGTfGiPOhhsInrdSmC
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 22.07.2014 15:13, Michel D=E4nzer wrote:
> On 18.07.2014 18:29, Michel D=E4nzer wrote:
>> On 17.07.2014 16:58, Peter Zijlstra wrote:
>>> On Thu, Jul 17, 2014 at 04:31:04PM +0900, Michel D=E4nzer wrote:
>>>>
>>>> I've been running into the panic captured in the attached picture (h=
ope
>>>> it's legible) randomly while running 3.16-rc4 and -rc5. I haven't
>>>> noticed any pattern as to when it happens; at least once it happened=

>>>> while the box was basically sitting idle.
>>>>
>>>> dmesg, .config and /proc/cpuinfo attached as well; let me know if yo=
u
>>>> need anything else.
>>>
>>> Does lkml.kernel.org/r/20140716145546.GA6922@wolff.to cure things?
>>
>> Yes, adding back
>>
>>                cpumask_clear(sched_group_cpus(sg));
>>
>> seems to do the trick, thanks.
>=20
> I'm afraid it happened again with 3.16-rc5 plus the above change. It
> seemed to last longer than before, but maybe that was just luck.
>=20
> Going to try 3.16-rc6 now.

Just happened again with the same change on top of 3.16-rc6.

Are there any other potential fixes yet?

I hope this problem is on the radar as a showstopper for 3.16.


--=20
Earthling Michel D=E4nzer            |                  http://www.amd.co=
m
Libre software enthusiast          |                Mesa and X developer


--5FWoGmOBwGcQXcdIGTfGiPOhhsInrdSmC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iD8DBQFTzzGvWoGvjmrbsgARArgiAJ4mzDSXFAD4x8t0MWsLmOAr95PYIQCgt9C6
J/pTEtVBKAczGPDOqcU0W0E=
=jVoQ
-----END PGP SIGNATURE-----

--5FWoGmOBwGcQXcdIGTfGiPOhhsInrdSmC--
