Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaBLClg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:41:36 -0500
Received: from ozlabs.org ([203.10.76.45]:58280 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbaBLClf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:41:35 -0500
Date: Wed, 12 Feb 2014 13:41:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the tip tree
Message-Id: <20140212134127.2c049bb94175e12201b257ef@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Feb_2014_13_41_27_+1100_aDglfghNEfcP4Eg4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Feb_2014_13_41_27_+1100_aDglfghNEfcP4Eg4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/cpuidle/cpuidle-pseries.c: In function 'idle_loop_prolog':
drivers/cpuidle/cpuidle-pseries.c:32:2: error: implicit declaration of func=
tion 'ppc64_runlatch_off' [-Werror=3Dimplicit-function-declaration]
  ppc64_runlatch_off();
  ^
drivers/cpuidle/cpuidle-pseries.c: In function 'idle_loop_epilog':
drivers/cpuidle/cpuidle-pseries.c:52:2: error: implicit declaration of func=
tion 'ppc64_runlatch_on' [-Werror=3Dimplicit-function-declaration]
  ppc64_runlatch_on();
  ^

Caused by commit d8c6ad3184ca ("sched/idle, PPC: Remove redundant
cpuidle_idle_call()").

I have used the tip tree from next-20140210 again today (since
next-20140211 was broken differently).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__12_Feb_2014_13_41_27_+1100_aDglfghNEfcP4Eg4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS+t9bAAoJEMDTa8Ir7ZwVk2EP/0mNCTin2FpOCU5aB6h14JqX
YWoiroIdm51EHowoH9/QenJ4d53EQxkG8bAjnrHjaK7g5Jc1NMOsdMvAzgsTOSZD
pOO9DHMp6ZVdG09zcoZGLPRiDryeKbRpmyV8PoZMO0jyvwJD90hW1y3gs4LtNoia
+vcV3FUo7XLf/SgQ8fu6U/y0rGFF14q2FTsEXaOI32v40yHTSG5HpOosPEXcZ1wx
Gndijxmhzrjrym66Jh78wpARoOamj5zOVYF9KdNZmO/8niXHLF2BGEyCp+st/N1Q
hME9zFZtBgezzEBYzgmoOidEhH3kUpJhmqYQ7LBS0z3C598nKLSV4MX8TjO7swEV
SEDO2NlmHQSWyMArVGaKWFcgmc900WwOHT3gkyRyj2SSsx9w0cfYYixRMEAsDEz+
IiQFiBGD4ftxHX3OnHB/aCY/RLFVerQYYyybhG6P5DMG81G0BEGScgIjHGOhpt5x
ZJuW7ZHMYsBS471T9Y3zIC0aTwKgFvWxbBxCuj87FOaSuAlSKnXLvv6BCyHHMARL
Ul+EExYDGL5Autxi7zZogaq1XyrNYr5Wg7hKsG2Pkre676LI/nzLE3PXV8/hHY4b
TaXunVwCCfVOPKC1vyKdyCXLghKFVaKUQa4x/rIXq7oyZzps/xNTjBrVyLRu+Rn1
mzgST90yXQqmPVm+XEnA
=hkaC
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Feb_2014_13_41_27_+1100_aDglfghNEfcP4Eg4--
