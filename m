Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3COBfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 21:35:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37045 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752989Ab3COBfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 21:35:41 -0400
Date: Fri, 15 Mar 2013 01:35:34 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regmap: Cut down on the average # of nodes in the
 rbtree cache
Message-ID: <20130315013534.GF4931@opensource.wolfsonmicro.com>
References: <1363272755-6179-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4f28nU6agdXSinmL"
Content-Disposition: inline
In-Reply-To: <1363272755-6179-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4f28nU6agdXSinmL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 14, 2013 at 02:52:35PM +0000, Dimitris Papastamos wrote:

>  	if (rbnode) {
>  		reg_tmp = (reg - rbnode->base_reg) / map->reg_stride;
> +		/* Does this register exist?  If not bail out. */
> +		if (!(rbtree_ctx->reg_present[BIT_WORD(reg)] & BIT_MASK(reg)))
> +			return -ENOENT;
>  		*value = regcache_rbtree_get_register(map, rbnode, reg_tmp);

This means that every caller is going to need to have a check added to
see if the register is present which doesn't seem great, we should at
least have a function to do the check.  The check is fiddly enough.

--4f28nU6agdXSinmL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQnrSAAoJELSic+t+oim9T5sP/2XiAXQC6AmeCA9jK2Y1Vd06
PpMBnOETgA3XJJ002YyB/OAOVSJ19di+AONGbqUTFMyxt+o4XaT+tNPFlaxXSReH
4dVEC7g3d4fbQnRkYOOTs06oJ3SsapZF+xVsOen+i9qKhxk5AC3KAvd94oyhFh2S
bxYe8VncS2kEiS2zaSrUiStgToaEtu/oTF74nCBCppVsBnC2n6bk/zDV43VRZSl5
ijQOL23YoJH04EojZrvvKLpLS5ubt/5J7n+4Tcx3JFJ7XWLV/Vo4diimaWY75tiK
ZHyIFqyzrjulSOlSd/Ui0dC3NX8rtZyrda7Kt2MNQnOcjahbxD9B41mJudLxpwTB
V/Lw2CFxC0h/ZwmcROZES66cS0ZoHBFe1HFvJtntxMuj3F+BMGauI5T2DqplF6fG
gUmF36oKWpcCahVBaOB4dNNcF4c6poTY+DJ7ToaN0QEeBda10uxQVsqR0+qXla6K
9nASvcTkGXozJokQwVvq5zv4RU5KH85gor0PUNBRbmgg7uT5OAL/bzhSzfKAMUwj
dnzot1DeB/D/CNC/xZeTTFEc8NLg0+F1c5HoP2hlvlFsugoo4b6QQ2Kh27YEJJxC
VqrjKR1hD4YEjCB6DKNOTG4bsrrugmeWy+u0z8xIyRaPB4ZwI6zNRIulI7xyjqdL
5dh5HSA+1wxvka0WTS6D
=troq
-----END PGP SIGNATURE-----

--4f28nU6agdXSinmL--
