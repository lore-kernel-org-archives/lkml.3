Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbbAFKTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:19:16 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59616 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbbAFKTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:19:10 -0500
Date: Tue, 6 Jan 2015 11:19:05 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: balbi@ti.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: phy: Restore deferred probing path
Message-ID: <20150106101904.GA31830@ulmo.nvidia.com>
References: <1417694767-18848-1-git-send-email-thierry.reding@gmail.com>
 <20141223183633.GH9147@saruman>
 <54AAE71F.2040809@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <54AAE71F.2040809@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 05, 2015 at 12:33:51PM -0700, Stephen Warren wrote:
> On 12/23/2014 11:36 AM, Felipe Balbi wrote:
> >On Thu, Dec 04, 2014 at 01:06:07PM +0100, Thierry Reding wrote:
> >>From: Thierry Reding <treding@nvidia.com>
> >>
> >>Commit 1290a958d48e ("usb: phy: propagate __of_usb_find_phy()'s error on
> >>failure") broke platforms that rely on deferred probing to order probing
> >>of PHY and host controller drivers. The reason is that the commit simply
> >>propagates errors from __of_usb_find_phy(), which returns -ENODEV if no
> >>PHY has been registered yet for a given device tree node. The only case
> >>in which -EPROBE_DEFER would now be returned is if try_module_get() did
> >>fail, which does not make sense.
> >>
> >>The correct thing to do is to return -EPROBE_DEFER if a PHY hasn't been
> >>registered yet. The only condition under which it makes sense to return
> >>-ENODEV is if the device tree node representing the PHY has been
> >>disabled (via the status property) because in that case the PHY will
> >>never be registered.
> >>
> >>This patch addresses the problem by making __of_usb_find_phy() return an
> >>appropriate error code while keeping in line with the above-mentioned
> >>commit to propagate error codes rather than overwriting them. At the
> >>same time the check for a valid PHY is decoupled from the check for the
> >>try_module_get() call and a separate error code is returned if the
> >>latter fails.
> >>
> >>Signed-off-by: Thierry Reding <treding@nvidia.com>
> >
> >you forgot to add the magic "Fixes: foo bar" here, I'll add it this
> >time, but I've already sent my -rc2 pull request, so this will only show
> >up on -rc3.
>=20
> Presumably also add the following, since the patch fixes a regression in a
> previous kernel release:
>=20
> Cc: stable # v3.18
>=20
> ?

The offending commit was only merged in v3.19-rc1. That's also the
reason why I didn't deem it necessary to include the Fixes: line. Given
that the patch was posted prior to the merge window opening and that it
fixes a regression I had assumed it would be merged in the same pull-
request as the commit causing the regression.

Thierry

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUq7aYAAoJEN0jrNd/PrOhokQP/RXoF2PjOcxRDZersVLLYWNy
P4wMHodrD3THk2oi7YcYK0JIsLz4ptbdSWqS9AiTf2cF7qp9VThDKxGltQJF4yRS
dOgGPyyjXpepkc7sn23lqp0soOzHeJQmMVXHs/k77QhnVFQz946YInGEttJrXzt6
9PgB5OVZsXlxT8qiy0fpdq1QyHSubWss8/+CyZY4KjG7FAsV1OOQKbAxedB+xWxf
8S3akLKnwmxsPNHCsgA02HAhQ+bptBSew6nFlSQIND4UAcd8KdMEhvjTE6w9U4ko
rI3zmtsrvEkX7TH9yEboDNMX2qj1FSQtuRFtTZAR373H8zWI0nSwAV6YCd9lXqKk
MWwevdbCGz8OotAv0SPGf8Yhc/FDyMHN90ux+0aCwdNPNayp/ejygxaNKhZmoOno
ki60HSe4Jr3kc40gQ7MxHkRoQKoXBS6fkvtk02x8HPLyYqqh+xzOsnld/HKUbLjY
DWRu0tMLtgVkjZJE3dj7755Bf2MY/I870QHEsWbZ4wzN8rGOibNRrKtI4np80Iiz
THEhnNN5NEOoJHnUcYJyUK3n4fJdX/73N9ifP0SjYYlW2yoWeR/b2U76E5TdHg7J
yFC6y7jA7dA21zFmyS2mMqrTZHVriCrm/JfUrAXzJjf0xbyLIen/twm+tGavA2vm
NY4O675P49+jJKJVEE4i
=+Jqe
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
