Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbaCMVPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:15:42 -0400
Received: from sauhun.de ([89.238.76.85]:34074 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbaCMVPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:15:40 -0400
Date: Thu, 13 Mar 2014 22:15:32 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: David Howells <dhowells@redhat.com>
Cc: wolfram@the-dreams.de, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: Add message transfer tracepoints for I2C [ver
 #2]
Message-ID: <20140313211532.GA2696@katana>
References: <20140306133559.29345.61422.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20140306133559.29345.61422.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 06, 2014 at 01:35:59PM +0000, David Howells wrote:
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
> 	... i2c_write: i2c-5 #0 a=3D044 f=3D0000 l=3D2 [02-14]
> 	... i2c_read: i2c-5 #1 a=3D044 f=3D0001 l=3D4
> 	... i2c_reply: i2c-5 #1 a=3D044 f=3D0001 l=3D4 [33-00-00-00]
> 	... i2c_result: i2c-5 n=3D2 ret=3D2
>=20
> formatted as:
>=20
> 	i2c-<adapter-nr>
> 	#<message-array-index>
> 	a=3D<addr>
> 	f=3D<flags>
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

Applied to for-next, thanks!


--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTIh/0AAoJEBQN5MwUoCm26VoP/3t5v0cYUHKCne324hMPQeyk
F4ILNoKQdLQF7kd5O1G+uOKJ6Y7frOe+z12WwFkXDMDbkakiXfJgAbq9Kc8E6vhg
wXI0tTmRuoxTzmHPod3ftQPbVlpSNrJCntp/B4bcUYBxVbyfWHs8SyBCXIV7P7xQ
PESTOoJDhDlO31xAZdx2RPwK7C6PZhqjG3L8ri2X3uy6hEJoKQiDgJaLThQYzZ22
VP2NgxYetiLrMXtThH+mh77OOrK4FAcf8RS8jLTCu+0/LoOeuzu4aLXOMr3HJufR
tMA49BcEv8EsIfHzduYIZ6pnnXIB81FnJxKOPE9R2+QzSsaMmebx0cISoPAjf6Bl
XTRnN5YmiS8pNIwCU9AogFNABrNZDieEcXAZhn8I+83ZdIMUXVNfE4avrLOWHQ3l
XZVeSvyCxgavz6XQDamXYQlCmVPr/FdL2tlkEUfDwGBkK6MxRf5LLJsxyf9+rL9L
B+QIh1Fo6cPJO76FiJ0nFg+YP4S/uF7OKLXZPnNm12qVvN17leEa9s0JwBNhA8Qg
HuX7nc11X8OScxtXQVi1txaqT53lxhkONupl7QlZqlUcAv/njdCw8JUfYfBo3E71
CAy1minOo88oli9qZdQqDMQcTQw6yr7k2LbHA44TXR00Aiaz8cJNlFIdUZMMK9QS
IxopRyciUcAnluw9ZNcZ
=eAgh
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
