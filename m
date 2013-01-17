Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab3AQNhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:37:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44402 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058Ab3AQNhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:37:35 -0500
Message-ID: <1358429844.15692.134.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 037/221] iscsi-target: Fix bug in handling of ExpStatSN ACK
 during u32 wrap-around
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Steve Hodgson <steve@purestorage.com>,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 17 Jan 2013 13:37:24 +0000
In-Reply-To: <20130115185000.709964724@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
	 <20130115185000.709964724@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2gzcir26HTctEwjEBAxd"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2gzcir26HTctEwjEBAxd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-01-15 at 10:49 -0800, Greg Kroah-Hartman wrote:
> 3.7-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Steve Hodgson <steve@purestorage.com>
>=20
> commit 64c13330a38935120501b19c97a3e6095747c7a1 upstream.
>=20
> This patch fixes a bug in the hanlding of initiator provided ExpStatSN an=
d
> individual iscsi_cmd->stat_sn comparision during iscsi_conn->stat_sn
> wrap-around within iscsit_ack_from_expstatsn() code.
>=20
> This bug would manifest itself as iscsi_cmd descriptors not being Acked
> by a lower ExpStatSn, causing them to be leaked until an iSCSI connection
> or session reinstatement event occurs to release all commands.
>=20
> Also fix up two other uses of incorrect CmdSN SNA comparison to use wrapp=
er
> usage from include/scsi/iscsi_proto.h.
[...]

You'll need to add this fix:

commit 64fe4f4f181cc2fe97d4176bf6ee6e3725ae33ec
Author: Roland Dreier <roland@purestorage.com>
Date:   Mon Jan 7 11:45:16 2013 -0800

    iscsi-target: Fix CmdSN comparison (use cmd->cmd_sn instead of cmd->sta=
t_sn)

Ben.

--=20
Ben Hutchings
I'm not a reverse psychological virus.  Please don't copy me into your sig.

--=-2gzcir26HTctEwjEBAxd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUPf+lOe/yOyVhhEJAQoY/Q//YCSCQ8U1RF4/96tcLQfyYA/+pjGy4j5H
erHtOdjziFKVJkJygpvVZ6LYDaPfFf3PDirrVM6XZZ752CxplX4LgtSjDKuVUADM
oave4o/z+MGh9DXXupX1UrPSSSHe+JPp6uE7l80ohwHWKQKjSDb0dy6+klvzH7C+
tdr9izkfz9JIa6AAl/v76n839OqCrvEup6UXYHGrzJC81M9fo0VIcznM+tP9wD/Q
fzJS7OTCGlZ769NR9A0UODMu4u6pF38Up7FvrKQNJP0OuleULPbFduEyBnLC6bE4
/GA9N3mkrcHmFcrdFdsYQz47GJIKn9EFMjfBFf8FNLNtfaj55nxPWNnYMmVhRd+8
g/QdS7eG8W8qCjcje8BTSRtTinTOAhj1oe2NI2C6REL3o9x4+TMdGE5AOHv+xkSY
PCDpvpqvBBnzWfqDfjKJXUxszLMHctHZiS2wgm1KW3exo1Rz2jdYdMCZ2U0+iUWL
47DJu0neKCzQLxK8hUL0HqchfU5UpeZj8GVwE9gnCct6PIe34C0bL8rcpjmB8Gu9
UQuSgpC1uYjeIe0YtaYz0XxQ2ZLlA5xK+9lQ39kHPr/KvwbJSJNKtmOB0uusmBcZ
GLV5+t5qdIIp1YogxF4txfzAGj7iKRVi+OCYmqWIGxJft1QWgGoML8g0O8I7fHNe
ZGQiQ3nI6to=
=v3zg
-----END PGP SIGNATURE-----

--=-2gzcir26HTctEwjEBAxd--
