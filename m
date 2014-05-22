Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaEVBlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 21:41:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaEVBlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 21:41:13 -0400
Date: Thu, 22 May 2014 11:41:02 +1000
From: NeilBrown <neilb@suse.de>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Documenting execve() and EAGAIN
Message-ID: <20140522114102.66129305@notabene.brown>
In-Reply-To: <537CEC90.7060000@gmail.com>
References: <537CEC90.7060000@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/d5gQPWqZGK=ZQv0dGUkqKO6"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/d5gQPWqZGK=ZQv0dGUkqKO6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 21 May 2014 20:12:32 +0200 "Michael Kerrisk (man-pages)"
<mtk.manpages@gmail.com> wrote:

> Vasily (and Motohiro),
>=20
> Sometime ago, Motohiro raised a documentation bug
> ( https://bugzilla.kernel.org/show_bug.cgi?id=3D42704 ) which=20
> relates to your commit 72fa59970f8698023045ab0713d66f3f4f96945c
> ("move RLIMIT_NPROC check from set_user() to do_execve_common()")
>=20
> I have attempted to document this, and I would like to ask you
> (and Motohiro) if you would review the text proposed below for
> the exceve(2) man page.
>=20
> Thank you,
>=20
> Michael
>=20
>=20
> ERRORS
>        EAGAIN (since Linux 3.1)
>               Having  changed its real UID using one of the set*uid()
>               calls,  the  caller  was=E2=80=94and  is  now  still=E2=80=
=94above  its
>               RLIMIT_NPROC  resource limit (see setrlimit(2)).  For a
>               more detailed explanation of this error, see NOTES.
>=20
> NOTES
>    execve() and EAGAIN
>        A more detailed explanation of the EAGAIN error that can occur
>        (since Linux 3.1) when calling execve() is as follows.
>=20
>        The EAGAIN error can occur when a preceding call to setuid(2),
>        setreuid(2), or setresuid(2) caused the real user  ID  of  the
>        process  to  change,  and  that  change  caused the process to
>        exceed its RLIMIT_NPROC resource limit (i.e.,  the  number  of
>        processes  belonging  to the new real UID exceeds the resource
>        limit).  In Linux 3.0 and earlier, this caused  the  set*uid()
>        call to fail.

I don't know how detailed/precise you want to be, but this failure was from
2.6.0 to 3.0.
Prior to 2.6, the limit was not imposed on processes that changed their uid.

http://git.kernel.org/cgit/linux/kernel/git/history/history.git/commit/?id=
=3D909cc4ae86f3380152a18e2a3c44523893ee11c4

$ git describe --contains 909cc4ae86f3380152a18e2a3c44523893ee11c4
v2.6.0-test2~85^2~5^2~15

Otherwise the description fits my understanding.

NeilBrown

>=20
>        Since  Linux 3.1, the scenario just described no longer causes
>        the set*uid() call to fail, because it too often led to  secu=E2=
=80=90
>        rity  holes because buggy applications didn't check the return
>        status and assumed that=E2=80=94if the caller had root  privileges=
=E2=80=94the
>        call  would  always succeed.  Instead, the set*uid() calls now
>        successfully change real UID, but the kernel sets an  internal
>        flag,  named  PF_NPROC_EXCEEDED, to note that the RLIMIT_NPROC
>        resource limit has been exceeded.  If the  resource  limit  is
>        still exceeded at the time of a subsequent execve() call, that
>        call fails with the error EAGAIN.  This kernel  logic  ensures
>        that the RLIMIT_NPROC resource limit is still enforced for the
>        common privileged daemon workflow=E2=80=94namely, fork(2)+  set*ui=
d()+
>        execve(2).
>=20
>        If  the  resource  limit was not still exceeded at the time of
>        the execve() call (because other processes belonging  to  this
>        real  UID  terminated  between  the  set*uid()  call  and  the
>        execve() call), then the execve() call succeeds and the kernel
>        clears  the  PF_NPROC_EXCEEDED process flag.  The flag is also
>        cleared if a subsequent call to fork(2) by this  process  suc=E2=
=80=90
>        ceeds.
>=20


--Sig_/d5gQPWqZGK=ZQv0dGUkqKO6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU31Vrjnsnt1WYoG5AQJoVBAAm5RBIKd+YthvI61cy+sx9YVmJScintDa
wT7BMPQiM+81CI/PimqntPoe469giXKZ0lfai/Rwgv4aSpmK9/bFKMLF50ljwUBU
jGPPQP5zlRJgeyDt6+X1J19QxS2aq+SC7UK9Bc23rjllMI2eN8ozBUZNo5TTMJ8n
F40/GDGsEPi/uwDspEmAWmiCW5YBJOdTRrBdZ0dIS6CKzrtXAkkKDc5wcXTCPdGK
clo8cdTSX9YzvKu4tR3Nl6URuhVFtlMvshu7WZ6BR5OY8J+/VnLyHRL6POmZvMDv
uRT4K8VBQzCrKM9rVCyEDjaZUexo53HGGsmi3qK6TWdbSrWwWDmp/mLwAINKLV7Q
6HI0WOqT/qi7IY657FP/IaYJmmWmu5ATVtUR6hEEkpaSM19xH1NCRMFNiAfdXyki
ICsVCZOc/M0gBDjuV5Z6qiKPAHLZtohb/vPXYW2I9aEKzPeD0+tWK01FSpZ2HzFR
7Uw93dClF3PqvR+LsbR79BJLwtvSVTrw5uok8D2fn9beOjXvbdgknegdnTIiLSpA
D5ct1ITdsVdzhJVvQ4q4b3GOiHgAr4mmD+MY8u3ui/rMk3WPDMjWhyu3fn/LF0El
cJyYY8eD5NJroECPGVfmXDOe793INdntBFU/90Ybfbdd0KySBeCV9Jlruyn7iURl
hnDG8MEHYKY=
=I9cq
-----END PGP SIGNATURE-----

--Sig_/d5gQPWqZGK=ZQv0dGUkqKO6--
