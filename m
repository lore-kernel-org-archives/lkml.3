Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab3CDRT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:19:29 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59850 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758523Ab3CDRTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:19:19 -0500
Message-ID: <1362417555.5510.58.camel@mattotaupa>
Subject: Re: [PATCH] md: dm-verity: Fix to avoid a deadlock in dm-bufio
From: Paul Menzel <pm.debian@googlemail.com>
To: Paul Taysom <taysom@chromium.org>
Cc: agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        msb@chromium.org, mpatocka@redhat.com, olofj@chromium.org
Date: Mon, 04 Mar 2013 18:19:15 +0100
In-Reply-To: <1362415549-18653-1-git-send-email-taysom@chromium.org>
References: <1362415549-18653-1-git-send-email-taysom@chromium.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-6xVxZC4vaXKOU7+mguUp"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6xVxZC4vaXKOU7+mguUp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Montag, den 04.03.2013, 08:45 -0800 schrieb Paul Taysom:
> Changed the dm-verity prefetching to use a worker thread to avoid
> a deadlock in dm-bufio.

Do you know of any bug reports about this? Searching for =C2=BBdm-verity de=
ad
lock=C2=AB I found [1], which seems to be the issue, right? If yes, please
reference it.

> If generic_make_request is called recursively, it queues the I/O
> request on the current->bio_list without making the I/O request
> and returns. The routine making the recursive call cannot wait
> for the I/O to complete.
>=20
> The deadlock occurred when one thread grabbed the bufio_client
> mutex and waited for an I/O to complete but the I/O was queued
> on another thread=E2=80=99s current->bio_list and it was waiting to get
> the mutex held by the first thread.
>=20
> The fix allows only one I/O request from dm-verity to dm-bufio
> per thread. To do this, the prefetch requests were queued on worker
> threads.
>=20
> In addition to avoiding the deadlock, this fix made a slight
> improvement in performance.
>=20
> seconds_kernel_to_login:
>   with prefetch:    8.43s
>   without prefetch: 9.2s
>   worker prefetch:  8.28s
>=20
> Signed-off-by: Paul Taysom <taysom@chromium.org>
> ---
>  drivers/md/dm-verity.c | 29 +++++++++++++++++++++++++++--
>  1 file changed, 27 insertions(+), 2 deletions(-)

Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>


Thanks,

Paul


[1] https://code.google.com/p/chromium-os/issues/detail?id=3D39148

--=-6xVxZC4vaXKOU7+mguUp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlE015MACgkQPX1aK2wOHVh4ywCfV6fZq9PARP4vvrn2k0MnnkxM
wekAoIkuco2QjsJpDplLL5FB5igmY2IJ
=2YzE
-----END PGP SIGNATURE-----

--=-6xVxZC4vaXKOU7+mguUp--

