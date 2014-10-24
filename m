Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbaJXWJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:09:52 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62219 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbaJXWJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:09:50 -0400
Content-Type: multipart/signed; boundary="Apple-Mail=_4A6F850E-F617-4B0B-AC35-84846C9C0AD1"; protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: drivers: random: Shift out-of-bounds in _mix_pool_bytes
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <CACT4Y+boMTKpTovCWYQa6baSAWjagCN=mwXBZGAjbobzG80oWA@mail.gmail.com>
Date: Fri, 24 Oct 2014 16:09:48 -0600
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Daniel Borkmann <dborkman@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        "x86@kernel.org" <x86@kernel.org>, linux-kbuild@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Message-Id: <2E512EF7-577C-43C2-AB95-30DC25AD059D@dilger.ca>
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com> <5444EBFA.5030103@samsung.com> <20141020124929.GA23177@thunk.org> <54451501.2070700@samsung.com> <5445179A.4080804@redhat.com> <20141020141635.GA4499@thunk.org> <20141024100108.GF12706@worktop.programming.kicks-ass.net> <544A52D7.6000202@oracle.com> <20141024134205.GB21513@worktop.programming.kicks-ass.net> <544A6A6B.3040602@oracle.com> <CACT4Y+boMTKpTovCWYQa6baSAWjagCN=mwXBZGAjbobzG80oWA@mail.gmail.com>
To: Dmitry Vyukov <dvyukov@google.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_4A6F850E-F617-4B0B-AC35-84846C9C0AD1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 24, 2014, at 9:10 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Fri, Oct 24, 2014 at 7:04 PM, Sasha Levin <sasha.levin@oracle.com> =
wrote:
>> On 10/24/2014 09:42 AM, Peter Zijlstra wrote:
>>> On Fri, Oct 24, 2014 at 09:23:35AM -0400, Sasha Levin wrote:
>>>>=20
>>>> i >> 32 may happen to be "i", but is there anything that prevents =
the compiler from returning, let's say, 42?
>>>=20
>>> Not really, although gcc seems to opt for the 'sane' option and emit
>>> the instruction and let the arch figure out how to deal with it.=20
>>> Hence the 'fun' difference between x86 and ARM.
>>=20
>> It's interesting how many different views on undefined behaviour =
there are between kernel folks.=20
>>=20
>> Everything between Ted Ts'o saying that GCC can launch nethack on =
oversized shifts, to DaveM saying he will file a GCC bug if the
>> behaviour isn't sane w.r.t to memcpy().
>=20
> One of the benefits of fixing such issues (or not letting them into
> code in the first place) is just saving numerous hours of top-notch
> engineers spent on disputes like this.

By the principle of least surprise, I would expect "__u32 >> N", where
N >=3D 32 to return zero instead of random garbage.  For N < 32 it will
return progressively smaller numbers, until it has shifted away all of
the set bits, at which turn it will return 0.  For it suddenly to jump
up once N =3D 32 is used, is counter-intuitive.

Cheers, Andreas






--Apple-Mail=_4A6F850E-F617-4B0B-AC35-84846C9C0AD1
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVErOLHKl2rkXzB/gAQL33hAAhLXFsvUgT8yj0urOhjQBPvjv+cjeKSW0
inVwusTYnNkS4NOjgjyqztrb24ryiw7/fQJ1yCNwpiQN2TgKs736H4ErI7Y8CzXs
lTl/9AWWFX+FAa8zEmI1RhWW/nHjne0LWmXRIRRM5TWSm4cqOsBqNHMpGTIYScgQ
cAjji0uGV6D13t2MHf0InYDSTS+/MP7BXEr0TdZdD9/rATHWuDu6s4Rs5/WVe499
/+yaESaY/DuMLg403ex9deO49U6B4gZS13/+GUv9U2ww/HnWrz9tSJUkjqqoPXbz
RuzPrwq5/Uw05Zc2Xz8Scfq4OOIyj2ESeyWcJGL+JYVpcev0/DjtptbTVOyLHhM1
kFZJg4OxhAjwXd+Ah1A0qeqSjesIACOZ2EZy25jRdoq1EEfenr3yMIoht+uQX68F
xvIjPtSBH2AeZiZs1StIDinU6mLiYz0ktuPIcsH/wvpoFIQ0GWF3ujY/2kDYYCad
z0/wwADGSI/qFN1pbs+aZaIwi54MqaaioiwU6nzzDlOSAfvxq4WpcDsagMInvyWy
Qg+mvOzsTfwI4UXi4EgjglFbhkOUHGbOdPDIzeoJDdTywc5Qs3mmldd8kcxHppnd
gXgq7UzHQcj6lcUn8Wd/lUkzLcoWM1EHVoMFzHxpQ1Tl++QHhVFVc2nvX+3Pb5I0
qQ+JvvWr28Y=
=q7xg
-----END PGP SIGNATURE-----

--Apple-Mail=_4A6F850E-F617-4B0B-AC35-84846C9C0AD1--
