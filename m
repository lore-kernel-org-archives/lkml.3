Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3IWDRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 23:17:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53636 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3IWDRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 23:17:15 -0400
Date: Mon, 23 Sep 2013 13:16:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-Id: <20130923131658.ef9c825e013ed36de2047044@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Sep_2013_13_16_58_+1000_L6k6+SO35K74gi1q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Sep_2013_13_16_58_+1000_L6k6+SO35K74gi1q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/iio/industrialio-buffer.c between commit d66e0452bf6b ("iio: Fix
crash when scan_bytes is computed with active_scan_mask =3D=3D NUL") from t=
he
staging.current tree and commit 705ee2c98a37 ("iio:buffer: Simplify
iio_buffer_is_active()") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/iio/industrialio-buffer.c
index 2710f72,2361fbc..0000000
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@@ -546,16 -521,9 +540,16 @@@ int iio_update_buffers(struct iio_dev *
  			 * Roll back.
  			 * Note can only occur when adding a buffer.
  			 */
- 			list_del(&insert_buffer->buffer_list);
+ 			list_del_init(&insert_buffer->buffer_list);
 -			indio_dev->active_scan_mask =3D old_mask;
 -			success =3D -EINVAL;
 +			if (old_mask) {
 +				indio_dev->active_scan_mask =3D old_mask;
 +				success =3D -EINVAL;
 +			}
 +			else {
 +				kfree(compound_mask);
 +				ret =3D -EINVAL;
 +				goto error_ret;
 +			}
  		}
  	} else {
  		indio_dev->active_scan_mask =3D compound_mask;

--Signature=_Mon__23_Sep_2013_13_16_58_+1000_L6k6+SO35K74gi1q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSP7KvAAoJEECxmPOUX5FEq50P/RnV7ZTWZB1ttMfWUJfI5mdL
dUcgS0Cf32+hO6CBL/peL7s4s7ONGixe2VNjpPe+JpCZB8d6qLIUU87C2wfYPCEe
Mz+HDLPmmxYvTm2sYSItfNDMrQY6wpViohpIFzqwz0VED9B475MpD/LuD8gB393u
CIhsyS3gAecxZ2V3rbYGXDOTs7denesYFS5bFdSJl/xZ2p68Iy+iatDw9h0fsBwt
I46lSi/glw7rFkRJkodfHZtCIEY27ium86+1GzoTRgHwq1d8fJw9rVpq+DSriLSS
4gT9GUy0ZuFLR0IaMCkX19Jk+TDCvxAmgU7DpOdfIGR+eUpQSmsnZvTfcl5MlaTu
JMLibmuInv4wr/gzxB9rHm+pNAQjP1ydZXU1wXL5imwwqViWaFlvz7u9CuZg9qA6
uVXPgsJ/Dp0JAEypbDZQWNL+WzlrwI1pscaOxfPpW2zAYjTx6pe7HHXmnyAPTtaI
k+3jLl+VlksrZQUD04TWKt9shxeGsnL3XXUe5kOdL4PY/UQa3d8pn50xH656kGAZ
Mjt2Q2yQKFWALXWiqwqLXpp3YFCiu0cetWiOMJ2FgANpalE6gW2A1txDnHiVN/Ed
/7jn5u6sGkVLCmnU8G41Ruw/extXDKsgX9kthgC1Jm9affSVKFy80mYEG762gy3E
3U0eP8x0nJ4Nj6p98WkY
=cnnh
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Sep_2013_13_16_58_+1000_L6k6+SO35K74gi1q--
