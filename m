Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaENHbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:31:07 -0400
Received: from ozlabs.org ([103.22.144.67]:41474 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbaENHbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:31:01 -0400
Date: Wed, 14 May 2014 17:30:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140514173052.3ec80d90@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/x8CcuEJdLbLWVk4nF0o+zEA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/x8CcuEJdLbLWVk4nF0o+zEA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from arch/powerpc/mm/numa.c:23:0:
include/linux/cpuset.h: In function 'cpusets_enabled':
include/linux/cpuset.h:21:2: error: implicit declaration of function 'stati=
c_key_false' [-Werror=3Dimplicit-function-declaration]
  return static_key_false(&cpusets_enabled_key);
  ^
include/linux/cpuset.h: In function 'nr_cpusets':
include/linux/cpuset.h:27:2: error: implicit declaration of function 'stati=
c_key_count' [-Werror=3Dimplicit-function-declaration]
  return static_key_count(&cpusets_enabled_key) + 1;
  ^
include/linux/cpuset.h: In function 'cpuset_inc':
include/linux/cpuset.h:32:2: error: implicit declaration of function 'stati=
c_key_slow_inc' [-Werror=3Dimplicit-function-declaration]
  static_key_slow_inc(&cpusets_enabled_key);
  ^
include/linux/cpuset.h: In function 'cpuset_dec':
include/linux/cpuset.h:37:2: error: implicit declaration of function 'stati=
c_key_slow_dec' [-Werror=3Dimplicit-function-declaration]
  static_key_slow_dec(&cpusets_enabled_key);
  ^

And lots more - you get the idea.

Caused by commit 95d217015fd3 ("mm: page_alloc: use jump labels to
avoid checking number_of_cpusets").  See Rule 1 in
Documentation/SubmitChecklist :-(

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/x8CcuEJdLbLWVk4nF0o+zEA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTcxuxAAoJEMDTa8Ir7ZwVzM4P/279CoPb46QCJIXyDl6M/fSl
IGVL1JeerzZqJArwIciv4NCQgY3nRRKR2m/TeEqRjIMovaSExhVbn1qNhpSTC+nJ
SzOJW4oHuTOb6cA1ryBSTY0s7jnWzIElr/8HYgKogHjPwB8bL8w1VtGMHg0s2TOI
/sFb43f6PexBmvFeiOddCQ5WHSiX5jQFpO7gNgNtm//ZU2vFahBss5M95UseH5GU
qCWvhcocGVImbf23gvHVa9R/epfe8oUsLZzEy818TlTpjl4Tzf44oSyoVMPEpYch
omxxEGT1k8yf1q9S9KovCTvwZ6eNH/tb5kPYj1jDd16VymBo2dS7v0O+Y13H0xOU
7/3VWHKMTnCpj0/4sjJ81P57rYjwJU7xd1HprsU64X9rl3TCENnDstg+AVydiHzY
DbhGFzuMj1IEjnzkYdP6tEzWDTq8MC6FnaEt8qk6EiHmu3tzMbaDZj2J8BXKpXM6
9XCZQKkRt67GA8+4MRen7VQ24RXdRJ66lrs17nyjIpByITYMjjURxLpgFRD6HwC6
6KehvvnKRJ4/sixIU6FjQimzBF+8KvluFiY1tEJiYJEpiEYZBABSRp4/F+mMwKGc
DgWeDhI7BpWEcUODcifgi9MSkgXdeQWLXHr60H0LgN3lWC6R+DrfiLS9nCrhwQhQ
egF/p+shTjrGAwav2BYz
=L5im
-----END PGP SIGNATURE-----

--Sig_/x8CcuEJdLbLWVk4nF0o+zEA--
