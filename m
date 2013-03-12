Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab3CLBgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 21:36:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab3CLBgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 21:36:47 -0400
Date: Tue, 12 Mar 2013 12:36:30 +1100
From: NeilBrown <neilb@suse.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] md/raid456: remove depends on CONFIG_EXPERIMENTAL
Message-ID: <20130312123630.36df75da@notabene.brown>
In-Reply-To: <1362997664.3137.52.camel@x61.thuisdomein>
References: <20130223074001.GA5199@www.outflux.net>
	<CAA9_cmfa1hhijh4g_hSwMy_GR81rxjEFMurJwSvhBruh1R5dtw@mail.gmail.com>
	<20130228091110.7da87b53@notabene.brown>
	<1362997664.3137.52.camel@x61.thuisdomein>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xj5Yz6NJqb9.XvN6tYAc.uw"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xj5Yz6NJqb9.XvN6tYAc.uw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Mar 2013 11:27:44 +0100 Paul Bolle <pebolle@tiscali.nl> wrote:

> > Following will be in -next shortly.
> >=20
> > NeilBrown
> >=20
> >=20
> > From 51acbcec6c42b24482bac18e42befc822524535d Mon Sep 17 00:00:00 2001
> > From: NeilBrown <neilb@suse.de>
> > Date: Thu, 28 Feb 2013 09:08:34 +1100
> > Subject: [PATCH] md: remove CONFIG_MULTICORE_RAID456
> >=20
> > This doesn't seem to actually help and we have an alternate
> > multi-threading approach waiting in the wings, so just get
> > rid of this config option and associated code.
> >=20
> > As a bonus, we remove one use of CONFIG_EXPERIMENTAL
> >=20
> > Cc: Dan Williams <djbw@fb.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> That commit entered mainline in v3.9-rc2 (still as commit
> 51acbcec6c42b24482bac18e42befc822524535d). It missed one instance of
> CONFIG_MULTICORE_RAID456, so this additional patch is needed (which also
> cleans that macro from two defconfig files). Compile tested, by the way.
>=20
>=20
> Paul Bolle

Thanks Paul.

I'll send this off to Linus some time in the next week or so.


Thanks,
NeilBrown


>=20
> >From ab10e19eeca5ae271ae965418ff736db0230aab6 Mon Sep 17 00:00:00 2001
> From: Paul Bolle <pebolle@tiscali.nl>
> Date: Mon, 11 Mar 2013 11:16:25 +0100
> Subject: [PATCH] md: remove CONFIG_MULTICORE_RAID456 entirely
>=20
> Once instance of this Kconfig macro remained after commit
> 51acbcec6c42b24482bac18e42befc822524535d ("md: remove
> CONFIG_MULTICORE_RAID456"). Remove that one too. And, while we're at it,
> also remove it from the defconfig files that carry it.
>=20
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  arch/tile/configs/tilegx_defconfig  | 1 -
>  arch/tile/configs/tilepro_defconfig | 1 -
>  drivers/md/raid5.h                  | 4 ----
>  3 files changed, 6 deletions(-)
>=20
> diff --git a/arch/tile/configs/tilegx_defconfig b/arch/tile/configs/tileg=
x_defconfig
> index 8c5eff6..4768481 100644
> --- a/arch/tile/configs/tilegx_defconfig
> +++ b/arch/tile/configs/tilegx_defconfig
> @@ -330,7 +330,6 @@ CONFIG_MD_RAID0=3Dm
>  CONFIG_MD_RAID1=3Dm
>  CONFIG_MD_RAID10=3Dm
>  CONFIG_MD_RAID456=3Dm
> -CONFIG_MULTICORE_RAID456=3Dy
>  CONFIG_MD_FAULTY=3Dm
>  CONFIG_BLK_DEV_DM=3Dm
>  CONFIG_DM_DEBUG=3Dy
> diff --git a/arch/tile/configs/tilepro_defconfig b/arch/tile/configs/tile=
pro_defconfig
> index e7a3dfc..dd2b8f0 100644
> --- a/arch/tile/configs/tilepro_defconfig
> +++ b/arch/tile/configs/tilepro_defconfig
> @@ -324,7 +324,6 @@ CONFIG_MD_RAID0=3Dm
>  CONFIG_MD_RAID1=3Dm
>  CONFIG_MD_RAID10=3Dm
>  CONFIG_MD_RAID456=3Dm
> -CONFIG_MULTICORE_RAID456=3Dy
>  CONFIG_MD_FAULTY=3Dm
>  CONFIG_BLK_DEV_DM=3Dm
>  CONFIG_DM_DEBUG=3Dy
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 18b2c4a..31e2ec1 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -221,10 +221,6 @@ struct stripe_head {
>  	struct stripe_operations {
>  		int 		     target, target2;
>  		enum sum_check_flags zero_sum_result;
> -		#ifdef CONFIG_MULTICORE_RAID456
> -		unsigned long	     request;
> -		wait_queue_head_t    wait_for_ops;
> -		#endif
>  	} ops;
>  	struct r5dev {
>  		/* rreq and rvec are used for the replacement device when


--Sig_/xj5Yz6NJqb9.XvN6tYAc.uw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUT6Gnjnsnt1WYoG5AQIcVQ//eM7QYT4BJ2p3U1YXkRvxJBlSqt321NLJ
HOhHlpZNwIYG5bUlD7GkYiLbotYKMF2QUv8l3ERzXGoumJr11shGkDIV/1NgmmUd
QHHWxIVw0pJ6hN7bRsMoUokLREhdAiw5t0HlX1NRLkN1mVfQ1HcDI8+zNgochE05
Pwg0YyeFEF+2GgZudg2YPn/MSwMRyDKV9O3+tJdaky13JHToNO2XSt6QL+S7deGd
NOOIPt5oPnAKCEmflVMkDryHMe5+TUOQ6589Bue3hnhvwC2DplxeOktmD4+QxR8c
+tV4BQL2QZWbLYuKVNxZ9qkJhp7F1BESXUZqCYPHS6PsP68vKml75vTJeoTQunwW
f/hxRaLnXadIGJ18hBjmUAwQsz0b0R2CCKUkVEfvcCEwmVyLFJaZV4cfmXimSObX
ZCaBA0T2NxTUs9LTdgv0zw1UOwXWcf1al8bqZ65Ap113iMJcY8TFOz0vGlVeqQ9j
9pXy511XELWbfS/8xHS7PrB5xtJOoTmyy3p79l58oIo+4MPYUE7DugKtPXTREGHa
GFyM5qoK0CI6cYYJhucwYm9KZbbxDpkNfBr/daJi/Ux4/ZaSMBzZHSu74BzlIQKs
rQz/sBRrVAB3hvR9WSW+7GZP2p/Owk/mJ4FD9hQAOZM1aoy3bQMOoOFJ4c8dw2/B
AIxI2J5KItM=
=0XQW
-----END PGP SIGNATURE-----

--Sig_/xj5Yz6NJqb9.XvN6tYAc.uw--
