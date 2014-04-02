Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433AbaDBW31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:29:27 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:41457 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158AbaDBW30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:29:26 -0400
Message-ID: <533C8F3C.6090306@archlinux.org>
Date: Thu, 03 Apr 2014 00:29:16 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: USB autosuspend causing trouble on Intel bluetooth (Linux 3.14)
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="5iqIgv1kJHOiUX8DjMLmC58WfbLxCkcx9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5iqIgv1kJHOiUX8DjMLmC58WfbLxCkcx9
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

I am having trouble due to the following commit, which landed in 3.14:

commit d2bee8fb6e18f6116aada39851918473761f7ab1
Author: Tedd Ho-Jeong An <tedd.an@intel.com>
Date:   Tue Nov 12 13:16:41 2013 -0800

    Bluetooth: Enable autosuspend for Intel Bluetooth device

I have an Intel bluetooth dongle (8087:07dc) built into a Thinkpad. I
primarily use it with my bluetooth mouse. Whenever I stop using the
mouse for a few seconds, the mouse stops working. When I turn it off,
the bluetooth applet on my desktop shows it as connected indefinitely. I
can fix this situation by either of these actions:
* restart bluetooth.service
* disable+reenable bluetooth in the bluetooth applet
* modprobe -r btusb && modprobe btusb
The mouse then works again until I stop moving it for a short while.

The culprit is USB autosuspend. When I explicitly disable it (echo 'on'
> power/control), the mouse works fine again. However, due to the
aforementioned commit, I need to do this manually after every boot and
every resume, because btusb keeps setting it back to 'auto'. I have
found no way of overriding this behaviour.

Any advice or help is appreciated.
Regards
Thomas B=E4chler


--5iqIgv1kJHOiUX8DjMLmC58WfbLxCkcx9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTPI9CAAoJEChPw0yOSxolpaYP/inQQjMzH7jHukByOE0sFS97
qXAyN4e4R+uPeWtfIrmgJUNYqlNSSnGEG2TJSxpdD4ZxjotJZQjkXGl9Y218L0N0
dSIJLrNWLFnCIbeVJP/Eefovn/hnqIeS35h12ocqn8aUBL7HLu+JmrbgpIfCkmTr
gkOnmIntdpdRZWJqNpyfEH6uFMpe+hPjpXx02e6LZrulMVVQvQvI+1IdCeAVChya
SXNSdHD3PfpljPV4fziNldZRtBDINC8LTvBs1g66xH2BjSLeBFYbUXVWn8WTg1tO
l93esE8tZpT7HYog+AjnH9p89BhMwqAEXsMRkpCHQfdY5fjT/X+NpfZDne/upYZm
s59m3+DDu6Dav7rniiYzp2k3jNUp/xi7dl4wghyef5Jwd7u8yjyhiIQHysz0TO//
tMUMg37/57jUJTDsnX55dw9P1SbDo7hzxb9ZG7vqM7PY69phCaQqSVNtQBAXHjm4
ejyBuVfRfYZ9c6Q10VQFpcUacA5xN8nkXcdHMJxXpP7lJg7nLL4TmESjO1ay2JZb
YdPRJLYXRRJd9IEC4k26wJZhCERcoifV9jknaRAYRF/dbQCq8vR/v/+iZmUojBd0
GnvS6gZmCJra3OXC3bD5Kwt2EAtnT2GNkKrg4VBI6FppsoG731QRDIOiYWw1YORt
8KHm1HKNWgdnSerYPG3B
=bELs
-----END PGP SIGNATURE-----

--5iqIgv1kJHOiUX8DjMLmC58WfbLxCkcx9--
