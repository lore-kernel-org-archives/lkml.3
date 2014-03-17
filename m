Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbaCQI2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 04:28:13 -0400
Received: from ozlabs.org ([203.10.76.45]:48110 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbaCQI2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 04:28:11 -0400
Date: Mon, 17 Mar 2014 19:28:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Mark Brown <broonie@kernel.org>,
        Stewart Smith <stewart@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-Id: <20140317192804.c338ea1863f70615ab1a53dc@canb.auug.org.au>
In-Reply-To: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Mar_2014_19_28_04_+1100_bu8Gb2Lia/n=nWIy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Mar_2014_19_28_04_+1100_bu8Gb2Lia/n=nWIy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 12 Mar 2014 00:51:52 +0000 Mark Brown <broonie@kernel.org> wrote:
>
> After merging the driver-core tree, today's linux-next build ()
> failed like this on a PowerPC defconfig:
>=20
> HEAD is now at ceb98e684dec Merge remote-tracking branch 'driver-core/dri=
ver-core-next'
>   GEN     /home/broonie/next/powerpc_ppc64_defconfig/Makefile
> #
> # configuration written to .config
> #
> /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-elog.c: In fu=
nction 'elog_ack_store':
> /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-elog.c:84:2: =
error: implicit declaration of function 'sysfs_schedule_callback' [-Werror=
=3Dimplicit-function-declaration]
>   sysfs_schedule_callback(&elog_obj->kobj, delay_release_kobj,
>   ^
> cc1: all warnings being treated as errors
> make[3]: *** [arch/powerpc/platforms/powernv/opal-elog.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
> /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-dump.c: In fu=
nction 'dump_ack_store':
> /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-dump.c:100:2:=
 error: implicit declaration of function 'sysfs_schedule_callback' [-Werror=
=3Dimplicit-function-declaration]
>   sysfs_schedule_callback(&dump_obj->kobj, delay_release_kobj,
>   ^
> cc1: all warnings being treated as errors
>=20
> due to an interaction between d1ba277e7988908 (sysfs, driver-core: remove=
 unused {sysfs|device}_schedule_callback_owner()) and 774fea1a38c6a5a8 (pow=
erpc/powernv: Read OPAL error log and export it through sysfs) from the Pow=
erPC tree.
>=20
> I reverted 774fea1a38c6a5a8 for today.

I instead reverted commit d1ba277e7988908 (sysfs, driver-core: remove
unused {sysfs|device}_schedule_callback_owner()).  I hope that will work
as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Mar_2014_19_28_04_+1100_bu8Gb2Lia/n=nWIy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJrIYAAoJEMDTa8Ir7ZwVb9gP/0Zwyxhaxn47TDKNmRqvelHU
p9pbGvvc+G5Ujg/0AkP+UfA+G/9N/+51OmVnr//8HLrLRfL4LRxGiL3gKi9X64Gh
GAw8SNApMqohV16Q+I4g13b0/fkNuyX8nT83SLRYNkoAjf2co1kQwrctu9LF+pln
nf+Oreyx+w9YE0ZMfFb7m94bwgBzoADQc62BgqkoZPK9kTUST0AcKPaJGEPWIuO4
nf6v7eiCIHR6gD1yVBG+A/G0knYpB1aKyvj9NwlPK1HVEGrcIg1UR9+WffDCt8RC
oCC4NzuvEPr/+3GfKWcmAm6qizbQA/wxBU6VtHtDbI6hzeXoWKn/dRvgww5sq4Hy
BO3J+adQ8B9MuLrIZMCHwVWwW8aTUi0n8/cwPIdFTgl4dcrbZ0CK9e4yWetAEq3U
ykQ76OWDzVnhCafWPzgPmmhwxqNsVkmifW+QpXRPwBQCYZn01TPFrxyLmCB9yXld
GsGm6FhXboaSgsrK1cyEr+6AktjJBxGiTbQek1NsSVnGBkMRb8W+pbLZUA/P3Fq7
71uZfbXR1vcFBxD2q6rnj1S9fQKx6DuSXMZSDF8VmqqWznkKZ21zisl+pQ46RijZ
jJAzXqje1nxuWLdzE9xiN5KPIoVec7FmoulXA2k+2PVpOhN/goAknHSgGckHSlwH
hG28bLtUHDsvnGORLNxC
=XaDU
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Mar_2014_19_28_04_+1100_bu8Gb2Lia/n=nWIy--
