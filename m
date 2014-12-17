Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaLQIjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:39:11 -0500
Received: from sauhun.de ([89.238.76.85]:42129 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbaLQIjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:39:09 -0500
Date: Wed, 17 Dec 2014 09:39:05 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: sh_mobile: I2C_SH_MOBILE should depend on HAS_DMA
Message-ID: <20141217083905.GA2919@katana>
References: <1418650624-28174-1-git-send-email-geert@linux-m68k.org>
 <20141217065814.GB1018@katana>
 <CAMuHMdWShh+m_0c_3cnGt_2J03u0dhWytER0AqLWoLtauEh5aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWShh+m_0c_3cnGt_2J03u0dhWytER0AqLWoLtauEh5aA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2014 at 09:04:52AM +0100, Geert Uytterhoeven wrote:
> Hi Wolfram,
>=20
> On Wed, Dec 17, 2014 at 7:58 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> > On Mon, Dec 15, 2014 at 02:37:04PM +0100, Geert Uytterhoeven wrote:
> >> If NO_DMA=3Dy:
> >>
> >> drivers/built-in.o: In function `sh_mobile_i2c_dma_unmap':
> >> i2c-sh_mobile.c:(.text+0x60de42): undefined reference to `dma_unmap_si=
ngle'
> >> drivers/built-in.o: In function `sh_mobile_i2c_xfer_dma':
> >> i2c-sh_mobile.c:(.text+0x60df22): undefined reference to `dma_map_sing=
le'
> >> i2c-sh_mobile.c:(.text+0x60df2e): undefined reference to `dma_mapping_=
error'
> >>
> >> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >
> > Thanks for spotting this. However, since DMA is opt-in, isn't this
> > dependency too much? I can't think of anything better than #ifdeffing
> > the code, though.
>=20
> You're right.
>=20
> E.g. drivers/spi/spi.c (in SPI the mapping is handled by the core), this
> code is #ifdefed out.

Then again, we could depend on ARM || SUPERH || (COMPILE_TEST &&
HAS_DMA) to skip the #ifdeffery? ARM and SUPERH don't have NO_DMA.


--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUkUEpAAoJEBQN5MwUoCm25bIQAKpJSDzziWtItzU/Xgo5DPif
A5Wnbc4MCNi6SUWjJ60JsmV4ecl2uYpvR7EnYL0XkHUdAC7XCCaHp4b58UWbEv+9
CleFx/vbM/ZOSwi2Rm/+ww5+fa7OG00sKKbqMbz4WlRfTvAl7mOJfwcnji4HMIiZ
1Csu+m6gTaedmWw3kXtpXkZ1KJSEMCILaMuRljOFQewdvn7O9ZWkJKf9o7rLu6on
mgZ+hXj+Nb6kfW/Agfw65F2E7uedNtjHwHgTu3tAdriZ0goAqG/N0Qn3CQuM3RhQ
kqt8yyyxTKMwc4wwYEskhMox4RMlLi6O4UOi9GwJyoKuLRRQTpBwwLxvyL2Xwzd+
z/3Amgm7LxgzTT3weVhSppbYufFSYSEh618ILczH8FsL3LrnvkT65kOZSZ34du84
/t5XTxs0WjCwe7iGRpc1hcqdk+3ZwaxiXQZNxB6rnnGB+F4SS6GWyL1AuWq4g7cj
QpQgIoQYHpLeCO5MpgCwE5PlaxythJOXqAunBINmIJiyeNJn/m2sjIJeeuLOtBgq
ra7wC3/iHStGTQRyWMntuuA4mJLKES/K/iCzVRdGZ3ey9ams/Zr9w4JZLQl8TmAV
iI0W0PhjJViXSSobGP6LzWgO8GyBZSSzvV3nh9x7jmjMlHQBvT0N5Cw6pN1Algk3
Pd33gaRMxdVaH4Eas5vB
=FwbV
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
