Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab3CKDLK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 23:11:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33954 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753741Ab3CKDLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 23:11:07 -0400
Message-ID: <1362971451.3937.29.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Bug#700333: Stack trace
From: Ben Hutchings <ben@decadent.org.uk>
To: "Venkatesh Pallipadi (Venki)" <venki@google.com>
Cc: 700333@bugs.debian.org, vitalif@yourcmc.ru,
        LKML <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>
Date: Mon, 11 Mar 2013 03:10:51 +0000
In-Reply-To: <15ec7b46ebd929a67caea0d80b324af9@yourcmc.ru>
References: <4bded8a24b0719d575f6ffa6b38aebb6@yourcmc.ru>
	 <1362490501.3768.409.camel@deadeye.wl.decadent.org.uk>
	 <1b81bc6219ee47a5b8e53d03e9944939@yourcmc.ru>
	 <20130305203952.GZ9079@decadent.org.uk>
	 <4e8c511dcfd811c0f2ab822adaf52e50@yourcmc.ru>
	 <1362536476.3768.416.camel@deadeye.wl.decadent.org.uk>
	 <15ec7b46ebd929a67caea0d80b324af9@yourcmc.ru>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-y+D7Ymbc+kblDSjmSnCt"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-y+D7Ymbc+kblDSjmSnCt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-03-06 at 15:27 +0400, vitalif@yourcmc.ru wrote:
[...]
> Stack trace picture is here:=20
> http://vmx.yourcmc.ru/var/pics/IMG_20130306_141045.jpg

Vitaliy reported that his system crashes when suspending to disk.  This
was a regression from 3.2 to 3.7, and remains in 3.8.  Some details of
this system are in the bug log at <http://bugs.debian.org/700333>.

The photo shows a BUG in hrtimer_interrupt() after making the
hibernation image and while resuming the non-boot CPUs.  The HPET
interrupt handler was called immediately after it was registered for CPU
2 (?), before the corresponding clock_event_device was registered.

Seems like an obvious race condition, but then shouldn't the HPET have
been stopped while the CPU was previously offlined?  And it's strange
that this system apparently hits the race quite reliably.

Ben.

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption] would be
development of an easy way to factor large prime numbers. - Bill Gates

--=-y+D7Ymbc+kblDSjmSnCt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUT1LO+e/yOyVhhEJAQpr9g//dRiTdOcEV87jOim9lykdY0JCyty1gWFd
gkWUZRknUSm7rx0oy2EtUFK24NBCESh6VsTocfwBWJJEnysVcfjgHQiWAZtLB6Fg
0zaRS+T7oeqsSmT8iu2qXngOftnjrwk3MBDRVv20zd9OXKsC+gy2GakcJWBc7+AC
cIhdcczYeSCXE8g63TWKB8VsI1ls4nGGrp5ZlgSQ/rCf7bG8kMZMC3KmB7IYwAUq
r7mmurECw2ojzlCF9KK+woru8cvoadgs9/ANYoy2DMhm27V5o4QDg0k7R+f7Z/aL
nrxz2BBBUzBd0/sbhTZAh7qfviNDj0quJMghFIDgyV84wlgrvuwrau1Z5h3vd0IW
5KACunjJVc4way2okNV1GMqBt/XZa0qAU6Vt1bw5tDNCj8BooUmRhajWCbx8R0a0
8p0Q0fS1Nq+G8xTr3Pj+w9/WYClLwMXLSMPUxtvyH/vuTj27EMrMYCSryajlfxaT
bGoUh94H9Mqrcq5pqWaqH87aXO0JK5EwHL3zAtS2yKRXb9tDV0ogvGmLNOvYmT4c
0bB51CWBVU7jA2Xyks0A3JRIBtbAohNX922OATCDOzbYSxSWRTubYaeV1imzGLsR
V7tGlPGTpcTJFeRJ89iue1C6klbnn3F1A/uYj/tCPRPJaqJ0faaJP+b+HIYnJ1oN
J4vmqGaqm9Y=
=8MMK
-----END PGP SIGNATURE-----

--=-y+D7Ymbc+kblDSjmSnCt--
