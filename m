Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbbAXVsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 16:48:18 -0500
Received: from netz39.de ([78.46.22.20]:48017 "EHLO mail.netz39.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbbAXVsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 16:48:13 -0500
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Jan 2015 16:48:12 EST
X-Spam-Report: -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	0.0 URIBL_BLOCKED          ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	See
	http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	for more information.
	[URIs: netz39.de]
	-1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
From: Stefan Haun <tux@netz39.de>
Organization: Netz39 e.V.
To: y@mail.netz39.de
Subject: Re: [PATCH 2/2] fs: fix checkpatch code warnings for inotify
Date: Sat, 24 Jan 2015 22:39:04 +0100
User-Agent: KMail/1.13.7 (Linux/3.19.0-rc4+; KDE/4.8.4; x86_64; ; )
Cc: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org
References: <1421421311-4475-1-git-send-email-y> <1421421311-4475-2-git-send-email-y>
In-Reply-To: <1421421311-4475-2-git-send-email-y>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1676826.lU7HgFF2q8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501242239.13739.tux@netz39.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1676826.lU7HgFF2q8
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I just noticed that I failed in setting the right From: header. Sorry for=20
this, I will re-post the patches with correct meta-data set.


Am Freitag, 16. Januar 2015, 16:15:11 schrieb y@mail.netz39.de:
> From: Stefan Haun <tux@netz39.de>
>=20
> ./fs/notify/inotify/inotify.h:23:
> CHECK: extern prototypes should be avoided in .h files
> ./fs/notify/inotify/inotify.h:25:
> CHECK: extern prototypes should be avoided in .h files
>=20
> 	Removed extrn keywords; the matter, however, seems to be an open
> 	debate.
>=20
> ./fs/notify/inotify/inotify_fsnotify.c:140:
> ERROR: do not initialise statics to 0 or NULL
>=20
> 	Replace the initialization by a comment:
> 	Compiler takes care of the proper initialization.
>=20
> ./fs/notify/inotify/inotify_fsnotify.c:159:
> WARNING: Prefer [subsystem eg: netdev]_warn([subsystem]dev, ... then
> dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
> ./fs/notify/inotify/inotify_user.c:473:
> WARNING: Prefer [subsystem eg: netdev]_err([subsystem]dev, ... then
> dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> ./fs/notify/inotify/inotify_user.c:474:
> WARNING: quoted string split across lines
>=20
> 	Use pr_warn instead of printk and fix line break.
>=20
> ./fs/notify/inotify/inotify_user.c:645:
> CHECK: Prefer kmalloc(sizeof(*oevent)...) over
> kmalloc(sizeof(struct inotify_event_info)...)
>=20
> 	Done that (complies to coding stlye).
>=20
> Signed-off-by: Stefan Haun <tux@netz39.de>
> ---
>  fs/notify/inotify/inotify.h          |   16 ++++++++--------
>  fs/notify/inotify/inotify_fsnotify.c |    6 +++---
>  fs/notify/inotify/inotify_user.c     |    8 ++++----
>  3 files changed, 15 insertions(+), 15 deletions(-)
>=20
> diff --git a/fs/notify/inotify/inotify.h b/fs/notify/inotify/inotify.h
> index ed855ef..9d6d4e2 100644
> --- a/fs/notify/inotify/inotify.h
> +++ b/fs/notify/inotify/inotify.h
> @@ -20,13 +20,13 @@ static inline struct inotify_event_info
> *INOTIFY_E(struct fsnotify_event *fse) return container_of(fse, struct
> inotify_event_info, fse);
>  }
>=20
> -extern void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mar=
k,
> -					   struct fsnotify_group *group);
> -extern int inotify_handle_event(struct fsnotify_group *group,
> -				struct inode *inode,
> -				struct fsnotify_mark *inode_mark,
> -				struct fsnotify_mark *vfsmount_mark,
> -				u32 mask, void *data, int data_type,
> -				const unsigned char *file_name, u32 cookie);
> +void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
> +				    struct fsnotify_group *group);
> +
> +int inotify_handle_event(struct fsnotify_group *group, struct inode
> *inode, +			 struct fsnotify_mark *inode_mark,
> +			 struct fsnotify_mark *vfsmount_mark,
> +			 u32 mask, void *data, int data_type,
> +			 const unsigned char *file_name, u32 cookie);
>=20
>  extern const struct fsnotify_ops inotify_fsnotify_ops;
> diff --git a/fs/notify/inotify/inotify_fsnotify.c
> b/fs/notify/inotify/inotify_fsnotify.c index 0238615..16efe98 100644
> --- a/fs/notify/inotify/inotify_fsnotify.c
> +++ b/fs/notify/inotify/inotify_fsnotify.c
> @@ -137,7 +137,7 @@ static int idr_callback(int id, void *p, void *data)
>  {
>  	struct fsnotify_mark *fsn_mark;
>  	struct inotify_inode_mark *i_mark;
> -	static bool warned =3D false;
> +	static bool warned; /* =3D false;  default by GCC */
>=20
>  	if (warned)
>  		return 0;
> @@ -156,8 +156,8 @@ static int idr_callback(int id, void *p, void *data)
>  	 * BUG() that was here.
>  	 */
>  	if (fsn_mark)
> -		printk(KERN_WARNING "fsn_mark->group=3D%p inode=3D%p wd=3D%d\n",
> -		       fsn_mark->group, fsn_mark->inode, i_mark->wd);
> +		pr_warn("fsn_mark->group=3D%p inode=3D%p wd=3D%d\n",
> +			fsn_mark->group, fsn_mark->inode, i_mark->wd);
>  	return 0;
>  }
>=20
> diff --git a/fs/notify/inotify/inotify_user.c
> b/fs/notify/inotify/inotify_user.c index 3214e2b..d7e3e58 100644
> --- a/fs/notify/inotify/inotify_user.c
> +++ b/fs/notify/inotify/inotify_user.c
> @@ -470,9 +470,9 @@ static void inotify_remove_from_idr(struct
> fsnotify_group *group, * one ref grabbed by inotify_idr_find
>  	 */
>  	if (unlikely(atomic_read(&i_mark->fsn_mark.refcnt) < 3)) {
> -		printk(KERN_ERR "%s: i_mark=3D%p i_mark->wd=3D%d i_mark->group=3D%p"
> -			" i_mark->inode=3D%p\n", __func__, i_mark, i_mark->wd,
> -			i_mark->fsn_mark.group, i_mark->fsn_mark.inode);
> +		pr_err("%s: i_mark=3D%p i_mark->wd=3D%d i_mark->group=3D%p
> i_mark->inode=3D%p\n", +		       __func__, i_mark, i_mark->wd,
> i_mark->fsn_mark.group,
> +		       i_mark->fsn_mark.inode);
>  		/* we can't really recover with bad ref cnting.. */
>  		BUG();
>  	}
> @@ -642,7 +642,7 @@ static struct fsnotify_group
> *inotify_new_group(unsigned int max_events) if (IS_ERR(group))
>  		return group;
>=20
> -	oevent =3D kmalloc(sizeof(struct inotify_event_info), GFP_KERNEL);
> +	oevent =3D kmalloc(sizeof(*oevent), GFP_KERNEL);
>  	if (unlikely(!oevent)) {
>  		fsnotify_destroy_group(group);
>  		return ERR_PTR(-ENOMEM);


=2D-=20
Netz39 e.V. - Real World Virtuality                http://www.netz39.de
Stefan Haun                                               tux@netz39.de


E-Mail: kontakt@netz39.de

Vertretungsberechtigter Vorstand: Ren=C3=A9 Meye, Sebastian Mai
Inhaltlich verantwortlich gem=C3=A4=C3=9F =C2=A755 (2) RStV: Ren=C3=A9 Meye

Registergericht: Amtsgericht Stendal
Registernummer:  VR 3169


Disclaimer:   Diese E-Mail ist in keiner Form b=C3=B6se oder beleidigend ge-
meint. Sollte sie an Stellen doch so sein, dann sage mir das bitte. Ich=20
werde Dein Feedback annehmen und nur beantworten, falls Du es ausdr=C3=BCck-
lich w=C3=BCnschst.

--nextPart1676826.lU7HgFF2q8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJUxBD4AAoJEFRUU2UON0vb4scQAL7BM6+7vJ8MidxrOzKWbVzA
n4a7MOM83m9+nVDy9D1r2OqtzXxMKzbkFHYo73qZSb6c00FdFjFvngNhBuBv0/aY
ddl4yZ+zptqznJ9EizXHSbRompB4V6iRDjlGxuZv88smirt0RDTO1IxggBqc/nds
qFX63tB3HwdjKKmKYRwb46FIFaEjW9mY7UxMnX1KWa8cMtqvxWbQ8njMC/nH+3rX
63L9M4+xByqOmSJ/A6VpZDR49Zm9LTvquqfvmbPbUONVrSDIcriTWl2MF4FoaN2I
Yk2vD4/f98vBzRYKEodgt9fJTLcII3v0uzzRVLnZA3zaDRlSys/rOqAuvnsgTXtX
kIFWrQcDAkshUWZrm4jAP50sDpt+NHGnGPDnvV4+RoAISF1oeMKqyG/9gAXZszAj
6D1JJDuU7EuVJsrR3du6Fm5zQL+jcipFL61e0Y3CpbqRqQrXpGcr5JeuOOrg5YFt
qs5gHD2Yh/fqdCP0cAltjOIoh/Spu/gjr1cLA2EOkMUH4ramIhixRejhUwCBbzoL
nUmdO13fD+IlQ7lBQEFUZDcVN1bemtgEwkUH8fEJkmjLgpyRMXIitxyjrHCzRpvO
48W8HbHykzLW02gOXlA+JXCedKf3VqElpl14WJRJro4KqReYaxK0OVn0+vfJ0TyK
2J1DNboVHGLUyLQKoqkh
=87cZ
-----END PGP SIGNATURE-----

--nextPart1676826.lU7HgFF2q8--
