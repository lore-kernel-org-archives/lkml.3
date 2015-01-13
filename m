Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbbAML3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:29:04 -0500
Received: from sauhun.de ([89.238.76.85]:35102 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbbAML3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:29:03 -0500
Date: Tue, 13 Jan 2015 12:28:54 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Harini Katakam <harinik@xilinx.com>
Cc: mark.rutland@arm.com, michal.simek@xilinx.com, soren.brinkmann@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, harinikatakamlinux@gmail.com
Subject: Re: [PATCH v5 1/2] i2c: cadence: Handle > 252 byte transfers
Message-ID: <20150113112854.GA7660@katana>
References: <1418357907-4215-1-git-send-email-harinik@xilinx.com>
 <1418357907-4215-2-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <1418357907-4215-2-git-send-email-harinik@xilinx.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 12, 2014 at 09:48:26AM +0530, Harini Katakam wrote:
> The I2C controller sends a NACK to the slave when transfer size register
> reaches zero, irrespective of the hold bit. So, in order to handle transf=
ers
> greater than 252 bytes, the transfer size register has to be maintained a=
t a
> value >=3D 1. This patch implements the same.
> The interrupt status is cleared at the beginning of the isr instead of
> the end, to avoid missing any interrupts.
>=20
> Signed-off-by: Harini Katakam <harinik@xilinx.com>

Applied to for-next, thanks!

> @@ -333,10 +359,11 @@ static void cdns_i2c_mrecv(struct cdns_i2c *id)
>  	 * receive if it is less than transfer size and transfer size if
>  	 * it is more. Enable the interrupts.
>  	 */
> -	if (id->recv_count > CDNS_I2C_TRANSFER_SIZE)
> +	if (id->recv_count > CDNS_I2C_TRANSFER_SIZE) {
>  		cdns_i2c_writereg(CDNS_I2C_TRANSFER_SIZE,
>  				  CDNS_I2C_XFER_SIZE_OFFSET);
> -	else
> +		id->curr_recv_count =3D CDNS_I2C_TRANSFER_SIZE;
> +	} else
>  		cdns_i2c_writereg(id->recv_count, CDNS_I2C_XFER_SIZE_OFFSET);

else branch must have braces, too! I fixed that.


--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtQF2AAoJEBQN5MwUoCm2MbcP/A+1f1dbP+/97P9g+OU6S65D
f3Az8j+0Fu//0TKOeOwmr5ay+QBaPYxdbNfCBd8Ppd3w6oeP+xeXuUAu505tbdQw
G1adUv4lmZoFMuMQMYhWv9oObGFq6Td1sufaxWVFAqeEQaWpLPda/sUQwjV5llsL
q6dCfJsQxLGO9cFK+CN/QnMch8JcrY+G+cwqS/OS7klgWJwMkVj6VLLIhvenZQ7C
NuFsCmrmLVDScVkEa4QgCX5oLG3gfldDutR8LjUFpzUruPfSkRWF70hoRV1cvWzB
Jh2LCtPiH7jSZ2Wgp/lINVsS/VsBdXOn3ya6dFArWXrAbWAOlTjscrACWwI7gnvr
wrfGigEgYuKPrsY/rXH+Ki8MBOAhRDV6+LRDtfLwSGMYjG43yEfXgdYCnKPzTqzp
OH5V5eqYEFK8igdzn2Q5oWLwXiJIrx3RuEsfLYunM4R77j76/I09eAsuDSLzxszv
0ytdgmqvxL+gpduu2ohj0yBk7edGpz5A908VlkWeqydOyF0Z2px7LWgiQUJixZ0G
/HB6o5AlUDEbXkB9t1fatj+84R64kSUn+EU8kaK5SXiJcty0f143Vf2PM9yqr89n
D6E6ssRkZnhtA9lJIXaIEMShcFeHwZqw6nTfGiZYyrBd2gwlqK05jmyFftfTyR26
bhNlSzG+raJFGIXz+1e9
=BBRZ
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
