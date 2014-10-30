Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759882AbaJ3M4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:56:52 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:64600 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759339AbaJ3M4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:56:50 -0400
Date: Thu, 30 Oct 2014 13:56:46 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: Re: I2C OF IRQ parsing issue due to probe ordering
Message-ID: <20141030125645.GA19386@ulmo>
References: <2287003.09eTeKUr1V@avalon>
 <20141027125819.GA12641@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20141027125819.GA12641@katana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 01:58:19PM +0100, Wolfram Sang wrote:
>=20
> > The i2c@e6520000 node is probed before the gpio@e6051000 node. The
> > of_i2c_register_devices() function tries to register all children, incl=
uding
> > hdmi@39. It tries to parse and map the I2C client IRQ by calling
> > irq_of_parse_and_map(), which returns 0 as the interrupt controller isn=
't
> > probed yet. The adv7511 driver later probes the hdmi@39 device and gets
> > client->irq set to 0.
>=20
> I've got this strange feeling of deja vu... Ah, here: Thierry Reding
> tackled this problem a year ago. His series:
>=20
> https://lkml.org/lkml/2013/9/16/111 (of/irq: Defer interrupt reference
> resolution)
>=20
> He did a V2 (which never made it to the i2c list). Seems like the first
> two patches made it and the rest got stalled without discussion?
>=20
> https://lkml.org/lkml/2013/9/18/216
>=20
> Adding Thierry to the queue. Maybe he can bring some light to what
> happened to his series.

I tried to fix it in a proper way, but it seems people were uneasy with
how invasive the change was. At some point I lost interest. People ended
up merging something that was similar, but side-stepped the issue of
propagating error codes all the way up by introducing a new API and in
case of of_irq_parse_one() failing doing an additional check to see if
the reason was the missing IRQ domain.

See:

	9ec36cafe43b of/irq: do irq resolution in platform_get_irq

I suspect a similar thing could be done for I2C.

Thierry

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUUjWNAAoJEN0jrNd/PrOhlgoP/A4pizp/MQfjjdWugXFCBstK
y2Nn1JMGa7HfUhn/Z3rhC1FM52cbIbJ3ByQYWekps51GTLbY5VPDCeXORWWF8dXn
+/GzJbq+nU4BczJp19UVNHLV+L35XRj4+N/y2k6ye4ptd5x2LqHA6vW28TUAOKoq
/lJR3Lg5USfj0yK9PHW9WSmSQFzctsondiQ4DZ4KutTO3wu2shEgyz8hG0R8OHvY
ZHV2vl7oYv3eTxPkQAvhrOQGxACkTDGp8JFONQMuIw4meyxEgJTug7A5N3T7mxqo
u2wbB3qHCTgaMgam1lTfBQ0A/sAn08xeNt/w7NddlDCGFmUG5/BKot7/lzy6FPzK
He1m6KZfmoJPPvRwbgZhzWCPRSxcW2OSgNJJf4XFY6+UqUMFqr61udAo48rbiPo3
NQ3IEDVPbZAjdB1yMIzhaEbmqVjr8YoJyH+t+UqKhFGDaMmoClR+R79GJT8XuZWw
M8aMYuqTN2nqXow5LlzoUMg9X8vHmZTXyIixO+JxNEx0o2pxAzprACqKquWTAvcl
+v5oUhpyslgghtd00ZCD6lPKNYunFaUBhDbOFuJJjFoqC3e8JpfDDsnr9OpOPH91
EPC0fLbHNp1PqFlCGoqcKq7wOp2Lx4/MIRdsUw2UI3TaZh5YTCZMz0VsvKE2DzWV
U84Y/9JcFLIwjLuenzw0
=N8cN
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
