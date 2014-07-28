Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaG1Gep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:34:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:45225 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbaG1Gen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:34:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,746,1400050800"; 
   d="asc'?scan'208";a="576369324"
Date: Mon, 28 Jul 2014 02:03:31 -0400
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
Subject: Re: [RFC PATCH v1 12/70] x86, pci, amd_bus: _FROZEN Cleanup
Message-ID: <20140728060331.GA23092@gchen.bj.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <1406080786-3938-13-git-send-email-gong.chen@linux.intel.com>
 <20140723180718.GH21707@pd.tnic>
 <20140724013130.GA2434@gchen.bj.intel.com>
 <20140724082847.GA19239@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20140724082847.GA19239@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2014 at 10:28:47AM +0200, Borislav Petkov wrote:
> On Wed, Jul 23, 2014 at 09:31:30PM -0400, Chen, Gong wrote:
> > But what if new action is added? We have to change it back. If you
> > prefer to use that style I can update in next version.
>=20
> Not likely. This functionality in amd_bus.c is not going to expand
> anyway but rather die with its last user, AFAICR.
>=20

--------8<--------

Subject: [RFC PATCH v2 12/70] x86, pci, amd_bus: _FROZEN Cleanup

Remove XXX_FROZEN state from x86/pci/amd_bus.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Suggested-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/pci/amd_bus.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index c20d2cc..2d7c6c6 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -340,15 +340,10 @@ static void enable_pci_io_ecs(void *unused)
 static int amd_cpu_notify(struct notifier_block *self, unsigned long actio=
n,
 			  void *hcpu)
 {
-	int cpu =3D (long)hcpu;
-	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		smp_call_function_single(cpu, enable_pci_io_ecs, NULL, 0);
-		break;
-	default:
-		break;
-	}
+	if ((action & ~CPU_TASKS_FROZEN) =3D=3D CPU_ONLINE)
+		smp_call_function_single((long)hcpu, enable_pci_io_ecs,
+					 NULL, 0);
+
 	return NOTIFY_OK;
 }
=20
--=20
2.0.0.rc2

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT1eezAAoJEI01n1+kOSLHzLEQAJYXVkVEYle9iiBKf+7x26y4
TFD6YgE9hSMXXOv1d65ykm0qifTxRZsUvKq/lily3obNXYjWG9ui6pJflRxM3Sab
fTXfr3NU82lGJ0h6jCGpQ2mujyYHZ8DJFasy1q3kUYoPEqSfFOa0aaAx3gD1MDmm
hw+ivxEcNiu3uGffz/BFTH6jmqk1DTDg1GxieGmHVEt0DVIxYwKgy2erzYj7vLcv
W3v4P2xm8WJjw4Z/6RyIASk7USnNWhaa1yC0BjiRmf4lrM7YdulUVs5/i/lE5duk
VZkgpL0Zx3hPCKTpiAfrwIvqXBWF2rpz5b+q9+sf/I7uVMaTddbwQaqtB2bxEW6+
4TN37nn3+f3jTvT6k6nRfgThDpyMJhtHQha1KnLllh+uR2tKUgvAKa5Q6lQaYm+F
B74Uup3fbBGZ/MtMpNHhXA3vRXWgzE37uu7E1EVQoYyYT7ks2TrBP80VFdWGC57C
/ZpRFerJ2cFCgGb+rlT2IemfJJ9B05PxKIk1Ca654SEn8yHz9EQyA2YtowrxI49c
HiTqJzTZKbMzJt9RFx3WykD6GbKfWwNVicO/VPPiDGvuzBqAyWWzf6OIwMyvdh+G
FBJMXVy4neuT5fAwHNaN6dES2MY8vxK3Y9RJDQiHMOYqhGiwkVYx6TBsYSFkXAjP
2ixNxhMebdcIfFXOjYsD
=dDXP
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
