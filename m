Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbaCTQga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:36:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43197 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067AbaCTQg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:36:28 -0400
Date: Thu, 20 Mar 2014 11:34:35 -0500
From: Felipe Balbi <balbi@ti.com>
To: Marcel Holtmann <marcel@holtmann.org>, Alan Cox <alan@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: Muralidharan Karicheri <m-karicheri2@ti.com>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: hci_ldsic nested locking problem
Message-ID: <20140320163435.GH32692@saruman.home>
Reply-To: <balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RwGu8mu1E+uYXPWP"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RwGu8mu1E+uYXPWP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

when 8250 driver calls uart_write_wakeup(), the tty port lock is already
taken. hci_ldisc.c's implementation of ->write_wakeup() calls
tty->ops->write() to actually send the characters, but that call will
try to acquire the same port lock again.

Looking at other line disciplines that looks like a bug in hci_ldisc.c.
Am I correct to assume that ->write_wakeup() is supposed to *just*
wakeup the bottom half so we handle ->write() in another context ?

Is it legal to call tty->ops->write() from within ->write_wakeup() ?

cheers

--=20
balbi

--RwGu8mu1E+uYXPWP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTKxibAAoJEIaOsuA1yqREQ6wP/Rki7213nleViEF4e2iQPoiX
Phn2KyCf70Mbly1abtLR9ilIqs4iebRg+VOowU2/64d6+SiiOzPupDlJRIrikHvR
BT4gZB7YTQiUgYteO21vlIEKUBxRTr8ntujA6p+v0NOZqJv/BNcLcGuR8e774+fe
j97ZcFlx+hbEb9q608bD5XbkGXftXBhhFx+llbM5AAK/ffDzFwwp9EgYzjSO4M0I
lpIInSuT7NvOShU63Jx642D5BG2n1F5A6NgZacKGhXIC0FSJjHPN6eo1vNYPcqGe
ubM8MgF/RbDrqJS7c0BRnr3qFvYah0NYeS0sEkWKcTlmXK8JX8fIXw+7+e49WaE1
fc2ccmfJWfNneB1/kRfTZgt3Pxi6iwS2GzMrXKEelpI2BLrnhpm2Ew5TQmMaIfw3
WLySiAtZG6zWuqxHzbAOUu8vMdH+NRxFRvTUhYXiSSJhUxQIrYL2IeOG3vecTkYQ
4bRXLnK0OOCPPKC95IA3RyFP26rb4uMOYU+t/lbU5OD24L0mzwFAGl7i8AfoYTAy
s3BywhZA5joQTqDKXDVQ9agz4VmiIG5tLcp1WPEMXRwS6/BRM/DI4oRRfKfjKpLB
jLcGurJjdt04I7irLBMksVdMPqMRWn3b3ZgEGlJffEcxC4V9r2IPH8Pi9C4ccKTH
17CbvpZMUjSUZoDkbPZT
=eLjS
-----END PGP SIGNATURE-----

--RwGu8mu1E+uYXPWP--
