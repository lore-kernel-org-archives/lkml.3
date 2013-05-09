Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095Ab3EIFNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:13:14 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:60256 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab3EIFNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:13:13 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: make stat/statfs 64-bit for x86_64 kernels
Date: Thu, 9 May 2013 01:13:17 -0400
User-Agent: KMail/1.13.7 (Linux/3.8.3; KDE/4.6.5; x86_64; ; )
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
References: <1368072057-7832-1-git-send-email-vapier@gentoo.org> <201305090008.47432.vapier@gentoo.org> <518B2387.9030408@zytor.com>
In-Reply-To: <518B2387.9030408@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1398220.7vBlpbbniJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201305090113.19684.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1398220.7vBlpbbniJ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thursday 09 May 2013 00:18:15 H. Peter Anvin wrote:
> On 05/08/2013 09:08 PM, Mike Frysinger wrote:
> > On Thursday 09 May 2013 00:04:03 H. Peter Anvin wrote:
> >> On 05/08/2013 09:00 PM, Mike Frysinger wrote:
> >>> When including these headers in the x32 ABI, the structs get
> >>> declared with 32bit sizes which is incorrect.  Use long long
> >>> and such to make it work both with x32 and x86_64.
> >>=20
> >> I'm not sure if it is okay to change the types, even within the
> >> same size.  Perhaps use __u64/__s64?
> >=20
> > sorry, i don't follow.  changing types isn't ok (unsigned long to
> > unsigned long long), but changing to __u64 is ok (unsigned long to
> > __u64 which is typedefed to unsigned long long) ?
> >=20
> > i don't have a problem using __u64/__s64, i just don't understand
> > your logic.
>=20
> In userspace, __u64 is often defined as "unsigned long" on 64 bits.

my tests would seem to indicate otherwise, at least for x86:
$ gcc -E - <<<"#include <linux/types.h>" | grep '__u64;'
__extension__ typedef unsigned long long __u64;

$ gcc -m32 -E - <<<"#include <linux/types.h>" | grep '__u64;'
__extension__ typedef unsigned long long __u64;

$ gcc -mx32 -E - <<<"#include <linux/types.h>" | grep '__u64;'
__extension__ typedef unsigned long long __u64;

and doing a printf("%i\n", sizeof(__u64)) shows 8 for each of the above bui=
lds
=2Dmike

--nextPart1398220.7vBlpbbniJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJRizBvAAoJEEFjO5/oN/WBuuUP/28x4Y9QhIwgKFN7skkvlWwd
vHfXSamL3l0YkRF4OFp5pG/yQB+XH1gZTZJepJUApE7fIlz09MWZzL3KcId/OnyT
rbjlOrbxhyjnlLcRmr2h7VLAmwTZwy/LBqfx/oJb3tTrztnhp95yYSXw1viZjdZZ
CY8vg458/0aoutkfY1LnGUHSyMSPsiyF55DUnGakDPecsgmirt168euYMoE08tjm
/bPc8ibXIC7XCht0MkvZHdmab1+4OMe8xyrOclVpb6uXtVYl2DV06GATlRX4PdJO
dDglrJ8okX0V/eSPivaHiJ8Jf8yVwmGMUqWixfomnsFbIoB1bfSBTDm9wwIsauny
gZkIeHpFODW64/6i5iEaK9fb4YOgj0G/B6VmnwLQznKL6ovutA5T/fni1DCsxHzg
JC4OzguL2DCdBjCyii7YT5pUoI4UUePBuWUtkWIbImLe0QDEfDFEqjeRtIq6SAH4
9QkkJcV04LnvheY2Dcl34hAIWkc1IEkVNxvnNN9inAZOSwAIJxlgdyKCdmoZGKpi
SZ2NON0tYMWGBKodcToGcwdto0Fo+IynwqN2rmYbXP1fR0iemx5+TRpRr/WSRhEr
4DINZASWkRb8wAGqIE6X1sjpmtsK71k7OKHu9ylymOqeOtLNx59iukUrQWvN0/dv
yWF+ytKIZ57FoBgzawXy
=uaDE
-----END PGP SIGNATURE-----

--nextPart1398220.7vBlpbbniJ--
