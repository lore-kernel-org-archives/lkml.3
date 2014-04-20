Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbaDTQzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 12:55:48 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:37170 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaDTQzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 12:55:45 -0400
Message-ID: <5353FC0A.2080302@googlemail.com>
Date: Sun, 20 Apr 2014 18:55:38 +0200
From: Tobias Powalowski <tobias.powalowski@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, gregkh@linuxfoundation.org
CC: =?ISO-8859-1?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
        linux-kernel@vger.kernel.org,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, davej@redhat.com
Subject: Re: [PATCH driver-core-linus] kernfs: add back missing error check
 in kernfs_fop_mmap()
References: <533D01BD.1010200@googlemail.com> <20140418203825.GK23576@htj.dyndns.org> <5352C7BB.8040009@googlemail.com> <20140420122921.GA32624@htj.dyndns.org>
In-Reply-To: <20140420122921.GA32624@htj.dyndns.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="jM6oQsER2Velbkklr2v7ShqAwQ0KNn7fI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jM6oQsER2Velbkklr2v7ShqAwQ0KNn7fI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 20.04.2014 14:29, schrieb Tejun Heo:
> While updating how mmap enabled kernfs files are handled by lockdep,
> 9b2db6e18945 ("sysfs: bail early from kernfs_file_mmap() to avoid
> spurious lockdep warning") inadvertently dropped error return check
> from kernfs_file_mmap().  The intention was just dropping "if
> (ops->mmap)" check as the control won't reach the point if the mmap
> callback isn't implemented, but I mistakenly removed the error return
> check together with it.
>
> This led to Xorg crash on i810 which was reported and bisected to the
> commit and then to the specific change by Tobias.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-and-bisected-by: Tobias Powalowski <tobias.powalowski@googlema=
il.com>
> References: http://lkml.kernel.org/g/533D01BD.1010200@googlemail.com
> ---
> Hello,
>
> Oops, sorry that I didn't see the mistake which seems so obvious now.
> Can you please verify that this patch works?
>
> Thanks a lot for the report and bisection!
>
>  fs/kernfs/file.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
> index 8034706..e01ea4a 100644
> --- a/fs/kernfs/file.c
> +++ b/fs/kernfs/file.c
> @@ -484,6 +484,8 @@ static int kernfs_fop_mmap(struct file *file, struc=
t vm_area_struct *vma)
> =20
>  	ops =3D kernfs_ops(of->kn);
>  	rc =3D ops->mmap(of, vma);
> +	if (rc)
> +		goto out_put;
> =20
>  	/*
>  	 * PowerPC's pci_mmap of legacy_mem uses shmem_zero_setup()
Hi,
confirmed patch works fine.

Thanks.

greetings
tpowa

--=20
Tobias Powalowski
Archlinux Developer & Package Maintainer (tpowa)
http://www.archlinux.org
tpowa@archlinux.org



--jM6oQsER2Velbkklr2v7ShqAwQ0KNn7fI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTU/wNAAoJEHcd9mJ+32gfd7EIAIvCpadAzZBYcHOqvQceN1ES
64daq4hkJckwuMZLi/P+USLN7+7dKk5Pr64OF+l1xf/+NSU4I97z4sPedlVkA2x8
UK8kQ28rKVGTKecN3P5MJP/jx7G01F8LzSiebvLAIHDgYZo/eb/TudTXmqulQqjv
1WEihFE1rG079dp+O0B7ggk9Vhz18zaaXMlJFOvrj1Q/v6JdiB7Uu7xZSer3V+zv
BX41ZTy0cLuySuPORRTxZR3KX7AA6Z2zgVNadzCABfbThUHy1A3l/yv9ED2bglfy
sTEbufbay21vN7Hwm0+tqKthViIcZpizTEhaa0oEbpJo8s6zIZA6EQn0JSlDaTA=
=RYu9
-----END PGP SIGNATURE-----

--jM6oQsER2Velbkklr2v7ShqAwQ0KNn7fI--
