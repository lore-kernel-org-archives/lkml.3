Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaDCNKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:10:44 -0400
Received: from fnord.ir.bbn.com ([192.1.100.210]:55606 "EHLO fnord.ir.bbn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaDCNKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:10:40 -0400
X-Greylist: delayed 767 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2014 09:10:40 EDT
From: Greg Troxel <gdt@ir.bbn.com>
To: "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>
Cc: Richard Hansen <rhansen@bbn.com>, Steven Whitehouse <swhiteho@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm: msync: require either MS_ASYNC or MS_SYNC
References: <533B04A9.6090405@bbn.com> <20140402111032.GA27551@infradead.org>
	<1396439119.2726.29.camel@menhir> <533CA0F6.2070100@bbn.com>
	<CAKgNAki8U+j0mvYCg99j7wJ2Z7ve-gxusVbM3zdog=hKGPdidQ@mail.gmail.com>
OpenPGP: id=32611E25
X-Hashcash: 1:20:140403:rhansen@bbn.com::UFOdifbR3tiBi7Yx:002jWO
X-Hashcash: 1:20:140403:hch@infradead.org::GTZ8sVgmfA10nYFp:000000000000000000000000000000000000000000004nhf
X-Hashcash: 1:20:140403:linux-api@vger.kernel.org::2BKW8TbKm4ZLgVeU:0000000000000000000000000000000000000ilk
X-Hashcash: 1:20:140403:peterz@infradead.org::NrOl8DCqeGrv3XAi:000000000000000000000000000000000000000000z3k
X-Hashcash: 1:20:140403:linux-mm@kvack.org::lslW1D2HTJS6zJnQ:00000000000000000000000000000000000000000003mUq
X-Hashcash: 1:20:140403:swhiteho@redhat.com::4skr/nBhrFWza0xM:0000000000000000000000000000000000000000000e5B
X-Hashcash: 1:20:140403:linux-kernel@vger.kernel.org::Z2x0/+zsbOZQWjlP:0000000000000000000000000000000007J3k
X-Hashcash: 1:20:140403:mtk.manpages@gmail.com::gYYavyqxSn2HTatq:000000000000000000000000000000000000000QO3z
Date: Thu, 03 Apr 2014 08:57:52 -0400
In-Reply-To: <CAKgNAki8U+j0mvYCg99j7wJ2Z7ve-gxusVbM3zdog=hKGPdidQ@mail.gmail.com>
	(Michael Kerrisk's message of "Thu, 3 Apr 2014 10:25:01 +0200")
Message-ID: <rmivbuqy3hr.fsf@fnord.ir.bbn.com>
User-Agent: Gnus/5.130006 (Ma Gnus v0.6) Emacs/23.4 (berkeley-unix)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> I think the only reasonable solution is to better document existing
> behavior and what the programmer should do. With that in mind, I've
> drafted the following text for the msync(2) man page:
>
>     NOTES
>        According to POSIX, exactly one of MS_SYNC and MS_ASYNC  must  be
>        specified  in  flags.   However,  Linux permits a call to msync()
>        that specifies neither of these flags, with  semantics  that  are
>        (currently)  equivalent  to  specifying  MS_ASYNC.   (Since Linux
>        2.6.19, MS_ASYNC is in fact a no-op, since  the  kernel  properly
>        tracks  dirty  pages  and  flushes them to storage as necessary.)
>        Notwithstanding the Linux behavior, portable, future-proof appli=
=E2=80=90
>        cations  should  ensure  that they specify exactly one of MS_SYNC
>        and MS_ASYNC in flags.
>
> Comments on this draft welcome.

I think it's a step backwards to document unspecified behavior.  If
anything, the man page should make it clear that providing neither flag
results in undefined behavior and will lead to failure on systems on
than Linux.  While I can see the point of not changing the previous
behavior to protect buggy code, there's no need to document it in the
man page and further enshrine it.

There's a larger point, which is that people write code for Linux when
they should be writing code for POSIX.  Therefore, Linux has an
obligation to the larger free software community to avoid encouraging
non-portable code.  This is somewhat similar (except for the key point
that it's unintentional) to bash's allowing "=3D=3D" in test, which is a
gratuitous extension to the standard that has led to large amounts of
nonportable code.  To mitigate this, it would be reasonable to syslog a
warning the first time a process makes a call with flags that POSIX says
leads to undefined behavior.  That would meet the
portability-citizenzhip goals and not break existing systems.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlM9WtAACgkQ+vesoDJhHiV7HwCfdOu6gMykiZY3L5gYuaaAmD6k
/vIAmwb5o33ETiVujuJmg5qcHzbU9sVx
=JpEp
-----END PGP SIGNATURE-----
--=-=-=--
