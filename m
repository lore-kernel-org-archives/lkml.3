Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaLWSgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 13:36:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33661 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbaLWSgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 13:36:52 -0500
Date: Tue, 23 Dec 2014 12:36:33 -0600
From: Felipe Balbi <balbi@ti.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: Restore deferred probing path
Message-ID: <20141223183633.GH9147@saruman>
Reply-To: <balbi@ti.com>
References: <1417694767-18848-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G44BJl3Aq1QbV/QL"
Content-Disposition: inline
In-Reply-To: <1417694767-18848-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--G44BJl3Aq1QbV/QL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 04, 2014 at 01:06:07PM +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> Commit 1290a958d48e ("usb: phy: propagate __of_usb_find_phy()'s error on
> failure") broke platforms that rely on deferred probing to order probing
> of PHY and host controller drivers. The reason is that the commit simply
> propagates errors from __of_usb_find_phy(), which returns -ENODEV if no
> PHY has been registered yet for a given device tree node. The only case
> in which -EPROBE_DEFER would now be returned is if try_module_get() did
> fail, which does not make sense.
>=20
> The correct thing to do is to return -EPROBE_DEFER if a PHY hasn't been
> registered yet. The only condition under which it makes sense to return
> -ENODEV is if the device tree node representing the PHY has been
> disabled (via the status property) because in that case the PHY will
> never be registered.
>=20
> This patch addresses the problem by making __of_usb_find_phy() return an
> appropriate error code while keeping in line with the above-mentioned
> commit to propagate error codes rather than overwriting them. At the
> same time the check for a valid PHY is decoupled from the check for the
> try_module_get() call and a separate error code is returned if the
> latter fails.
>=20
> Signed-off-by: Thierry Reding <treding@nvidia.com>

you forgot to add the magic "Fixes: foo bar" here, I'll add it this
time, but I've already sent my -rc2 pull request, so this will only show
up on -rc3.

--=20
balbi

--G44BJl3Aq1QbV/QL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmbYxAAoJEIaOsuA1yqRE8PEP/0uc4yF222Ww0+FCLALF5L5v
eJSmBWALhU8SACvSlF72+r0nvuhdIy58gn5oBWaJo3g/QP/35QDMDmnyWk23F8Vd
AsWNOGtrq4QoJOwDaJ1eJKSNModrsbMf4vurNp7RSvsjMnddU0iW87qgHhVCi3G5
gxZXG0SYJ0Um14HVghuIYZauT2J/zi8P06CcB+hUuwRjeyclpoA0zsU0VTaZ0PTE
nhp9wM+En9AoO1MNhoR4Toyu2bT8TwX0b1e4V61d4RT2Z+JROkKnK732JWjl+duV
jhpUaX1e82JLMRL5+1obR3LShEijpNdIBm4nQM6lTg/mrVEGgb0oUpfVUZTAsoyw
7DgeJKVquL+zNeuYPlrdP9Q6H+CS/mIRqsc8hYWWa8LWN3McCi/xz0wY93doVmAZ
n7rOpdnQWAfU2nimBWbSBlT57Ko4EQppLhqdMuiPUG585fUod1ZtAjuHP65CwWgt
KJGENm3UhSsK2P9nzIpkpPQ/Pqwe2fKninJQ8IwBZODYn/5EX4+m3MZtz8HEpNE+
eiKIiOlZBCpMDdvRYY3sz5JS2yT1qxt5LDgfDtR8h6CqAVowGc1g75+MaJ5sJCXG
W18u37UsLGcMj6uOi7Uj2UQB86C8hytMkdSUTPwmy/lXAMlI3LtlSQITo6RorntO
BYB39aFQUw4kEu059rt0
=SEIG
-----END PGP SIGNATURE-----

--G44BJl3Aq1QbV/QL--
