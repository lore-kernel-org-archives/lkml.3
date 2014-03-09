Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaCIUVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 16:21:12 -0400
Received: from sauhun.de ([89.238.76.85]:48333 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbaCIUVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 16:21:11 -0400
Date: Sun, 9 Mar 2014 21:21:07 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, nsekhar@ti.com,
        khilman@deeprootsystems.com,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] i2c-davinci: Handle signals gracefully
Message-ID: <20140309202107.GA2835@katana>
References: <1389265885-26777-1-git-send-email-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <1389265885-26777-1-git-send-email-mike.looijmans@topic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09, 2014 at 12:11:25PM +0100, Mike Looijmans wrote:
> When a signal is caught while the i2c-davinci bus driver is transferring,
> the drive just "abandons" the transfer and leaves the controller to fend
> for itself. The next I2C transaction will find the controller in an
> undefined state and often results in a stream of "initiating i2c bus reco=
very"
> messages until the controller arrives in a defined state. This behaviour
> also sends out "half" or possibly even mixed messages to I2C client
> devices which may put them in an undesired state as well.
>=20
> This patch fixes this issue by always attempting to finish the current
> transaction, and then check on a pending signal. It either reports
> success if all data has been transferred, or it returns failure when
> the transaction was aborted. This keeps the controller in a defined
> state, and is also much friendlier towards client devices, because
> it will only send complete messages.

Even more, you should complete the whole transfer. There are devices
where things can really go wrong if you send a half-complete command and
then start with the next one. So, not checking signals at all is the way
to go for I2C drivers. There is some cruft left, so I am happy about
patches fixing that, with testing on real HW. Like yours here.


--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTHM0zAAoJEBQN5MwUoCm2owMQAIwH+1ONRQ+4QYjubu020Agg
zzlbzOfBgKkIQ9KdsfBlZX9G5NJBKTAPZgGELllq5DfNbN9z332MPtddhGgW7Q+M
FJBw99w/b+b/zVODXMQzH5gjj0AojeIOJj3JV86lK8KnCf1Tl2K3iTyQNzw+3NTl
539dmZqfBwDq2lovR/MIdi09Q04nZez+N5oU7+tDhKyb/T6SSERtkFZdZQ/rnji4
BdYs7QTWKfCMnVpMlSzZWHPLTH2f2obqgZFlEkLalbXLhs6LnO1ytEivW1K8FqZ7
zYF7W8zuwDFPlqkV2wHdudcNPsm1bV6lFpZW4BXBpOjmGGZk5lwGpUa6eJiUOBhL
lx5ecjhQUmctJMj8OYBHUjk5yt5ZC2S/uqaUW/AMBllC69BzteKip2BUKXr08SHd
NuC/WQOQCB/0QSomviUf6mNm6+D/a+sL8SobUdbk1GU6VL7ApKZQqQanlZUOaKle
Dp+U78oHlTrEp1rj0dK0PM1QzM6nF10lRex06jetSGq31iMLvQp1x2vtFlDnt7fG
nasli1qrmdjyJD4gM8fgtdOSJIdmhGrTeJ8KNudpFs8rApFsuqTvoAa6xFQ1GKdM
iSMBXT2TBrBvf33mj+twqthc1xtadgAeu1BfCXgeIsctNqdZBUgEa2BJk7HaX+Pz
kvxZ7cQOdanuO8oBIJq2
=ux7p
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
