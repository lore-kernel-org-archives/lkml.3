Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3LQSRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:17:31 -0500
Received: from home.keithp.com ([63.227.221.253]:51161 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab3LQSR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:17:29 -0500
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/intel: Only smash VGA SR01 register if intel is default VGA device
In-Reply-To: <20131217172740.GM22448@nuc-i3427.alporthouse.com>
References: <1387300330-8844-1-git-send-email-keithp@keithp.com> <20131217172740.GM22448@nuc-i3427.alporthouse.com>
User-Agent: Notmuch/0.16 (http://notmuchmail.org) Emacs/23.4.1 (i486-pc-linux-gnu)
Date: Tue, 17 Dec 2013 10:17:24 -0800
Message-ID: <86bo0fs5or.fsf@miki.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Chris Wilson <chris@chris-wilson.co.uk> writes:

> The bspec still says we must assert SR01 bit5 prior to disabling the VGA
> plane.
>
> Perhaps the test should be whether (vga_reg & VGA_DISP_DISABLE) =3D=3D 0 =
and
> do nothing if the plane is already off.

The problem is that for some reason we're smashing *some other video
card* when it's being used via efifb.

I'm wondering if vgaarb just doesn't work because efifb isn't telling
vgaarb that it's using those registers (I mean, how would it even know?)

The other simple option is to just not disable VGA if the card isn't
primary; presumably it wasn't ever enabled.

And, yes, I know that the card probably won't work at all if it isn't
primary because so much currently depends on the BIOS setting up bits of
the card that we can't autodetect. So, another simple option would be to
just refuse to load the driver if the card is secondary...

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUrCVNNsiGmkAAAARAQjGEQ/9HzU/ZzwHyZLjBl5EtXxpnL8vFImuoc5I
W/Z2tTh7ZjDpBjjU4J80CnYNFwhmGDhKkp7Hq0cja4fif3ZctX+XfD1c4TrdA3mn
478FWHXcJPQg+tCJSSUpISckTn28z0s9lKG6Ophb/lkAioSxt3obuly5lC943etu
TH6fSCO2BDnNR+axBUcafXKC4W/NGuXilOE6q5kAQfxDUOZnDcRj8WqW12jrHrD6
9pM8mxtjDZoNJT8ZPpMHXasFdPHGLJS6d6g6ATUYlqzFLXANubiCadElMTn45ddL
nb63ONnfC9YQfWu5t23PwZsEQIzflXyRvf1NWWwsMNPEX05Qm1Jljo3sYv5YQ5ZP
YResCivNH+73Cc+nZEe2H9eNDQArUKk+WaGa6pQF6oGykX3Ygql6V9XiszGUqbCT
+eE5f834gqa/JBy4ynie5na1f0FY+B3hJZ8xRWzdBPIyZWGt/Mbqhu3en6ir3SLE
Qtv/+GH+onDyCg1VXpwgwuzyq+Gs2GWwQfZg7l93JTfCZ0Tx7Muf6S491kThea54
jDHXe2qcm/BGswh7zwH7NzTazVehZcNhF6eAowGjAEgZeC9NXT7CDwr4qNy99aRf
o4D5Beuq+79pRKCHKMq3HrnlvA17SULI5Uw1ej8kGX8PzVJQjx1TPuRh6ZS6G9Ku
lj8ViTNDMOY=
=xp8Q
-----END PGP SIGNATURE-----
--=-=-=--
