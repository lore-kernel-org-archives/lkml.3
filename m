Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaISI7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 04:59:43 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:65221 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbaISI7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 04:59:40 -0400
Content-Type: multipart/signed; boundary="Apple-Mail=_AB4697D7-C41F-4E2C-826C-7A4B8A48299B"; protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [RESEND PATCH 1/3] x86: Adding structs to reflect cpuid fields
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20140919075814.GA30491@nazgul.tnic>
Date: Fri, 19 Sep 2014 11:59:32 +0300
Cc: Paolo Bonzini <pbonzini@redhat.com>, Nadav Amit <namit@cs.technion.ac.il>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>, kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-Id: <4C4860C1-50A7-44F0-80DC-BF199B3B0827@gmail.com>
References: <20140917124501.GC5358@nazgul.tnic> <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il> <1410958454-7501-2-git-send-email-namit@cs.technion.ac.il> <20140917132141.GD5358@nazgul.tnic> <CAKLkAJ5wYuDL+96RcRwxi7xD1iAK8_oug1zC_niipV-ToCUu=A@mail.gmail.com> <20140917140601.GE5358@nazgul.tnic> <541AD8F3.5010700@redhat.com> <20140918132635.GB27008@nazgul.tnic> <541ADFEB.6030801@redhat.com> <20140919075814.GA30491@nazgul.tnic>
To: Borislav Petkov <bp@alien8.de>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_AB4697D7-C41F-4E2C-826C-7A4B8A48299B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On Sep 19, 2014, at 10:58 AM, Borislav Petkov <bp@alien8.de> wrote:

> On Thu, Sep 18, 2014 at 03:36:43PM +0200, Paolo Bonzini wrote:
>> We're talking about the case where the field is not reserved anymore =
and
>> we _know_ that the vendor has just decided to grow the bitfield that
>> precedes it.
>=20
> We're talking about the case where you assumed that a reserved bit is =
0
> which is an unsafe assumption, the least.
>=20
>> As soon as we know that the field is not reserved anymore, we
>> obviously rely on reserved bits being zero in older processors, and =
in
>> future processors from other vendors.
>=20
> Again, this is an unsafe assumption.
>=20
>> The trivial example is feature bits like XSAVE. We query them all the
>> time without checking the family when they were first introduced,
>> don't we?
>=20
> The feature bits would obviously be 0 if features are not supported.
>=20
> However, even there
>=20
> "16 - Reserved - Do not count on the value."
>=20
> I'm quoting Intel's CPUID doc 241618-037 from 2011 (there might be a
> newer one though), the CPUID(1).ECX description.

New fields which which replace reserved bits would be handled the same =
way with bitfields and bit masks.

As for the concern that CPUID fields would be extended into non-zero =
reserved bits - can someone point me to a single case that occurred in =
the last 20 years during which CPUID existed?=20

The closest thing I found was =93extended family id=94, but this field =
is separate than =93family id=94 and treated this way.=20

Nadav

--Apple-Mail=_AB4697D7-C41F-4E2C-826C-7A4B8A48299B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQEcBAEBCgAGBQJUG/B0AAoJEHlOP0Zr1lTYhz8H/Rj/ZSg2PgfOc1f87CUFVE6c
tInX76T0T8KviIVp3x4HBelhBGXeOAnyCUSVqEqxZRjZushnBQJAO9wxlO86iVcz
z7w7eJHw+2kzoJRtasAYrBoL9JSc8kdgfo7glCtf8uEO5h8evfSW8bVJqv+hUNGZ
eICzdH/NJBb/pacnhD9mlQh43GBq7gl0XcylPvXaSgSr65+Sv560NxVNIklWXmCl
Oj93fieTRMgwNzGcf3ViVYisciTvy/eTHfVe+3vootQgRIU9XYV9zwMzHzJ1dqI2
Z7K8CRmp8YzqKR7gPzr+hjs25cxRx5kB6B63a2NTHJMx7WRkTIwiXeWxdvaeoyg=
=wstQ
-----END PGP SIGNATURE-----

--Apple-Mail=_AB4697D7-C41F-4E2C-826C-7A4B8A48299B--
