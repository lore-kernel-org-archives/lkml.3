Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab3JPDuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 23:50:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44227 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab3JPDuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 23:50:08 -0400
Date: Wed, 16 Oct 2013 14:49:54 +1100
From: NeilBrown <neilb@suse.de>
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: Fix skipping recovery for read-only arrays.
Message-ID: <20131016144954.5eb8a689@notabene.brown>
In-Reply-To: <20131007142551.14867.36809.stgit@gklab-154-244.igk.intel.com>
References: <20131007142551.14867.36809.stgit@gklab-154-244.igk.intel.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9THdEqY5EJUGN5nS.kwAauA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/9THdEqY5EJUGN5nS.kwAauA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 07 Oct 2013 16:25:51 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> Since:
>         commit 7ceb17e87bde79d285a8b988cfed9eaeebe60b86
>         md: Allow devices to be re-added to a read-only array.
>=20
> spares are activated on a read-only array. In case of raid1 and raid10
> personalities it causes that not-in-sync devices are marked in-sync
> without checking if recovery has been finished.
>=20
> If a read-only array is degraded and one of its devices is not in-sync
> (because the array has been only partially recovered) recovery will be sk=
ipped.
>=20
> This patch adds checking if recovery has been finished before marking a d=
evice
> in-sync for raid1 and raid10 personalities. In case of raid5 personality
> such condition is already present (at raid5.c:6029).
>=20
> Bug was introduced in 3.10 and causes data corruption.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  drivers/md/raid1.c  |    1 +
>  drivers/md/raid10.c |    1 +
>  2 files changed, 2 insertions(+)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index d60412c..aacf6bf 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1479,6 +1479,7 @@ static int raid1_spare_active(struct mddev *mddev)
>  			}
>  		}
>  		if (rdev
> +		    && rdev->recovery_offset =3D=3D MaxSector
>  		    && !test_bit(Faulty, &rdev->flags)
>  		    && !test_and_set_bit(In_sync, &rdev->flags)) {
>  			count++;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index df7b0a0..73dc8a3 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1782,6 +1782,7 @@ static int raid10_spare_active(struct mddev *mddev)
>  			}
>  			sysfs_notify_dirent_safe(tmp->replacement->sysfs_state);
>  		} else if (tmp->rdev
> +			   && tmp->rdev->recovery_offset =3D=3D MaxSector
>  			   && !test_bit(Faulty, &tmp->rdev->flags)
>  			   && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
>  			count++;

Applied - thanks.

I'll forward it to Linus and -stable shortly.

NeilBrown

--Sig_/9THdEqY5EJUGN5nS.kwAauA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUl4M4jnsnt1WYoG5AQJsMQ//eP0JalczBf1BYAvlRDffokMCJLlaDOsp
qZwgfZoAU4YOkp0VDffPlnZQMIsOWAuUrgmCdor7XUrDbhg2aCUPOWD7rs/iX/iK
f01+UBrSM+Ei6PQoPl6nLI36f5RBQDahJlVljJvN+JqST6xjQ1KEdneSQ/l41ZJe
0Q0OK4dO4DxJMhKzjYPh4fKDRJkDPnouRzHpvfP72E/XS6Y14oIxUIUP1qaqxoYc
ioItnfNKhqdcRCCYH8QiBpY47GO0gFMlipfYRZ3/m48hCJRZ6iV4k/Atet8UaZVC
DdpsYD7bK8KJNQT8nWxJRfdk53p0AFFiM/pfqnkqjqwnR8hQ4kqMRC+5qWE5ThRh
gHpKwAVqK6q3HoIwVNpph18SA6yjmurn5hOG5gLIjpw9F0lA2tMSnR4pWIL8S+yQ
YN0ApXz++M9nLWe1vy5U2c9mocxW6n8xcWbpdzi4W7NyNV0Ep5WOcy0SPRoWizDG
Pu3xMt3IjG22TuAhS3DxQSPM06n/ZB1meYY8a9z7G4NWJMnzTPtTZ3+FnyzZwHfq
dNUD4lSF77JAWhx5OMye+mHFbQWRsK05VDFR7Ey3U1Js7IQm5B6DmUzZ9Q+XP7x0
KrEqQyJIbs+aax36cix2+65NzppEsJtDlQW1h5WSH6+Mx28yQ6f0f5AjYxfs/txv
sVTV2lFdIf4=
=XAup
-----END PGP SIGNATURE-----

--Sig_/9THdEqY5EJUGN5nS.kwAauA--
