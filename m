Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaKEEsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 23:48:35 -0500
Received: from ozlabs.org ([103.22.144.67]:56220 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbaKEEsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 23:48:33 -0500
Date: Wed, 5 Nov 2014 15:48:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Elliott <elliott@hp.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: build failure after merge of the scsi tree
Message-ID: <20141105154826.24390751@canb.auug.org.au>
In-Reply-To: <54587B47.2080309@suse.de>
References: <20141104154320.2919bf64@canb.auug.org.au>
	<54587B47.2080309@suse.de>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/dT6j6IT5oZbtxtyJL9lAgGR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dT6j6IT5oZbtxtyJL9lAgGR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Hannes,

On Tue, 04 Nov 2014 08:07:51 +0100 Hannes Reinecke <hare@suse.de> wrote:
>
> On 11/04/2014 05:43 AM, Stephen Rothwell wrote:
> >=20
> > After merging the scsi tree, today's linux-next build (arm=20
> > multi_v7_defconfig) failed like this:
> >=20
> > In file included from include/linux/sched.h:17:0, from
> > include/linux/blkdev.h:4, from drivers/scsi/constants.c:10:=20
> > drivers/scsi/constants.c: In function 'scsi_opcode_sa_name':=20
> > include/linux/kernel.h:54:32: error: invalid application of
> > 'sizeof' to incomplete type 'const char *[]' #define
> > ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
> > __must_be_array(arr)) ^ drivers/scsi/constants.c:300:15: note:
> > in expansion of macro 'ARRAY_SIZE' if (opcode <
> > ARRAY_SIZE(cdb_byte0_names)) ^
> >=20
> > Caused by 94bafab0008c ("scsi: consolidate opcode lookup in=20
> > scsi_opcode_sa_name()").  This build does not have=20
> > CONFIG_SCSI_CONSTANTS set.
> >=20
> > I have used the scsi tree from next-20141031 again (since
> > yesterday's tree had a different build problem).
> >=20
> Sorry. Here's the patch.

I applied that patch to linux-next today (pending James adding it to
the scsi tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/dT6j6IT5oZbtxtyJL9lAgGR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUWaweAAoJEMDTa8Ir7ZwVaUIQAIB/0DcC2BuqnDpO2vMOunqr
WLSi9KyBmJVwBiENJAIvor6Rbq2ptnJ/FA4dpedqZLU2lG5osz+xiJIRA5xVIPrq
x0ls3qwVFj4l0fP+gJVDdf5CVewlqk5DoLCYYU2MTidaMBpyk0tl2Ms90jSigoI7
kmfjAMglNyeNsGxP+fJ77L8IxJskw6KpshlNnf01wtOM+IO05tGk3F/ObxxxXyvR
PqKflEHtPMDIQLjqv68g3bGFdWjEJTf3iewVep2UhvDQrPeUancDJESPUnZVYKP7
uNfWn/nG/FA89uUgYPznkgb3MsnpYWNi80F3kCvQj+DVtmxniTdeYNewyoXV5468
3Ya0NhtzwkaHssUPhuwxeFKeqm+TxKaqM/egTuX6+iWclD3RNyOQeW2L8Q7J6ZxA
Xr5D7Q7yhwQP2vPHkJ9nhXq8vcHQMYxMOjuDEgrD5jQAkqD2MSQIz3zgtRFvVIld
Knb/nGxzRYGH2/73sLd13nR3XXzXgkQoy1BXeqdU9efTWfdIH7XyUUxTnw01eKI8
TXK/jircZnpwAi09T0gla0vR4oAekracZqYaOHAsidUE66TxKVfOmkmyv+JsMWyg
7GZ8JFIhg5v0ZMSx/hUtP9FuKMhCOfz9UpThwgGHIvtMwxTsHduFQ7KfpRnKm6FK
1nBJR9RZ6G4mIUU1wVOf
=fTk7
-----END PGP SIGNATURE-----

--Sig_/dT6j6IT5oZbtxtyJL9lAgGR--
