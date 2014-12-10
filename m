Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaLJIUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:20:43 -0500
Received: from ozlabs.org ([103.22.144.67]:33049 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbaLJIUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:20:42 -0500
Date: Wed, 10 Dec 2014 19:20:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the access_once tree
Message-ID: <20141210192035.2e5d80ff@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/UCMJBBO1Uh3vVdwQwEVLpla"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UCMJBBO1Uh3vVdwQwEVLpla
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Christian,

After merging the access_once tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

In file included from /scratch/sfr/next/include/uapi/linux/stddef.h:1:0,
                 from /scratch/sfr/next/include/linux/stddef.h:4,
                 from /scratch/sfr/next/include/uapi/linux/posix_types.h:4,
                 from /scratch/sfr/next/include/uapi/linux/types.h:13,
                 from /scratch/sfr/next/include/linux/types.h:5,
                 from /scratch/sfr/next/include/linux/smp.h:10,
                 from /scratch/sfr/next/include/linux/kernel_stat.h:4,
                 from /scratch/sfr/next/mm/memory.c:41:
In function '__read_once_size',
    inlined from 'handle_pte_fault' at /scratch/sfr/next/mm/memory.c:3192:1=
0,
    inlined from '__handle_mm_fault' at /scratch/sfr/next/mm/memory.c:3324:=
2,
    inlined from 'handle_mm_fault' at /scratch/sfr/next/mm/memory.c:3353:6:
/scratch/sfr/next/include/linux/compiler.h:206:3: warning: call to 'data_ac=
cess_exceeds_word_size' declared with attribute warning: data access exceed=
s word size and won't be atomic
   data_access_exceeds_word_size();
   ^
mm/built-in.o: In function `handle_mm_fault':
(.text+0x283a0): undefined reference to `data_access_exceeds_word_size'

I hate dropped the access_once tree again today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/UCMJBBO1Uh3vVdwQwEVLpla
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUiAJYAAoJEMDTa8Ir7ZwVS5EP/2gwTPI0j4BnXbArBZD4B+OO
mBqc/FGAed6UyhsGh4roS0CIPuxsAV+39tY3Ey6BRj7neM4a57IJaRXJ2koE8fK8
0nmPFtvFfvC8/C4VhF3mQnHWMR05v227hmHA4iweDt6uhfgiK38cEh78XzrxQDsp
BASeVsICdEjQwo63spoZ0nBSCSlTWCtOHO8a682ALsIqfKNt/Av/Elg33ANn1ppf
fkgnr/VPtfaBg/lOsVRHE2nSN9EmjjAxTWlv39U6Uf0FTsKpYuGWshkuFXVJqfH0
0PmoPPu7+NHbHCTnsk8JGBeXmoZQzysloEEjV4RdxYKHr/Gf1wX84K2K3UxLXq0R
svYVuVZ6wIG6bizQ/x2A2drtTLJzJiqSfVTDQre+ReLs3sizcyiXxhuTDbGc2vBk
Dn4MqW9gSMKbrwMGgYLdclf8TlR1hFDillDJlEEj6OUdUIebtqXLtIch2xNg6Aue
Ln3vpWuW8PQSeCTlvjOi9a8u3ffE4D1qGtcZ6FWzm6j4HRVZtMdsgQm3mx4/ldAz
lmft2EBNrYYH7hVxg8vwkedzL87pCOgar244TZ7RqTURpcuQOPp6NhkjU/C5Eo/9
a4y1XXgAYkXW66KczynVtO/nGKtOSU2wBj91AcQVFQLrEMdMHI7sRXtv59on8CJl
WI4x6d+wjOQDQ3VddhaU
=wVoV
-----END PGP SIGNATURE-----

--Sig_/UCMJBBO1Uh3vVdwQwEVLpla--
