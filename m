Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab3ARDB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:01:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49649 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753846Ab3ARDBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:01:54 -0500
Message-ID: <1358478106.15692.159.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 013/222] iscsi-target: Fix bug in handling of ExpStatSN
 ACK during u32 wrap-around
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Steve Hodgson <steve@purestorage.com>,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 18 Jan 2013 03:01:46 +0000
In-Reply-To: <1358351822-7675-14-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
	 <1358351822-7675-14-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-kmEGAmxiXjC35w7CdbdO"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kmEGAmxiXjC35w7CdbdO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-01-16 at 13:53 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7.3 -stable review patch.  If anyone has any objections, please let m=
e know.
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
>=20
> Signed-off-by: Steve Hodgson <steve@purestorage.com>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> [ herton: hdr->refcmdsn has the converted be32_to_cpu value on 3.5 ]
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>
[...]

You need this as well:

commit 044882a62f34cd6460196c13773bd210be39d717
Author: Roland Dreier <roland@purestorage.com>
Date:   Mon Jan 7 11:45:16 2013 -0800

    iscsi-target: Fix CmdSN comparison (use cmd->cmd_sn instead of cmd->sta=
t_sn)

Ben.

--=20
Ben Hutchings
It's easier to fight for one's principles than to live up to them.

--=-kmEGAmxiXjC35w7CdbdO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUPi7Gue/yOyVhhEJAQrFBhAAyomLtZSZz+sXHpqO9B8+EO52FZRVPjOv
3EtXiUQSG/12lPysvb1Mm4tSUruAikoUwaxyFkh9cRWbH5bBfXjtkJFIRdcQhgSk
omeXxQKwJ5m2wEdYf8612jB+/JyDFlrosKYUcHjfKWmq6L8Ka0zVzY88ePIbJpG1
eq1akofR1mpWHYKxk7i9DBd5kA9gCkBghSG+ipKuGokSWPwkz81rbRYiQFXvJKSC
+UZ3vD+Aqo1zGZ2r/b562XmfwdBskx8/FVB/Nc2mBfAiAr1yVsZIa5tHBxX/krpl
XOst2fUBYE4yHSx7MHXF0ilIKWspjWi81ruGaeVMLUsNmVv/QZH9AEa1+YXpPUxJ
01bSPr24duN2isnPh7Dej/MB4wIfIQm24DQRSJyf/Myy18AAjR+2kiQQPlh7zrPv
A+rDUn633+KE7ieWWUX014ywbZ6fCJKxI2k9PB+KZ5h+z/Ifg5UZoRRZNo5R+2EF
oLGQgnmpvpoOEjV6Jx/w4GaR0v0/Hg8s5/yrnCgq8gZtvhp7mZ7zki9CPbFEYY9i
swRmG0RWpvlaFxpcRaAvkLexbl9nQ41VAMf5ozNPYvHljv9OJPcfLRhhYdSAA0WA
HndAltqnhFxDjACh3QZFIl6BgSOcf2wOr7CRsDTFCxOlvqTESy+Gyc6oLHG+fFXw
nckRk94ozi4=
=hE4R
-----END PGP SIGNATURE-----

--=-kmEGAmxiXjC35w7CdbdO--
