Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964936Ab3BTVIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:08:51 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45056 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935519Ab3BTVIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:08:49 -0500
Date: Thu, 21 Feb 2013 08:08:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Peter Jones <pjones@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>, Jens Axboe <axboe@kernel.dk>,
        Stephen Warren <swarren@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] block/partitions/efi.c: ensure that the GPT header is
 at least the size of the structure.
Message-Id: <20130221080828.669623bc7551466e22405590@canb.auug.org.au>
In-Reply-To: <1361371021-583-2-git-send-email-pjones@redhat.com>
References: <20130220173414.fa4886355efd8f85d0d349f4@canb.auug.org.au>
	<1361371021-583-1-git-send-email-pjones@redhat.com>
	<1361371021-583-2-git-send-email-pjones@redhat.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Feb_2013_08_08_28_+1100_o.kSePY8H.uzAfDE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Feb_2013_08_08_28_+1100_o.kSePY8H.uzAfDE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Wed, 20 Feb 2013 09:37:01 -0500 Peter Jones <pjones@redhat.com> wrote:
>
> +	/* Check the GUID Partition Table header size is too small */
> +	if (le32_to_cpu((*gpt)->header_size) < sizeof(gpt_header)) {
> +		pr_debug("GUID Partition Table Header size is too small: %u < %lu\n",
> +			le32_to_cpu((*gpt)->header_size),
> +			(unsigned long)sizeof(gpt_header));

Don't do this.  We have %zu to print size_t variables ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Feb_2013_08_08_28_+1100_o.kSePY8H.uzAfDE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJTtMAAoJEECxmPOUX5FErSsQAJYOkPMFBsEYnbeVlTmbFl8g
mB8qILAttexZvD62xMArCncRiFGQrfKM3QvrAJVdF59DSQJCM7tfzZtJ34+Z4ALD
B5v0Zq08nuOfK1YClG+PzIs5B2WujwARo+BoDwvR3M4gwrqlSDNvS9rGHM8DBzBw
07YMIcOFRFIehsaOQzI3Ti35JpZYzQEPUdc8U1CsJ7MNNgqv/PgnXit86Zb4iW/D
DNq/pBazvdWdIBZn5lCRI6Ieih1tuR1HU/9gv2l2/atZSStKslNi2/HyYNeZtp88
NmRuzTAHBJ28PobI4G9bF8rzGqw4ZFN2HQ982WVEQ2dYvfcF6Zmc1Th/3jaTHKWy
KoqjIwDDjTKD6zPL61Tt+mTtvH20CihrTbbCIuGFnzUdP2jC65Z/dEme2zffJae/
1KG2MAEGhSaAMu8vEsXTUyPhcMG/YyBNs89y/B8u9gg1sd9nc2MAUSDCyUmfXRvQ
JIL9IO3RMU4Y04hepffXaFuSexDDXgzSXu+5WgQvcrTvYBQ7LB98GzjKvnWPg0Dp
zGXXV4KJRWKfF9ZUtlZNf5g/SAB0tFIX7DVr+te9ADey1MtqgCSS4wI6Cy7ZFpue
XB4fnWL4s7+AGmcW3Lg6cTu1TGw8IUpkZib8K7nsMStvTUTyP3W29PgNO0eD2J4c
z6s9lMZBTRoafeBFY6ek
=9Ro0
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Feb_2013_08_08_28_+1100_o.kSePY8H.uzAfDE--
