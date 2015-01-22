Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbbAVCPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:15:43 -0500
Received: from ozlabs.org ([103.22.144.67]:44521 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbbAVCPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:15:34 -0500
Date: Thu, 22 Jan 2015 13:15:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michel =?UTF-8?B?RMOkbnplcg==?= <michel.daenzer@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-ID: <20150122131528.551f5eea@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/wirmZGl2RVZmJ=+j3E=kygs"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wirmZGl2RVZmJ=+j3E=kygs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/amd/amdkfd/kfd_priv.h between commit 6ee0ad2a7f27
("drm/amdkfd: Drop interrupt SW ring buffer") from Linus' tree and
commit 36b5c08f099a ("drm/amdkfd: Add gtt sa related data to kfd_dev
struct") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index b3dc13c83169,a79c21781d3b..000000000000
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@@ -135,6 -143,21 +143,14 @@@ struct kfd_dev=20
 =20
  	struct kgd2kfd_shared_resources shared_resources;
 =20
+ 	void *gtt_mem;
+ 	uint64_t gtt_start_gpu_addr;
+ 	void *gtt_start_cpu_ptr;
+ 	void *gtt_sa_bitmap;
+ 	struct mutex gtt_sa_lock;
+ 	unsigned int gtt_sa_chunk_size;
+ 	unsigned int gtt_sa_num_of_chunks;
+=20
 -	void *interrupt_ring;
 -	size_t interrupt_ring_size;
 -	atomic_t interrupt_ring_rptr;
 -	atomic_t interrupt_ring_wptr;
 -	struct work_struct interrupt_work;
 -	spinlock_t interrupt_lock;
 -
  	/* QCM Device instance */
  	struct device_queue_manager *dqm;
 =20

--Sig_/wirmZGl2RVZmJ=+j3E=kygs
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUwF1EAAoJEMDTa8Ir7ZwVK4IP/19IFoGvonCMuOJ069s6JF6L
huTMDPMr1RDE8rkLUirLXD3QZvN4fAT1KkhpGwLQYwgKJMpUgnerL8K0L0dkjG2t
IIgU3NXARY1i/+qdtfGE0IjhODJtNFEFcDZsQN9sk+6sowRpAZTRJrPgkbqLbhCb
L1qLGiuFY88WAZczky/ee9QPWseSer18bVl0EfpUOEdJJ4VxTClnPIPaP20AI04e
U55kukChpuMsb/8TkXi37WS0X82ultn/WeVO7ITIfpDKXRXN7/iujwu9MfmhT7Pv
bh+ibZ0Q3vNALdc+x5MOLmu3f2BnM34DvcNRHbzZMwwufK1peMI26gDybuBsmwdy
OsGP3qZPgCXyujaWQkJh2eQUu2Tpv4OFxlKS3+b7bjj7Brk0jM+FEh4Hbzw0A61p
sXSz0gxLAduwBJe0xSLpWybO1JlJd/v4g/iIdXOROl+7CmY8J/hKb6DEyu8OM5D7
C5aaHUrO4JQ/egSMPDiGKzfQLiFa2w+JWrA5pg5t/lKfHFgrMKEuZSFqPHkNb5YI
zokRPL0r7J4WGaqozeo0vfZMDtotAj8w3Yt0SZy2SHvt+9hddR8f1FfhespcX52r
E+Vz6qe530k6liCMLcjwzEQTeOvPSpcn02PKd++8uI7IF4dwyqd2f+w5ynei16bk
jzA2HoPR8vNhQPPZS44R
=UQ7R
-----END PGP SIGNATURE-----

--Sig_/wirmZGl2RVZmJ=+j3E=kygs--
