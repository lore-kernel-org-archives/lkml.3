Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287AbaFQSsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 14:48:15 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:49681 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbaFQSsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 14:48:13 -0400
Message-ID: <53A08D64.1060800@Vivier.EU>
Date: Tue, 17 Jun 2014 20:48:04 +0200
From: Laurent Vivier <Laurent@Vivier.EU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Bollinger <sethb@digi.com>
Subject: Broken serial port
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Kv7XxoFbl6mDSrFHgaBJCsM8FdmxNpX62"
X-Provags-ID: V02:K0:D6jKzGa1l3knHoclmlPtnRUPaX+wXgAi7mPinf184al
 5KtWUdFVWOqx6Of7SYOtwgV0jbu6xU3VhqhJh5W7EiO9bMLCle
 5AWH7fCnWsZcJlLT3mweyjy4aCrWlJAeyw6JdkXSuyvxcMqHIh
 SkzgSHK2rzqiHRa8QfDQAOkbCZtPeeu+lI5TNHDNOGGDGRSUwG
 qhvxRNAXxvdN4s5Kky7uExprNWTiryXOlal1TtEpa1w1yftBf7
 clDn+EsTcnqRNNQnkKisPWYwEijzLHzEjJEJjRaZozu5yWc0tq
 Q5eysusZnerr9tDsWlHB2H8EeIR2WSnxo7dk/QCFcd9yf5eLu8
 90eo7DQPJvm1n43TPh8Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Kv7XxoFbl6mDSrFHgaBJCsM8FdmxNpX62
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I'm not subscribed to these mailing lists, so CC: me.

I'm playing for some days with a kernel 3.15 on an old mac performa 575
and it seems that the serial port is broken. When I log on using the
console on the serial port it seems there is an screen refresh added
after each character I send.

A little demo :

http://asciinema.org/a/10211 [at 3:20]

I bisect and I found this commit :

commit 717f3bbab3c7628736ef738fdbf3d9a28578c26c
Author: Seth Bollinger <sethb@digi.com>
Date:   Tue Mar 25 12:55:37 2014 -0500

    serial_core: Fix conditional start_tx on ring buffer not empty

    If the serial_core ring buffer empties just as the tty layer receives=

    an XOFF, then start_tx will never be called when the tty layer
    receives an XON as the serial_core ring buffer is empty.  This will
    possibly leave a few bytes trapped in the fifo for drivers that
    disable the transmitter when flow controlled.

    Signed-off-by: Seth Bollinger <sethb@digi.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


If I revert it, all works fine :

http://asciinema.org/a/10212

Regards,
Laurent


--Kv7XxoFbl6mDSrFHgaBJCsM8FdmxNpX62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOgjWQACgkQNKT2yavzbFNb4gCglmLCQ7pVzeQHeBHD9tniaIaE
40oAoNckZ2E5GW6AkukqOWAiAJQUkuWm
=7UPG
-----END PGP SIGNATURE-----

--Kv7XxoFbl6mDSrFHgaBJCsM8FdmxNpX62--
