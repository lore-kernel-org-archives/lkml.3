Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaBTPie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 10:38:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40513 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbaBTPic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 10:38:32 -0500
Message-ID: <53062165.3040202@canonical.com>
Date: Thu, 20 Feb 2014 16:38:13 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
References: <52FB5669.7090506@canonical.com> <20140212115412.GW27965@twins.programming.kicks-ass.net> <52FCFA23.4060701@canonical.com> <20140213173852.GH6835@laptop.programming.kicks-ass.net> <52FD090C.7010408@canonical.com> <20140213182605.GC14089@laptop.programming.kicks-ass.net> <20140214133428.GB26356@pd.tnic> <52FE2709.3050505@canonical.com> <20140214144700.GC26356@pd.tnic> <52FE4C28.1080500@canonical.com> <20140214172157.GJ6835@laptop.programming.kicks-ass.net>
In-Reply-To: <20140214172157.GJ6835@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="3Esg2appbcMMFDjGwiJl6KirgsfctFc4h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3Esg2appbcMMFDjGwiJl6KirgsfctFc4h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 14.02.2014 18:21, Peter Zijlstra wrote:
> On Fri, Feb 14, 2014 at 06:02:32PM +0100, Stefan Bader wrote:
>> One thing I likely should do is to reinstall the exact same laptop wit=
h 64bit
>> kernel and userspace... maybe only 64bit kernel first... and make sure=
 on my
>> side that this does not show up on 64bit, too. I took the word of repo=
rters for
>> that (and the impression that otherwise many more people would have co=
mplained).
>=20
> Yeha, I'm going to try and install some 32bit userspace on a usb
> harddisk I've got and see if I can boot my Core2 laptop from that to tr=
y
> and reproduce.
>=20
> But all that is probably going to be Monday :/
>=20
*sigh* Already Thursday...

Peter, did you get to reproduce this locally? Unfortunately I had some
interruption and have not more Information than on last Friday (which is =
that
the same hw but 64bit kernel does not show it).

Meanwhile I wonder whether it would make sense to push the following (or =
more?)
to stable for 3.13.y:

1) 16824255394f55adf31b9a96a9965d8c15bdac4c
   x86, acpi, idle: Restructure the mwait idle routines
2) 7e98b71920464b8d15fa95c74366416cd3c88861
   x86, idle: Use static_cpu_has() for CLFLUSH workaround, add barriers
3) 8cb75e0c4ec9786b81439761eac1d18d4a931af3
   sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding
4) 215393bc1fab3d61a5a296838bdffce22f27ffda
   sched/preempt/x86: Fix voluntary preempt for x86

1+2 would be to avoid touching 3 too much and looked to be improvements o=
n their
own. 3+4 would be cherry-picks if not for some fuzz 2.
I saw a few more things labelled preempt between 3.13 and current HEAD bu=
t am
not sure whether or which of those are strictly required. Namely some fix=
ing to
preempt_enable_no_resched() mis-usage and maybe one fixing an issue of ft=
race
locking up.

-Stefan
3


--3Esg2appbcMMFDjGwiJl6KirgsfctFc4h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTBiFlAAoJEOhnXe7L7s6jzc4P/Rj9Faj4joRTARL52o0FBCGi
B+2xgl3zdaSOWkk8IQYDFXJcH5l8s3f6TOvyp0Puj456xnH9buKI2FTQP77iil35
A3KdBzzWpPRtZnan/O5ZtR6ztwXIfvRvBiY2LUhSNikJAZqd//8AdK5vUnfLUHEm
H2kINajI2wxbkAGllEhp32zOSF+YTfyWo21wrP8JyIKSx+5xZKrW8gVIWLDTjOrI
XB/ebdD9ANkdQd3+vSBawnVeaSMjn1LmUMCWfZ0V+9xGLn3XTgS7oB8fEz4e2Ha7
IM+mcho1le/yIXPaEVaXcRjXyRso/iEmOtQ70yu/puzs3t/MmWOT6i1wBF6X06rF
JYgCALLLHTolu3/BsHPx0rgAy3cuCV9kKPDo4/MkForoxmrTQk5sIRtxOEJKIaz6
7YXfwEeuHycgAPT7dQ4/koXeHIP8ztY62zyaod778Dk+QiTfTYPJQ0nMD8c55VmH
ZuEMnTy3XjFu15ebDRBnVk9aElNqC97o5kSqzesbJr0ijj3Ps9jouHq5fnZ6RqV+
o/Ra9nxw8jEvYe4NFk6XqqscBMIhnsusq+wcS+BwIGZ+fTHdrMy721Ed2TAryknI
iQx2BMJfeDF/2op40cWfy9VNdKKb/xtSS7g7ncW/YnVK/c3IuAbOlkM7N+8ScuxU
UagmsFyly3NxGaHsdWUf
=Rf1s
-----END PGP SIGNATURE-----

--3Esg2appbcMMFDjGwiJl6KirgsfctFc4h--
