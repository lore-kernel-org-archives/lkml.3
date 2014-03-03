Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaCCARE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:17:04 -0500
Received: from ozlabs.org ([203.10.76.45]:36132 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbaCCARB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:17:01 -0500
Date: Mon, 3 Mar 2014 11:16:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH -next] cris: cpuinfo_op should depend on CONFIG_PROC_FS
Message-Id: <20140303111654.b300a91b38024e3c28811e95@canb.auug.org.au>
In-Reply-To: <1393756479-12530-1-git-send-email-geert@linux-m68k.org>
References: <1393756479-12530-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Mar_2014_11_16_54_+1100_0O9.i0W3ta9iF49t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Mar_2014_11_16_54_+1100_0O9.i0W3ta9iF49t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Sun,  2 Mar 2014 11:34:39 +0100 Geert Uytterhoeven <geert@linux-m68k.org=
> wrote:
>
> Now allnoconfig started disabling CONFIG_PROC_FS:
>=20
>     arch/cris/kernel/built-in.o:(.rodata+0xc): undefined reference to `sh=
ow_cpuinfo'
>     make: *** [vmlinux] Error 1
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Added as a merge fix to (for the akpm-current tree) linux-next from today.

[rest left here for Andrew and Josh ...]

> http://kisskb.ellerman.id.au/kisskb/buildresult/10665698/
>=20
>  arch/cris/kernel/setup.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/arch/cris/kernel/setup.c b/arch/cris/kernel/setup.c
> index 32c3d248868e..905b70ea9939 100644
> --- a/arch/cris/kernel/setup.c
> +++ b/arch/cris/kernel/setup.c
> @@ -165,6 +165,7 @@ void __init setup_arch(char **cmdline_p)
>  	strcpy(init_utsname()->machine, cris_machine_name);
>  }
> =20
> +#ifdef CONFIG_PROC_FS
>  static void *c_start(struct seq_file *m, loff_t *pos)
>  {
>  	return *pos < nr_cpu_ids ? (void *)(int)(*pos + 1) : NULL;
> @@ -188,6 +189,7 @@ const struct seq_operations cpuinfo_op =3D {
>  	.stop  =3D c_stop,
>  	.show  =3D show_cpuinfo,
>  };
> +#endif /* CONFIG_PROC_FS */
> =20
>  static int __init topology_init(void)
>  {
> --=20
> 1.7.9.5

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__3_Mar_2014_11_16_54_+1100_0O9.i0W3ta9iF49t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTE8n6AAoJEMDTa8Ir7ZwVrNYP/i4/VtiWUKUM5VsaGPjU/BFz
83E3ssCMb/fSFlJL38xMiz6N1H2S3rYWS+MNYubB/H+Ni2ioDV5PpNnUSLvEb4Dh
PHOjAEO5xJDHZPB5SISz/XYrtEiLRgAAlnsjHbsruUD4UQGjOJciXmGp3C/YNXHO
kZx4gvsllH9tM/jRH7GMfs9gg2Qhkn3igCtwGrMsY33T8dEqu5jtSJpArZnjLjMy
tg8ez31uXQu2CmLnznqYxcWL/8YIgk1ccIIYflw1leVDGlKeF4iz2B3RRQ020wH2
j7nF8QskiNbyvO8y5el2ZJWeDmQp9BaoV1WRivstDz2fgzZ/tQy9yLUl6IaYx5+g
nTGUCyPe/JhcJkt/S8/7hXYBVEGc5tHW38SJy5aivRYul1hVQf5vxLbiwy/3r8I2
wF696BImch+5K+drBLSHY58UdU/D/xXL/tEeSbTAvMhVm2Px/DSGx75zAvb6Pktw
MequgTEPUy+oRL/SIg2fcNgUyg0LnAphIg67ugomRKE2rwTtTfX0/0HGl1N209DP
8Bvr+TKDXvgqEJIC4NMoZVcLmz3OsgflerkuC+9t3U/9Cywuc7JVNuX2hvStrazT
+rGqYXXXdZJZSa7iear4qA7Js0frH4PJJSyzg/I6zGpcluhIRSeDB9uefaI+HBI1
5fmfP2ssj5nDj0F+Zi27
=9z9Y
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Mar_2014_11_16_54_+1100_0O9.i0W3ta9iF49t--
