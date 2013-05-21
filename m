Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3EUKUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:20:35 -0400
Received: from foo.stuge.se ([212.116.89.98]:56789 "EHLO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab3EUKUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:20:32 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2013 06:20:31 EDT
Message-ID: <20130521101349.30660.qmail@stuge.se>
Date: Tue, 21 May 2013 12:13:49 +0200
From: Peter Stuge <peter@stuge.se>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arch@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pcmcia@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        cluster-devel@redhat.com, linux-mm@kvack.org,
        Hans Verkuil <hans.verkuil@cisco.com>, Pavel Machek <pavel@ucw.cz>,
        Doug Thompson <dougthompson@xmission.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Whitehouse <swhiteho@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org
Subject: Re: [PATCH] Finally eradicate CONFIG_HOTPLUG
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-arch@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Russell King <linux@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>, linux-pm@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-pcmcia@lists.infradead.org,
	LKML <linux-kernel@vger.kernel.org>, cluster-devel@redhat.com,
	linux-mm@kvack.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Pavel Machek <pavel@ucw.cz>,
	Doug Thompson <dougthompson@xmission.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Whitehouse <swhiteho@redhat.com>,
	linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org
References: <20130521134935.d18c3f5c23485fb5ddabc365@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20130521134935.d18c3f5c23485fb5ddabc365@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Are you changing the code to have HOTPLUG always -on- or -off- ?

=46rom the commit message I had expected always -on-.


Stephen Rothwell wrote:
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -68,14 +68,6 @@
>   * are handled as text/data or they can be discarded (which
>   * often happens at runtime)
>   */
> -#ifdef CONFIG_HOTPLUG
> -#define DEV_KEEP(sec)    *(.dev##sec)
> -#define DEV_DISCARD(sec)
> -#else
> -#define DEV_KEEP(sec)
> -#define DEV_DISCARD(sec) *(.dev##sec)
> -#endif
> -
>  #ifdef CONFIG_HOTPLUG_CPU
>  #define CPU_KEEP(sec)    *(.cpu##sec)
>  #define CPU_DISCARD(sec)
> @@ -182,8 +174,6 @@
>  	*(.data)							\
>  	*(.ref.data)							\
>  	*(.data..shared_aligned) /* percpu related */			\
> -	DEV_KEEP(init.data)						\
> -	DEV_KEEP(exit.data)						\
=2E.
> @@ -503,7 +489,6 @@
>  /* init and exit section handling */
>  #define INIT_DATA							\
>  	*(.init.data)							\
> -	DEV_DISCARD(init.data)						\

Shouldn't the effect of one of the above remain?


//Peter

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFRm0jdhR3Q0dhIfEgRAtAtAKDxeofcdUGqWjn2AyXb/CxbZP4X8ACgvEte
zomgM5roARu65KybTU/PIcM=
=bMNu
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
