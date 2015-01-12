Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750963AbbALFDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 00:03:10 -0500
Received: from ozlabs.org ([103.22.144.67]:59106 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbbALFDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 00:03:06 -0500
Date: Mon, 12 Jan 2015 16:02:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Andreas =?UTF-8?B?RsODwqRyYmVy?= <afaerber@suse.de>
Subject: linux-next: build failure after merge of the pinctrl tree
Message-ID: <20150112160258.16b8ba3d@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/mi0MqNxZnNJwRPE3lxMDt6D"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/mi0MqNxZnNJwRPE3lxMDt6D
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the pinctrl tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/pinctrl/pinconf-generic.c: In function 'pinconf_generic_dump_pins':
drivers/pinctrl/pinconf-generic.c:116:19: error: 'struct pinctrl_desc' has =
no member named 'num_dt_params'
  if (pctldev->desc->num_dt_params && pctldev->desc->conf_items)
                   ^
drivers/pinctrl/pinconf-generic.c:116:51: error: 'struct pinctrl_desc' has =
no member named 'conf_items'
  if (pctldev->desc->num_dt_params && pctldev->desc->conf_items)
                                                   ^
drivers/pinctrl/pinconf-generic.c:118:20: error: 'struct pinctrl_desc' has =
no member named 'conf_items'
       pctldev->desc->conf_items,
                    ^
drivers/pinctrl/pinconf-generic.c:119:20: error: 'struct pinctrl_desc' has =
no member named 'num_dt_params'
       pctldev->desc->num_dt_params);
                    ^
drivers/pinctrl/pinconf-generic.c: In function 'pinconf_generic_dump_config=
':
drivers/pinctrl/pinconf-generic.c:134:20: error: 'struct pinctrl_desc' has =
no member named 'num_dt_params'
  if (!pctldev->desc->num_dt_params || !pctldev->desc->conf_items)
                    ^
drivers/pinctrl/pinconf-generic.c:134:53: error: 'struct pinctrl_desc' has =
no member named 'conf_items'
  if (!pctldev->desc->num_dt_params || !pctldev->desc->conf_items)
                                                     ^
drivers/pinctrl/pinconf-generic.c:137:31: error: 'struct pinctrl_desc' has =
no member named 'num_dt_params'
  for (i =3D 0; i < pctldev->desc->num_dt_params; i++) {
                               ^
drivers/pinctrl/pinconf-generic.c:138:55: error: 'struct pinctrl_desc' has =
no member named 'conf_items'
   if (pinconf_to_config_param(config) !=3D pctldev->desc->conf_items[i].pa=
ram)
                                                       ^
drivers/pinctrl/pinconf-generic.c:140:42: error: 'struct pinctrl_desc' has =
no member named 'conf_items'
   seq_printf(s, "%s: 0x%x", pctldev->desc->conf_items[i].display,
                                          ^

Caused by commit dd4d01f7bad8 ("pinctrl: pinconf-generic: Allow driver
to specify DT params").  This build does not have CONFIG_OF set.

I have used the pinctrl tree from next-20150109 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/mi0MqNxZnNJwRPE3lxMDt6D
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUs1WHAAoJEMDTa8Ir7ZwVg3kP/0wiCPF6LPECRguYqhyBhG8D
ctjrqPJLri2OIzHZeyeipX/8MRTiactgiDVv9DRJ/mPMeUVWMzJvR4oxs9vmRkgj
K9d+NiETzBXCy8Ygnd9w17jTVCX/DY8UwAsD7NGg27fb0q3H/2e+Rjre9sTAcnDH
wCdkwNiscjRDWO3TX+H+qshv4O09FJnCUctt6Kk8sW52854bzHWjPE6VTdXS7sAI
gi+zu+s9q/ADGlgyRmlHwdoG6U7SxlQbBrPQDg8McmhfGkHTmJtoUNHBYzaJXG+R
4dJL8G4ULMRYReNrhxfJ5wm1Ns7KsmeG650H0v3G45iew6e4EcPZhQ6bpLIH64f4
wlI1u0PfGOqGjUyxDcaGVeAjBwOoqoeu1qvu0Ws5LRaeKsENsop+8AH/WqDLfxMb
ud3RZ25dukZhN0GmIZmE+iSgzN+48+mDXHj6b4040uEzfUknHOqnpqTnHFa6j1I8
651vITHWHZ2c+Wriv7t0JWJ/Zmb9+rC1BeAwIz0Fa+2ce34QQkonH0Yi5OtXt3r+
X9O3lcRc6Ioho4fZ4Ge3DACWQdLocFyllLSSCoF95eTBeSXXPZyd2QYb/K2Jrh/5
M6vACGM75AU4vF89qliFwyYVTPZb/dC1Lt+AVBYPtsW0Mwn2M1o346jvOODxdHDg
APR6t1PZE1SoRV2y6Y8b
=y45M
-----END PGP SIGNATURE-----

--Sig_/mi0MqNxZnNJwRPE3lxMDt6D--
