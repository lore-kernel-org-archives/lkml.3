Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbaGBBRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 21:17:22 -0400
Received: from ozlabs.org ([103.22.144.67]:48472 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbaGBBRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 21:17:21 -0400
Date: Wed, 2 Jul 2014 11:17:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>
Subject: linux-next: manual merge of the arm-perf tree with the arm tree
Message-ID: <20140702111708.0a209b87@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/tZDx5G3tJTSjOIFc2lGlE9E"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tZDx5G3tJTSjOIFc2lGlE9E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Will,

Today's linux-next merge of the arm-perf tree got a conflict in
arch/arm/kernel/perf_event_cpu.c between commit 324bbc0804ac ("ARM:
make it easier to check the CPU part number correctly") from the arm
tree and commit 6f73e8ababdd ("arm: perf: clean up PMU names") from the
arm-perf tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
diff --cc arch/arm/kernel/perf_event_cpu.c
index c02c2e8c877d,c63dc4201a7f..000000000000
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@@ -254,35 -259,38 +257,39 @@@ static int probe_current_pmu(struct arm
 =20
  	pr_info("probing PMU on CPU %d\n", cpu);
 =20
 +	switch (read_cpuid_part()) {
  	/* ARM Ltd CPUs. */
 -	if (implementor =3D=3D ARM_CPU_IMP_ARM) {
 -		switch (part_number) {
 -		case ARM_CPU_PART_ARM1136:
 -			ret =3D armv6_1136_pmu_init(pmu);
 -			break;
 -		case ARM_CPU_PART_ARM1156:
 -			ret =3D armv6_1156_pmu_init(pmu);
 -			break;
 -		case ARM_CPU_PART_ARM1176:
 -			ret =3D armv6_1176_pmu_init(pmu);
 -			break;
 -		case ARM_CPU_PART_ARM11MPCORE:
 -			ret =3D armv6mpcore_pmu_init(pmu);
 -			break;
 -		case ARM_CPU_PART_CORTEX_A8:
 -			ret =3D armv7_a8_pmu_init(pmu);
 -			break;
 -		case ARM_CPU_PART_CORTEX_A9:
 -			ret =3D armv7_a9_pmu_init(pmu);
 -			break;
 -		}
 -	/* Intel CPUs [xscale]. */
 -	} else if (implementor =3D=3D ARM_CPU_IMP_INTEL) {
 -		switch (xscale_cpu_arch_version()) {
 -		case ARM_CPU_XSCALE_ARCH_V1:
 -			ret =3D xscale1pmu_init(pmu);
 -			break;
 -		case ARM_CPU_XSCALE_ARCH_V2:
 -			ret =3D xscale2pmu_init(pmu);
 -			break;
 +	case ARM_CPU_PART_ARM1136:
++		ret =3D armv6_1136_pmu_init(pmu);
++		break;
 +	case ARM_CPU_PART_ARM1156:
++		ret =3D armv6_1156_pmu_init(pmu);
++		break;
 +	case ARM_CPU_PART_ARM1176:
- 		ret =3D armv6pmu_init(pmu);
++		ret =3D armv6_1176_pmu_init(pmu);
 +		break;
 +	case ARM_CPU_PART_ARM11MPCORE:
 +		ret =3D armv6mpcore_pmu_init(pmu);
 +		break;
 +	case ARM_CPU_PART_CORTEX_A8:
 +		ret =3D armv7_a8_pmu_init(pmu);
 +		break;
 +	case ARM_CPU_PART_CORTEX_A9:
 +		ret =3D armv7_a9_pmu_init(pmu);
 +		break;
 +
 +	default:
 +		if (read_cpuid_implementor() =3D=3D ARM_CPU_IMP_INTEL) {
 +			switch (xscale_cpu_arch_version()) {
 +			case ARM_CPU_XSCALE_ARCH_V1:
 +				ret =3D xscale1pmu_init(pmu);
 +				break;
 +			case ARM_CPU_XSCALE_ARCH_V2:
 +				ret =3D xscale2pmu_init(pmu);
 +				break;
 +			}
  		}
 +		break;
  	}
 =20
  	put_cpu();

--Sig_/tZDx5G3tJTSjOIFc2lGlE9E
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTs12eAAoJEMDTa8Ir7ZwVFjcP/214L4ZSNZLnxWH0B75+LHeM
L8+pfvuwO3n2RY35x8U6VlJq9EGrUNWt/YMyckwp5XqP7f6CEMSyJJ5sdgO0QVja
+dxnVpv1LbBmJMgZlJyqtFD1RBVUgN6N6Eq5R7vwwlzLKiI/QC7a/4fvP4qKS7Am
2TAt0H4Zc10Yq0u1M5wuncoE99uRt8mfhGQxSvEzrPcWpqu3gqh2bleTr9c/9XKf
0lipGubPL3b2svv+RJhxIffSEb0IWihoaA2DYVtPWHoriSzgvUl1L+F0k6EMJIIw
kmEyxnZl0ghYOG7epvn91kwG8ZYAh/GSQVcE2b5pIBvqttBfY5kM1aP2vIFhMT6F
mNDrYRs2dGftiUpPnyuPUp84AjF1BomFhwyshIpmCIXEvrcsFbbu79yCNgFirTn3
hJBH6tk4C8ofPMHwjoFM17LWrgdk2UeejuXeMpzqBWlPOyLILAgXTgoq8Yh6Am8s
GHDLj5XmVNQ+ppadJz2xlmyNzSZt/SYDkvwTdzR/dzisxkCc7dKrGeF5ym5szBFG
jMtaHcjre+6XI6jlTmXDkyPRY8tAjtbxVaeerP9prwaKYT+aG5kISWGnINkfsbr6
ASCaZu6y4L7/iDVw3RYi8X3fRyNWty041j4QOS2pqCLfVLnjmSZbj4S49ggRuczG
H6iBiX0BeWhO/sADbFWr
=+2NS
-----END PGP SIGNATURE-----

--Sig_/tZDx5G3tJTSjOIFc2lGlE9E--
