Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab3LRAOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 19:14:19 -0500
Received: from home.keithp.com ([63.227.221.253]:52950 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab3LRAOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 19:14:18 -0500
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/intel: Only smash VGA SR01 register if intel is default VGA device
In-Reply-To: <20131217185742.GP22448@nuc-i3427.alporthouse.com>
References: <1387300330-8844-1-git-send-email-keithp@keithp.com> <20131217172740.GM22448@nuc-i3427.alporthouse.com> <86bo0fs5or.fsf@miki.keithp.com> <20131217185742.GP22448@nuc-i3427.alporthouse.com>
User-Agent: Notmuch/0.16 (http://notmuchmail.org) Emacs/23.4.1 (i486-pc-linux-gnu)
Date: Tue, 17 Dec 2013 16:14:11 -0800
Message-ID: <868uvjrp64.fsf@miki.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Chris Wilson <chris@chris-wilson.co.uk> writes:

> Ok, so as no vgaarb_clients have yet been registered and so the call to
> grab the IO resource does not actually disable VGA IO routing to the
> nvidia card.

Yikes! This explains a lot.

> If you care to update the changelog to explain the problem is that
> vgaarb is ineffective before all clients are registered, then I think
> this is a good temporary hack. It should be possible for vgaarb to mark
> resources as locked if the device is interpretting IO access and has no
> method for disabling the IO grab (and then a vga_tryget() check here).

Sounds like vgaarb should not assume that all devices using VGA are
registered drivers. That also sounds like a significantly harder fix.

If SR01 is required before disabling VGA, then perhaps we should not
disable VGA at all in this case though. That sounds safer, although if
VGA was enabled, it will suck a bit more power?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUrDo09siGmkAAAARAQizyBAAkpzPhAIC3btkcJzA10q1+/CX0Xjlbknq
ZTkKh/09/IiYwxEp3vBZvXMnPtG4Vy+O6C/C0a360x672j49QIkeG6/IWZwcHLgO
eObAKEiQOaKG55G1etYf/Sj541gV9MIH0VnjCDlzKh7s15lUgfoT2ZMTvFHKF9lt
q0vzTRegphX1x5i7HtWdF/tEci5dgL8XvpV86+xDDUHoQbA1lhAkEzq+FFcMy3+8
ic67DQU9mexUse41R30pvKJDYenQRznHSBEEWxuz/8YSH1sgGC2LsMsRxI6sUQCT
gX4MKdRFVkPZ6/ahrAIICQVcokdaEPW2zVPEG6dcZQic9WzzVHphBEtzvsUeSGad
putqhcZlaXln0C3HVf9NU4R6YVMLuyyEDdcrtXuc9AxO8CaETGJ9GkkCAKLbKk4h
jncqQ7qc2edeMVpjDk8pZtmDEf1C1+7omYSRb6GgNeCoSsM6OZlU8lTdCa+9ehBk
YbhIWA30Cgp5pJhV3WoJTUm/oiVqGxujoog0QuOSCc2cYD7d+WRBatL8GxGJoWOS
3/vMtIN52pn74+xesdQff05IIkXdunQPwOoCkczC2XhMyQOqF3UsieVXIH75yQO7
rXo17mn1xY1tM7dZXC/0/zVIFXjlc5BrtHM2XgWmHdU51IaXW912qpZLXf7u8k+k
FzoMovwq/bA=
=ECkU
-----END PGP SIGNATURE-----
--=-=-=--
