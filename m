Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaILJfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:35:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39024 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbaILJe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:34:57 -0400
Message-ID: <5412BE19.2010302@ti.com>
Date: Fri, 12 Sep 2014 12:34:17 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <plagnioj@jcrosoft.com>, <grant.likely@linaro.org>, <arnd@arndb.de>,
        <peter.griffin@linaro.org>, <jg1.han@samsung.com>,
        <daniel.vetter@ffwll.ch>, <laurent.pinchart@ideasonboard.com>,
        <robdclark@gmail.com>, <linux-fbdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbdev: fsl-sii902x: HDMI support for Freescale SoCs
References: <1409892517-29816-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1409892517-29816-1-git-send-email-Li.Xiubo@freescale.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="0ff6aQeaPd3M3s1MAo9HX6mg2ScwMT9ut"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0ff6aQeaPd3M3s1MAo9HX6mg2ScwMT9ut
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi,

On 05/09/14 07:48, Xiubo Li wrote:
> Some Freescale SoCs, there has an DVI/HDMI controller and a PHY,
> attached to one of their display controller unit's LCDC interfaces.
> This patch adds a preliminary static support for such controllers.
>=20
> This will support for many modes and a dynamic switching between
> them.
>=20
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  .../devicetree/bindings/video/fsl-sii902x.txt      |  17 +
>  drivers/video/fbdev/Kconfig                        |   7 +
>  drivers/video/fbdev/Makefile                       |   1 +
>  drivers/video/fbdev/fsl-sii902x.c                  | 526 +++++++++++++=
++++++++
>  4 files changed, 551 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/fsl-sii902x=
=2Etxt
>  create mode 100644 drivers/video/fbdev/fsl-sii902x.c

I don't know how you picked the names of the people you sent this patch
to, but looks to me that most of them are probably not interested in
this patch.

Anyway, a few quick comments on the patch:

- You should probably use regmap instead of direct i2c calls.
Interestingly, you define regmap variable, but you never use it.
- Use defines for register offsets, instead of magic numbers.
- You should not use static variables. They prevent having multiple
instances of the device.

So the SiI902x chip is on the SoC, not on the board? And it's a plain
standard SiI902x in other aspects?

 Tomi



--0ff6aQeaPd3M3s1MAo9HX6mg2ScwMT9ut
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEr4ZAAoJEPo9qoy8lh71CpAQAKoDh2t5GoUuDQpPouk0PjlM
u03FFs+tJDnol6nKjrA2aWdhi9tAUhofT2dyrnmlrHMPmhCRUZxuyuLFFVvYDcz9
OUpt7nk80zAAhHwwsr4gReSzhLP7sTfqVjvuD4fwvA2Iff8XJI1v8ZTpSznz30PV
77Nog6FoZpukkookxs1U2YEvftgHuox3DwKweyaTensWsbS17NJw7bjVLYehtqlQ
RTFIz5kwhzbL6NEKY/FVTyEFxrqB3lck/r8bhbkRmEUunA9blJC/GVTiVYFTAW5d
sJFfAS2Jo1yuKHtfpHjQoaCO/QcLV9I9MG1q7m+atXqy2SYW0nuxk0z79Gal4buu
IENJXu+uh+lsbWNBeoS+KjPpVtCmX7+yFYXdsHg2LhS7KVY4z/Qjkd+a2hc1tyl1
iQktbfdRm/0MLsNlI/dPpH19prgPg9Q0rxJJJKLcx9VtCE/3iZZZOzVJSz4o3ESN
G7wfKLD+U9UQbow0g/UBWCqL58POVxxZtt37oYcQZ81i41H76D7xTK5ZscKQ9XBi
PguTkAs2LCa2p3NlQPvuGdsA4cZCiWHjo3yNlY4HGzrG9/nXzz1B/JdeuZf3rzxN
OgJnKs2ak0MfajQudQOgC0UcvQ//CRwXQDcjf6VagzYUIH0f9Qj5cmO4mqMC238I
9sZSar3jJYIOgo9ICHi6
=phmy
-----END PGP SIGNATURE-----

--0ff6aQeaPd3M3s1MAo9HX6mg2ScwMT9ut--
