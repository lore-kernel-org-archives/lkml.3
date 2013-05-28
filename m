Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964831Ab3E1RdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:33:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46801 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934735Ab3E1RdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:33:01 -0400
Date: Tue, 28 May 2013 20:32:15 +0300
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/3] usb: dwc3: omap Modify dwc3_omap_readl/writel with
 offsets
Message-ID: <20130528173215.GB15794@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1369641777-4509-1-git-send-email-george.cherian@ti.com>
 <1369641777-4509-4-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
In-Reply-To: <1369641777-4509-4-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, May 27, 2013 at 01:32:57PM +0530, George Cherian wrote:
> This patch modifies dwc3_omap_readl/writel calls to accomodate
> both OMAP5 and AM437x reg maps (It uses the cached register offsets).
> Also renames OMAP5 IRQ1 as IRQMISC, IRQ1 bits as IRQMISC bits.
>=20
> Signed-off-by: George Cherian <george.cherian@ti.com>

can you change this patch a bit so that it adds wrappers around
dwc3_omap_*() ? The idea is the have the code look like:

static u32 dwc3_omap_read_utmi_status(struct dwc3_omap *omap)
{
	return dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS +
			omap->utmi_otg_offset);
}

(likewise for write and for all other offsets, of course)

that way, reading/writing to registers which need the offset will be
less error-prone and th driver will look a little nicer.

--=20
balbi

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRpOoeAAoJEIaOsuA1yqREQBQP+QE5A4V3wSjxx/OUvWjbHuhJ
lenRJjh5sOP75CaV/OdUT+nR2Lh/I2BbXxpInrOYqlHIufN6opotNXHs7i6zUc5O
3fs71Pn8gxaMUu48UoAPTVsk2uD5LsrS+ll2nY5mLzkmeZPMZUhdWwNKflLVLOtN
RJSjhBEtDSeDTWTzeXWzr4IreV9XluUH36Umgsh//q/l2c/PfA5lfRQLm7E0xHc0
5Cy9VwugIxW1hcqBRqC/gqRpUuq0RUY/1J6JKsk160xVR3Nia2imoSJyqi7wNwUX
ciqj8YSYbESuyjmsv+GCsjtzlildmyzf4SfH5lzjLGymI8pRPLPwsExMCJal5MLB
YZuyXWOs3f+MYrVbcL04axIubx0yBfQJc9OwH+dADpcjE0JrJmeFEwiFISC393Cm
b1raMNXkgXlh6s9xd5m/A+h+wrTdMkXfv3zepCQJIWMUGNiceVdNyXff/wWF1WN+
RiZ7Yf0pEEFB0i6G/sBaj1fgIyMEbLV3Cu2i/MrYwMTwRkeZBDAG0fzIGXhgB+CE
TsINcz+B409/0lNK3HhBUUdevhD7O6VrPnBzkgM6zj92waEnhwZ0HeV9spUWVs3E
pgTyMUuoMOO7IcMkI4scoO/+Pk+srh/jtuZHaKziAx2SxKe35JGbvUqvyLctscNg
Aqs0tEaISoVGN7cyaHrA
=K91l
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
