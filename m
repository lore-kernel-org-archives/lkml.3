Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbaHASiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 14:38:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40528 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaHASiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 14:38:18 -0400
Date: Fri, 1 Aug 2014 19:37:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ks.giri@samsung.com, arnd@arndb.de, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, robh+dt@kernel.org, pawel.moll@arm.com,
        courtney.cavin@sonymobile.com, mporter@linaro.org,
        slapdau@yahoo.com.au, lftan.linux@gmail.com, loic.pallardy@st.com,
        s-anna@ti.com, ashwin.chaugule@linaro.org, bjorn@kryo.se,
        patches@linaro.org, mollie.wu@linaro.org, t.takinishi@jp.fujitsu.com,
        khilman@linaro.org, lee.jones@linaro.org, andy.green@linaro.org
Message-ID: <20140801183748.GL30458@sirena.org.uk>
References: <1406896194-4667-1-git-send-email-jaswinder.singh@linaro.org>
 <1406896296-4863-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mg8cdxx98+SFDaXr"
Content-Disposition: inline
In-Reply-To: <1406896296-4863-1-git-send-email-jaswinder.singh@linaro.org>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.197.121.167
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv10 2/4] mailbox: Introduce framework for mailbox
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mg8cdxx98+SFDaXr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 01, 2014 at 06:01:36PM +0530, Jassi Brar wrote:
> Introduce common framework for client/protocol drivers and
> controller drivers of Inter-Processor-Communication (IPC).
>=20
> Client driver developers should have a look at
>  include/linux/mailbox_client.h to understand the part of
> the API exposed to client drivers.
> Similarly controller driver developers should have a look
> at include/linux/mailbox_controller.h

Reviewed-by: Mark Brown <broonie@linaro.org>

One very minor thing:

> +	t =3D add_to_rbuf(chan, mssg);
> +	if (t < 0) {
> +		pr_err("Try increasing MBOX_TX_QUEUE_LEN\n");
> +		return t;
> +	}

In this and the other error messages it's probably worth doing something
like a dev_ print with the device in the mbox_controller - if there's
more than one mailbox controller in the system it may well make
someone's life easier to get a hint about which one is running into
trouble.  Similarly if there were some identification for the channels
that might be useful to display that (perhaps add a name field people
can initialize if they like in the struct?).

This is clearly not a blocker for merge though.

--mg8cdxx98+SFDaXr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT2954AAoJELSic+t+oim9zPEP+QEM6LF0SOtWziD/zBcqBiEj
HIzqg85pz3BKkSmCjer36r7xkIgbyBm9ZR2IwPWaArtTZKzbV/04m1vsHnuX93Tj
EiX+oa3c04YDFyBbOZkdAptgh2K3H+SDeDtmYRYUenvdJsMUDcQAqYe1fNK/qqZI
zl2LQSvOT7IZmkqXB7YM2ztCiqMs1kXTKGmKy+19p5n/1HmoLBhY/uGSmAxL3Nh2
q3NVXQ7RBLKvBKEUUPEP13zTqca1I6qFReAW5YIIF2KabhLlyZM/THn4ZMRxuPn5
Q6KYBEE2eRcxrJlvZVehhRw5Tf/G8FGMJIebIKiFwLdqidY1hB82p2HX7DwRQtlz
Jk18m53o749KaO+wqVDLgSTPbupd2hUSwOpWe2OTWHVkicznWXBlzqeVD2kUHEcw
kG5gWZMVq8n+0+YzpQmI/evUJknlG6snoRHkakxJT3rtiU3m3G2Gp/y18RShLCtg
zNWPROgit8+tK8Fn6Xpdc1f0tAd4jnCgg3fEvLs5G3kZlUx+nkN4So+f8cncSXlK
COsO28D0n4JMCJ7TdbEjgNzPsYOvr8JNuxl67OKi7q/Gx/HwcewLxDLs3c60kb/5
XC5BcZvw34c9oQQ5OE0piflx5uQph66HE2Gwd4OnQGqZUlTROGd2fh0Uyq+n/WYF
bfg6k9fuJjyIQfVU8h0x
=AQq1
-----END PGP SIGNATURE-----

--mg8cdxx98+SFDaXr--
