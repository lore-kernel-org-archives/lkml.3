Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaG1Gh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:37:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:29040 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbaG1Gh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:37:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,746,1400050800"; 
   d="asc'?scan'208";a="576370064"
Date: Mon, 28 Jul 2014 02:06:15 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
        hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RFC PATCH v1 14/70] x86, microcode, core: _FROZEN Cleanup
Message-ID: <20140728060615.GC23092@gchen.bj.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <1406080786-3938-15-git-send-email-gong.chen@linux.intel.com>
 <20140724090303.GC19239@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sHrvAb52M6C8blB9"
Content-Disposition: inline
In-Reply-To: <20140724090303.GC19239@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sHrvAb52M6C8blB9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2014 at 11:03:03AM +0200, Borislav Petkov wrote:
>=20
> Missing "break". We like to add those even if it doesn't matter in this
> case.
>=20
> Also, add the boilerplate
>=20
> "default:
> 	break;"
>=20
> while you're at it, please.
>=20

--------8<--------
Subject: [RFC PATCH v2 14/70] x86, microcode, core: _FROZEN Cleanup

Remove XXX_FROZEN state from x86/microcode/core.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Suggested-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/kernel/cpu/microcode/core.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/mic=
rocode/core.c
index dd9d619..da3c2206 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -499,6 +499,11 @@ mc_cpu_callback(struct notifier_block *nb, unsigned lo=
ng action, void *hcpu)
 		pr_debug("CPU%d removed\n", cpu);
 		break;
=20
+	case CPU_UP_CANCELED:
+		/* The CPU refused to come up during a system resume */
+		if (action & CPU_TASKS_FROZEN)
+			microcode_fini_cpu(cpu);
+		break;
 	/*
 	 * case CPU_DEAD:
 	 *
@@ -507,12 +512,10 @@ mc_cpu_callback(struct notifier_block *nb, unsigned l=
ong action, void *hcpu)
 	 * CPU comes back online without unnecessarily requesting the userspace
 	 * for it again.
 	 */
+	default:
+		break;
 	}
=20
-	/* The CPU refused to come up during a system resume */
-	if (action =3D=3D CPU_UP_CANCELED_FROZEN)
-		microcode_fini_cpu(cpu);
-
 	return NOTIFY_OK;
 }
=20
--=20
2.0.0.rc2

--sHrvAb52M6C8blB9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT1ehXAAoJEI01n1+kOSLHtboP/izhtLLJMpZDIquJtemtZWkW
avV8O/lYWq2WYd9rq7ZOBYEasUGsgI91GCdsFAZTqIS4tv+z2L9YaC6KvswVnvDF
10qJ7RXeFa2JFe6r7W01wxRKWHio2VzAvKJTT5/ZTqM4lkghT5N5BUK1M+XvXLAi
83fRByC4r9rwL5ojhdGuSAUqVCFfo8SncgjNgvqS3RYnQLXtLAwVGKE9MARMIYml
pvZ6sc9hJsxYSnfbxngOIIXqquJWEf0AyB79p8D0XzglUMiDytVwjcE/cs1Iaf6J
sLyHIzVgbJ6ajqpW0nL/sEQPvGgnRcIKywg94wlmkgxIyUpkBp78qoR3YAXkeVGv
rGbKkmzmiJGmu8XnAESUkXkDYrIg1LiFGxFk7lSS+BKRmHYHluwtbMnHvXpl2BpG
+GloYNGww+rxT4ZXFKjT3WZdk05bIibb8h9zB/UQTIwS32Kem0ePERSTmDqTIkEL
OC1+6Ox2gDUP2s6yZ6uL36kqjTUl5HUZ2unoMoINxw2kC6VpVk9hoEXUJ/slHVKi
GuZ4+TiV//jXOCgkE0PF6awuMWpODVJK3Os2FRXhBIlP53un/94NtB0GjJz9vnaY
bEKTie5Ybic27URENknGMTmaRC052qkfOaqPn357buOcQrxxuwKiPElhxOdVVbTb
PxM96GvjARFnV6JptGnp
=B5Wk
-----END PGP SIGNATURE-----

--sHrvAb52M6C8blB9--
