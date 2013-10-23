Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab3JWSdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 14:33:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49173 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab3JWSdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 14:33:38 -0400
Date: Wed, 23 Oct 2013 13:33:34 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <balbi@ti.com>, Alexander Shiyan <shc_work@mail.ru>,
        <gregkh@linuxfoundation.org>, <jslaby@suse.cz>, <ning.li@intel.com>,
        <ivan.gorinov@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 2/2] mrst_max3110: fix SPI UART interrupt parameters
Message-ID: <20131023183334.GB29679@gimli>
Reply-To: <balbi@ti.com>
References: <1382470930-13807-1-git-send-email-david.a.cohen@linux.intel.com>
 <5266E070.2060408@linux.intel.com>
 <5267041F.2090905@linux.intel.com>
 <1382509666.28248007@f107.i.mail.ru>
 <52681128.2010404@linux.intel.com>
 <20131023182143.GK25954@gimli>
 <52681689.2090004@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
Content-Disposition: inline
In-Reply-To: <52681689.2090004@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 23, 2013 at 11:33:45AM -0700, David Cohen wrote:
> On 10/23/2013 11:21 AM, Felipe Balbi wrote:
> >Hi,
> >
> >On Wed, Oct 23, 2013 at 11:10:48AM -0700, David Cohen wrote:
> >>>My idea is always use threaded irq and passing flags into request.
> >>>Like as:
> >>>unsigned long flags =3D res->flags & IORESOURCE_BITS;
> >>>...
> >>>request_threaded_irq(max->irq, serial_m3110_irq, IRQF_ONESHOT | flags,=
 "max3110", max);
> >>
> >>
> >>Oh, maybe we were talking about different things afterall :)
> >>The reason this struct plat_max3110 was created is to allow platform
> >>code (located under arch/x86/platform/intel-mid/device_libs/) to define
> >>the irq edge type.
> >>When I saw your comment I though you were referring to struct resource
> >>(which has IORESOURCE_IRQ_* flags). But unlike platform_device,
> >>spi_device has no struct resource * to replace the need of struct
> >>plat_max3110.
> >>
> >>OTOH your suggestion can replace this piece of code:
> >>
> >>@@ -68,6 +69,7 @@ struct uart_max3110 {
> >>         u8 clock;
> >>         u8 parity, word_7bits;
> >>         u16 irq;
> >>+       u16 irq_edge_triggered;
> >
> >max3110 is already edge triggered:
> >
> >495                 ret =3D request_irq(max->irq, serial_m3110_irq,
> >496                                 IRQ_TYPE_EDGE_FALLING, "max3110", ma=
x);
>=20
> Yeah. But in Merrifield case (at least the reference board used now)
> it's not edge triggered. I need this driver to support this situation
> prior to send mrst_max3110 platform code for it.

got it. Then why don't you use irq_set_irq_type() from platform code and
change that request_irq() into:

ret =3D request_threaded_irq(max->irq, NULL, serial_m3110_irq,
	IRQF_ONESHOT, "max3110", max);

if you call irq_set_irq_type() correctly, driver wouldn't need to know
the IRQ type.

--=20
balbi

--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSaBZ+AAoJEIaOsuA1yqREom4QAK+71REsRBJrjJP+BNXxWQ0X
57HOBYb3DqNYU5wjie5KbT2p48pfpMM5kM2TgzBVtBPWBwmnaL/U1nw2thlp2hZh
ppA5dk/eAimQ+BceP/lzfpg+FzFsJhU8SOZ4kfzPBnbFLdCRcu995YAj+QHf6MyU
nTqceOSgoloEkvYPSeqgQ8bVaWNEtZ5XVlgH0KMVo86wNdbkExQv8uy7eRxG5zFv
YiLEZRaNrUsGq9UiahG5MdaMWBn5S5wGKVMI+udkYpfUgeMEqx0fif7m3FTZRY3d
IAfhzrOAUlph+apq+rfR6d8w+s/6S+POFVrkbhP+5g2cMDiob5ivx5iPusysixh/
ZogN0ssGtSzFa7CuRN5Tmpk64RNGhbN5Co0x+HmfC0D5UaU+wBpUYo9CDv+mAOLh
NerjOkaBfAd9WXPAVsFPNPYZvaxEp9uKvPV9XSVbU57GivEexb6ZvGMl/OsKgjo+
gP6VWuCjTQhOxfS3bRFvVncHgD707kjvODRCw/PPdNcGgcfIvMdTxad0LpYHVsMT
dakLLI6PO2idgi5+i9ZjXM5FJVPOUoTbkRpsTTk26SONRlkcz21D4MxL0dqS84zz
6vyu9tWh2SJPDMLt3j7nOYE7lmAvVnDEfXStcuI9ovhcTfXuIcideRwXGfQ7sikZ
yrc6ZwZEehh9TUQJV8SB
=2vkL
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--
