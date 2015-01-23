Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbbAWJqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:46:00 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53989 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbbAWJp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:45:56 -0500
Date: Fri, 23 Jan 2015 10:45:53 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Bob Mottram <bob.mottram@codethink.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] i2c: tegra: Maintain CPU endianness
Message-ID: <20150123094552.GD3835@ulmo>
References: <1421756555-20266-1-git-send-email-digetx@gmail.com>
 <20150122074001.GB427@ulmo>
 <CAAVeFuJHST9VOWXe_cZNvLmfGdamuU4HSgdZC6EoQvrsGFt+Fg@mail.gmail.com>
 <54C115D1.10206@gmail.com>
 <54C12010.8040504@gmail.com>
 <54C130EA.2050505@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bjuZg6miEcdLYP6q"
Content-Disposition: inline
In-Reply-To: <54C130EA.2050505@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bjuZg6miEcdLYP6q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2015 at 08:18:34PM +0300, Dmitry Osipenko wrote:
> 22.01.2015 19:06, Dmitry Osipenko =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >22.01.2015 18:22, Dmitry Osipenko =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>22.01.2015 10:55, Alexandre Courbot =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>>On Thu, Jan 22, 2015 at 4:40 PM, Thierry Reding
> >>><thierry.reding@gmail.com> wrote:
> >>>>
> >>>>Should this not technically be le32_to_cpu() since the data originates
> >>>>from the I2C controller?
> >>
> >>No, i2c_readl returns value in CPU endianness, so it's correct. But for
> >>i2c_writel should be used le32_to_cpu(), since it takes value in CPU en=
dianness.
> >>It's my overlook, V2 is coming.
> >>
> >>>>
> >>>>Why does this have to be initialized to 0 now?
> >>>
> >>>I suspect this is because we are going to memcpy less than 4 bytes
> >>>into it, but I cannot figure out how that memcpy if guaranteed to
> >>>produce the expected result for both endiannesses.
> >>>
> >>That's correct. Memcpy is working with bytes, so it doesn't care about
> >>endianness and produces expected result, since I2C message is char arra=
y.
> >>
> >I'll spend some more time reviewing, to see if nullifying should go as s=
eparate
> >patch.
> >
> Well, I2C_FIFO_STATUS returns 8-bit value. The rest of bits very likely to
> be RAZ, however I don't see anything on it in documentation. In that case=
 it
> won't cause any problems with LE value and nullifying is only needed for =
BE
> mode.

What does I2C_FIFO_STATUS have to do with anything?

My point was more that we already tell hardware how much data is to be
transferred (via the packet header in tegra_i2c_xfer_msg()), hence the
hardware shouldn't care whether the FIFO is padded with random data or
zeros.

Thierry

--bjuZg6miEcdLYP6q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUwhhQAAoJEN0jrNd/PrOhQmIP+gNfs4SsJkc4AZNmiU+XbDl6
7euJQfIlEAc0Qu0flxIBdCfd+QrfvYuBnWyxpPDWKYIIUVmb7tEzzBrj2xX7Tgbj
voZuV9p30M7MXq2IC62PH45GOtDA4muW+Ma0j2BUmute6BlhvN1H73WnWxcQyXdw
SJNn37fAzOCFOiJgbmHS77bJgXydMIl+bXX+MV6T8RHTIB1hZzf6VQMvVrKOzCOU
3zGRSi+us+iJNd17/fw/DmfN6ihaSI6rj/ZuR7fUwBWBbCFqBJH5bBB7GcJHLacU
Yaue2r6oUF4zMn2VB45SORM8mGlGkFJEGqepm+35vkVMp8qp78ATAbXQslEA/uUy
Eri2+MQrs6jl+vq79GxsEUVnY08j13BzY4LozRy0c1nLN5t1sFpi4ZEo/RvK5Ntv
yt8eA1zvCxXX1zfiwqlgHGSK19lvbt0f4ScBYzDw1pcD8C/W7bDaFAXJQGSnW366
WD+q4pjzvXzQhwX4kQ/ystq3sB1AuX3TAfD8HTnRdxazNbApNowVp9tOcu0Ecuqt
pzC0DrAyJ9RmayakzY78XDlKT8qt0y0eMzyenuqqYeuV7ZG7auIVqjZJu2XsTRA9
FtLa3PmZZny7vtY8iWq0QPApxogOsrWBGTQiSihwoYbYDlwea/IkwW36uDOcii39
6t4QKjDgIpseKfP2itR5
=VPuR
-----END PGP SIGNATURE-----

--bjuZg6miEcdLYP6q--
