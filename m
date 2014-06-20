Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934663AbaFTF1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 01:27:21 -0400
Received: from ozlabs.org ([103.22.144.67]:37833 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934263AbaFTF1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 01:27:18 -0400
Date: Fri, 20 Jun 2014 15:27:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140620152715.24baa4ce@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/8lsjlsECMLJ6Dfdz2Jqs3yc"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8lsjlsECMLJ6Dfdz2Jqs3yc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (arm
defconfig) failed like this:

In file included from /scratch/sfr/next/arch/arm/mm/dma-mapping.c:29:0:
/scratch/sfr/next/include/linux/cma.h:8:28: error: 'CONFIG_CMA_AREAS' undec=
lared here (not in a function)
 #define MAX_CMA_AREAS (1 + CONFIG_CMA_AREAS)
                            ^
/scratch/sfr/next/arch/arm/mm/dma-mapping.c:434:54: note: in expansion of m=
acro 'MAX_CMA_AREAS'
 static struct dma_contig_early_reserve dma_mmu_remap[MAX_CMA_AREAS] __init=
data;
                                                      ^

Caused by commit f495d267b2e0 ("CMA: generalize CMA reserved area
management functionality").

I have reverted that commit and these commits that depend on it

57d551e70a38 ("mm, CMA: clean-up log message")
d75ab106aef5 ("mm, CMA: change cma_declare_contiguous() to obey coding conv=
ention")
f693a5424631 ("mm, CMA: clean-up CMA allocation error path")
e58e263e5254 ("PPC, KVM, CMA: use general CMA reserved area management fram=
ework")

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/8lsjlsECMLJ6Dfdz2Jqs3yc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTo8YzAAoJEMDTa8Ir7ZwVTwgP/0W1S9fW4rmaAlY0LCwR80uo
JW4EdSlf/iVrsVGe4p449z3ugJnlUeZjMJ5IgiMlvw2moWTSw/5Hg3b41dv7LMKj
PiV3wH0bHfW0meDs/uFHvoLDYStWPSs6Jb3XYbdjnjxAuddqoqhTPxorlQv81xTK
n+1SdeXyauded4Va6aflNXAWytbIY7+HO+Sd+HArC+h6gVbMXywJXWvRzoG1PHSv
BZNwTV0FZNZBHpkh7OjB5fXuDvdHBVS//oBs9yI8B2A6IirLsZJnjb6KUmP6iJht
3o5qgkYE2FaevRq6ebeHCkJO2p0XXZgSdDYRgE/S8D+YYMnNJulGUienSq0lYNHx
vOVk9PVXpJc4B/L+d/Vc/UkOgjBFnq1M48e4QpPqetQlyuwg8Akvnegm1/yIUt9W
EP8YX1OBXbxWhGdMOI+WGlb6+TieNDmT8ffBHfOQiIapsfRpsK5z2BQSsJjLeecp
p948n6zytkl8ShjyNZtTYr9UdOkFikIP3qbT5lk7cUAxJJ8UaQvC5iHAQQOCYgl8
xvSOCSoIalQMWBR/uqKZYS/OsJB4xpFv0TVoya6TuBugb6da6Ol4FRqrbVoGmvrR
ZABdeEhU2ldT/416NQdtJSQ5F3mJUltlebRhRKBzHBkcg4myNebWZadoT9jdXwl+
2MkVdFBMWql0vOlRPcXx
=8aDG
-----END PGP SIGNATURE-----

--Sig_/8lsjlsECMLJ6Dfdz2Jqs3yc--
