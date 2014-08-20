Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaHTRbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 13:31:44 -0400
Received: from omr2.cc.vt.edu ([198.82.141.100]:56809 "EHLO omr2.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaHTRbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 13:31:43 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Ari Sundholm <asundhol@cs.hut.fi>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH] Revert "platform/x86/toshiba-apci.c possible bad if test?"
In-Reply-To: Your message of "Wed, 20 Aug 2014 20:03:26 +0300."
             <alpine.GSO.2.00.1408201955290.8292@hutcs>
From: Valdis.Kletnieks@vt.edu
References: <alpine.GSO.2.00.1408201955290.8292@hutcs>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1408555890_2096P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 20 Aug 2014 13:31:30 -0400
Message-ID: <11648.1408555890@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1408555890_2096P
Content-Type: text/plain; charset=us-ascii

On Wed, 20 Aug 2014 20:03:26 +0300, Ari Sundholm said:
> From: Ari Sundholm <ari@tuxera.com>
>
> This reverts commit bdc3ae7221213963f438faeaa69c8b4a2195f491.

> +	if (sscanf(buf, "%i", &mode) != 1 && (mode != 2 || mode != 1))
>  		return -EINVAL;

I'm not convinced that's right either.  If we come in and mode == 1, then
the mode != 2 is true, and yoinks...

I think this wanted to be   sscanf() != 1 || ! (mode == 2 || mode == 1)

I'll spin a patch against the reverted version if desired.

--==_Exmh_1408555890_2096P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU/TbcgdmEQWDXROgAQLGqA//UX72WK2I8d8z633JPstX2ryZGM93m4J0
CtZfqje9Wypcxs/CceuIvQ93uwbui4L0aWPvXt8HWuBuakLJxoPPkWY4GBZSP/4f
w8Y7G84EyAGXQAGd/dIOWWgrYL+AOSgPoxeWZnvFr/hZmutPGQB/uKMFHNFTpubL
MtXu3PU/FONLZdWPoGWKn867Jype5utEr0jDdiFP4sICv64hLXgQJtOcNZChAqul
Xijz/QeRgdD6raI4VoSRJfftrYAabDmexYU8Z8oLINpODKMzqvIojMjJYRlkKTgf
039qsTP3N4G1M9GQW/XgkSezo/fhBiQYGdCBZUvWLspjBhJsmKVIg6cysMNk56hH
VzbcwEQLl4zuILJ6wdZ1SZJuON4O7bSlPL7oQi+sUsADrTCksnazg2nxT4s6BUAz
HBbacBJ+RVKojphE+CK34ufDDxGd1tnPXmm+bAv3u8jsFU3lWj3MVuX+x0LEVP4z
46kVjvh3oCjIgvXVglhB3n/Y5WgyLvYBq8PgHXS5Gm0L6fCA5B1pKTuyXUuAbUxz
n0vD92ZvjM1fGhENnD4ReTqpF9ewenurGOLN4LPoJyku0Y/4wJyUqtyfjjeWXRYt
gFfLwyetSfE1aPJ/ubC7G/oeBPkWHKxIDfSpcgU14ELFPgt9OUAuNFX4sC9U3CQ0
iS/Tsd+KLgk=
=fvAC
-----END PGP SIGNATURE-----

--==_Exmh_1408555890_2096P--
