Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbaJNBwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 21:52:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbaJNBwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 21:52:08 -0400
Date: Tue, 14 Oct 2014 12:51:58 +1100
From: NeilBrown <neilb@suse.de>
To: Anton Blanchard <anton@samba.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/raid6: Add log level to printks
Message-ID: <20141014125158.29d77b3e@notabene.brown>
In-Reply-To: <20141013230316.1cbe1b7e@kryten>
References: <20141013230316.1cbe1b7e@kryten>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/5qSuKuf+Tl.O6p8w4HzprN5"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5qSuKuf+Tl.O6p8w4HzprN5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Oct 2014 23:03:16 +1100 Anton Blanchard <anton@samba.org> wrote:

>=20
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
>=20
> Index: b/lib/raid6/algos.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -121,9 +121,9 @@ static inline const struct raid6_recov_c
>  		raid6_2data_recov =3D best->data2;
>  		raid6_datap_recov =3D best->datap;
> =20
> -		printk("raid6: using %s recovery algorithm\n", best->name);
> +		pr_info("raid6: using %s recovery algorithm\n", best->name);
>  	} else
> -		printk("raid6: Yikes! No recovery algorithm found!\n");
> +		pr_err("raid6: Yikes! No recovery algorithm found!\n");
> =20
>  	return best;
>  }
> @@ -157,18 +157,18 @@ static inline const struct raid6_calls *
>  				bestperf =3D perf;
>  				best =3D *algo;
>  			}
> -			printk("raid6: %-8s %5ld MB/s\n", (*algo)->name,
> +			pr_info("raid6: %-8s %5ld MB/s\n", (*algo)->name,
>  			       (perf*HZ) >> (20-16+RAID6_TIME_JIFFIES_LG2));
>  		}
>  	}
> =20
>  	if (best) {
> -		printk("raid6: using algorithm %s (%ld MB/s)\n",
> +		pr_info("raid6: using algorithm %s (%ld MB/s)\n",
>  		       best->name,
>  		       (bestperf*HZ) >> (20-16+RAID6_TIME_JIFFIES_LG2));
>  		raid6_call =3D *best;
>  	} else
> -		printk("raid6: Yikes!  No algorithm found!\n");
> +		pr_err("raid6: Yikes!  No algorithm found!\n");
> =20
>  	return best;
>  }
> @@ -194,7 +194,7 @@ int __init raid6_select_algo(void)
>  	syndromes =3D (void *) __get_free_pages(GFP_KERNEL, 1);
> =20
>  	if (!syndromes) {
> -		printk("raid6: Yikes!  No memory available.\n");
> +		pr_err("raid6: Yikes!  No memory available.\n");
>  		return -ENOMEM;
>  	}
> =20


Applied - thanks.

NeilBrown

--Sig_/5qSuKuf+Tl.O6p8w4HzprN5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVDyBvjnsnt1WYoG5AQIlCQ/8CALX+LN/6RTi8bRLf91Ax1U4oBUt1HuT
xixeX9wqz5UT7nRtj7guOAKIkjmR5iCYYedh6wh7DsLj8EmQYSlZiyePhikklKc7
3GwndvUFGjrq99sP47FAMR+0bGpfPIyV0A+eZDFl8vxHVVuWJfyVJ1Cv1K99JkHw
1L7+8bCRaswUPcVemgqf5CTrr4H8n9XZUZ1JrVXx6QKfZOGMQfQ/atOdbIfweoHQ
SgGpLe8/QW9L+WJUaAc0Vs5dUxccOYx3A9YXXDZrl0Ac6AmL7zMzFQsL4DLdUEsl
RXcaQV1M0fuMvZSzeKb9Y7R7cxTksrhBSQWDu1besdYZ/aGlJwtSGcTyh9QLGhoG
D1q6tidCvma1y/BsT8RmWlbuUVCZg8foGg1+WnyhyQqZqX75SQUifmLGYMuU1rl2
9owBrQfrryz2yY6O3Dn6amGK+5aNhkMOiK+bC3U359V4toLE3zJZQrb3qFyOgB6c
4QaIo8EAgMDqmYRX4F9knrKAmTwziayfZeTkhUNjcvV3rPS6TnIUvGeK743ZQ3wm
PeCp66xY3zqhpULuCSkTSJqMVB6tOZgTCUB0nCwV0kUcugIsL1f6KjTRx1BgA6Ef
LQkUImy5zDlNgzCG4hMWWo5LqFIXkkJNSPEAWEscLeTMl0+1MW7omsTKEe2Ecl/8
eEu93UZ+JGE=
=CgbV
-----END PGP SIGNATURE-----

--Sig_/5qSuKuf+Tl.O6p8w4HzprN5--
