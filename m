Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaAVTJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:09:20 -0500
Received: from sauhun.de ([89.238.76.85]:38012 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaAVTJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:09:17 -0500
Date: Wed, 22 Jan 2014 20:09:06 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: David Howells <dhowells@redhat.com>
Cc: wolfram@the-dreams.de, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: Add message transfer tracepoints for I2C
Message-ID: <20140122190906.GA2608@katana>
References: <20140109214954.25590.73057.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <20140109214954.25590.73057.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09, 2014 at 09:49:54PM +0000, David Howells wrote:
> Add tracepoints into the I2C message transfer function to retrieve the me=
ssage
> sent or received.  The following config options must be turned on to make=
 use
> of the facility:
>=20
> 	CONFIG_FTRACE
> 	CONFIG_ENABLE_DEFAULT_TRACERS
>=20
> The I2C tracepoint can be enabled thusly:
>=20
> 	echo 1 >/sys/kernel/debug/tracing/events/i2c/i2c_transfer/enable
>=20
> and will dump messages that can be viewed in /sys/kernel/debug/tracing/tr=
ace
> that look like:
>=20
> 	... i2c_write: i2c-5 #0 f=3D00 a=3D44 l=3D2 [0214]
> 	... i2c_read: i2c-5 #1 f=3D01 a=3D44 l=3D4
> 	... i2c_reply: i2c-5 #1 f=3D01 a=3D44 l=3D4 [33000000]
> 	... i2c_result: i2c-5 n=3D2 ret=3D2
>=20
> formatted as:
>=20
> 	i2c-<adapter-nr>
> 	#<message-array-index>
> 	f=3D<flags>
> 	a=3D<addr>
> 	l=3D<datalen>
> 	n=3D<message-array-size>
> 	ret=3D<result>
> 	[<data>]
>=20
> The operation is done between the i2c_write/i2c_read lines and the i2c_re=
ply
> and i2c_result lines so that if the hardware hangs, the trace buffer can =
be
> consulted to determine the problematic operation.
>=20
> The adapters to be traced can be selected by something like:
>=20
> 	echo adapter_nr=3D=3D1 >/sys/kernel/debug/tracing/events/i2c/filter
>=20
> These changes are based on code from Steven Rostedt.
>=20
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

Thanks for doing this, much appreciated. One of the first things I'll
review (and play with) next. But hey, has nobody else checked this out
by now? Tested-by or acks very welcome.

Thanks,

   Wolfram


--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS4BdSAAoJEBQN5MwUoCm2rggP/R/BwlZesLXaDae//yHYXz1S
3FcONL/jZEkDcaQlBj+kVFM7pvriWFLxVGLQqiqrD8ZJbJkqAHLFnCuLgeip5HcB
e8YT1+bivMr9AMEUfMP4T9CQeELV35l1k/BfPBatrHP9xSCWVopZc90LmOVmQBDZ
mqaAVsBkKbMILwZ1K1zocnGwqo0QzpvEjKSKYC0q1dKnijZ4KhbPV0AfamkQVO4Y
oAmNfNvrk+/iwD5tE5dLf6y+f5R1o8BfYVQwewCwymXaKOgbfzLfcstqer0ckcnp
NXIepVg8jf1/ZhdxOvUy0fLWzze9gNKtbgphuZSrpg5ri2ojymG2WfCHpJwnWeKG
HfBAOAYYzvlVRCuXqoZ83rBL5/sX6YZggKBZG5lsSoz+kMOBOMTmz6K7lFJR2tob
5aCPLOmQ3f7YCxa0/RdR2YEk1rwz6SONrZzTEBj0SCA41HHYFxtcQh7bRf5UHcq8
i7xI/ygzEp/zu4fqM0ZgtRrP4DniNrFQNiAKA3fxg2uVDgcb1e8e9+3gMiJw1xUx
9CL1SCgqxeqIe70mvYoNoM8K4KXYW4Up/BpgFcsuRpNSSLPZUQrf0ijdDbfSDfoF
1jUw86z5CcqN668jJOXC01vfZyGE3PSdOhzcL5w/T38ULKspjqsuUIdqUwuWn7rj
l7Y2sucWho6HSBdoEZH2
=ZEa/
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
