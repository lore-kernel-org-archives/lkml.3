Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaHUSRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:17:49 -0400
Received: from sauhun.de ([89.238.76.85]:58596 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbaHUSRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:17:48 -0400
Date: Thu, 21 Aug 2014 13:17:38 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Addy Ke <addy.ke@rock-chips.com>, max.schwarz@online.de, heiko@sntech.de,
        olof@lixom.net, dianders@chromium.org, huangtao@rock-chips.com,
        hl@rock-chips.com, yzq@rock-chips.com, zyw@rock-chips.com,
        linux-kernel@vger.kernel.org, kever.yang@rock-chips.com,
        linux-rockchip@lists.infradead.org, xjq@rock-chips.com,
        linux-i2c@vger.kernel.org, caesar.wang@rock-chips.com,
        cf@rock-chips.com, hj@rock-chips.com, zhengsq@rock-chips.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] i2c: rk3x: fix bug that cause transfer fails in master
 receive mode
Message-ID: <20140821181738.GA1443@katana>
References: <1408643457-7126-1-git-send-email-addy.ke@rock-chips.com>
 <53F634AF.1010303@cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <53F634AF.1010303@cogentembedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2014 at 10:04:31PM +0400, Sergei Shtylyov wrote:
> Hello.
>=20
> On 08/21/2014 09:50 PM, Addy Ke wrote:
>=20
> >In rk3x SOC, the I2C controller can receive/transmit up to 32 bytes data
> >in one transaction, so the size of data to be write/read to/from
> >TXDATAx/RXDATAx must be less than or equal 32 bytes at a time.
>=20
> >Test on pinky board, elan receive 158 bytes data.
>=20
> >Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> >---
> >  drivers/i2c/busses/i2c-rk3x.c | 3 +++
> >  1 file changed, 3 insertions(+)
>=20
> >diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x=
=2Ec
> >index 69e1185..dc0aa64 100644
> >--- a/drivers/i2c/busses/i2c-rk3x.c
> >+++ b/drivers/i2c/busses/i2c-rk3x.c
> >@@ -323,6 +323,9 @@ static void rk3x_i2c_handle_read(struct rk3x_i2c *i2=
c, unsigned int ipd)
> >  	/* ack interrupt */
> >  	i2c_writel(i2c, REG_INT_MBRF, REG_IPD);
> >
> >+	/* Can only handle a maximum of 32 bytes at a time */
> >+	len =3D (len > 32) ? 32 : len;
>=20
>    Why not min(len, 32)? Or even:
>=20
> 	if (len > 32)
> 		len =3D 32;

No silent trimming, please. The message should be rejected when the transfe=
r is
set up. We could assign -EOVERFLOW to that type of failures, so users
will know. Sadly, I have seen other controllers having such limits :(


--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9jfCAAoJEBQN5MwUoCm2KDAP/REu6M3f6+x1V5F0pQNMXhzD
63qBo54wVv7adKVr6QwwrYMP8BBGbtjVV3jm5J+GfRrbsex8of2iYITivL67rFw/
tdZimlsP9cLgofmsd547TS54ohkKP2u5iTkxRTwn70L0a4YP3UrCZbhfjCT6QFwS
pmUAoil47knaMLSKAs7mxNHzo78f9lWp3Y8HhvN8x0XReuiX0Vo/l93TW3bDgUv4
mCeP8hTKZY07Qm7sIjUquv9XGs6/68EEXnRvPqboTroArQSp/A0mQwlzlgRgO5JU
GnoHaDAi88JdO4cVUQsCAasNKIj8uwbUXfwcuvZCXkyWYrVNUCySMfcyy56xuFkW
AL82PyazdAjweq2PWz+K1wfs0tnQMvfQUgeR0ZEJbr2U26x5aBWzrp/vkT4KMm5E
TxJwVBwvEoCkSQTDKKUoueNoMedL2zfJ30sXmedAGx75cIGZSOaaomJcpXWJfccF
Sfn9jjUJu9oHx5PVqKrVxfWhxsw1ZET597tRVMhmruUjOAdlCRTTWEl6ypn2pCxx
nvnc/coOhRzxchsub2EDHmWDaaBIAqA/8/Lwl7dng4OWQGYDtd9Be6haYbTlGn+v
iF4kgE4UyhBYNBe/ra7EdX85RirwNv6r0F3TUtu0dOzctKrAD3+LrKvF+dMqvbcg
es4ZOO2p2w/7PSIhwdCK
=atpD
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
