Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab3IRSN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 14:13:59 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:43767 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3IRSN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:13:57 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 2/2] RX-51: ARM errata 430973 workaround
Date: Wed, 18 Sep 2013 20:13:52 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, Nishanth Menon <nm@ti.com>,
        Pavel Machek <pavel@ucw.cz>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
References: <1362044548-5398-1-git-send-email-pali.rohar@gmail.com> <201309181033.24965@pali> <20130918171816.GT9994@atomide.com>
In-Reply-To: <20130918171816.GT9994@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1431164.Jrtyb74O6d";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309182013.52975@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1431164.Jrtyb74O6d
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Wednesday 18 September 2013 19:18:17 Tony Lindgren wrote:
> * Pali Roh=C3=A1r <pali.rohar@gmail.com> [130918 01:41]:
> > I'm not very happy. I sent this patch 6 months ago and only
> > now you commented that needs rework again. This patch is
> > needed because all thumb-2 userspace binaries crashing. I
> > want to have working support for Nokia N900 and not always
> > rebasing and changing patches. Also DT still not working on
> > N900 (file contains only small subset of devices as in
> > board files plus it is not in stable kernel) so I do not
> > want to switch to DT. I need something which is working and
> > not something new non-working. I belive that you and other
> > kernel guys do not remove all n900 board files until every
> > one line will be rewritten to DT and tested that everything
> > working. And from this and other conversation it looks for
> > me that you are going to do that. So please clarify what
> > you want to do (and when) with board-rx51-* files. Aftethat
> > I can decide what to do in future.
>=20
> Sorry if there's been some going back and forth with the
> patches, I think pretty much everybody wants n900 support in
> the mainline.
>=20
> It's obvious that we're moving everything to be devicetree
> only as discussed on the mailing lists over past few years.
> For most drivers it's already working, and we can still
> initialize platform data too for the legacy devices until
> they have bindings, so it should not be too intrusive except
> for the configuration changes to use appended DTB or a
> chained bootloader with DTB support.
>=20
> > For now I see this situation something like: I wrote
> > patches, send them to ML and after half of year maintainer
> > politely rejected them becuase my patches not using new
> > uber cool technology with still not working and also was
> > not available half year ago. What happen if I find another
> > time to rework this patch and send it again in next 2 or 5
> > months?
>=20
> Hmm hasn't there been pending comments until recently on your
> patches?
>=20

Since 10.07.2013 I do not have any emails for patch 2/2. If I=20
missed something from you, please resend me it.

> It seems that with the changes I suggested your patches should
> work for both legacy booting and DT based booting, so maybe
> just try to update them over next few weeks, let's say by
> -rc3 rather than wait 2 to 5 months? :) No need to test them
> currently on the DT based booting if you don't have that set
> up, just move the code out of the board-*.c file.
>=20

Ok, no problem. I will move code as you suggested.

> > Tony, if you did not have time for review this patch months
> > ago or you found it only today - no problem, I understand
> > it. But what I need to know is what will happen with
> > board-rx51-* files (and when?) You can see that DT does not
> > have definitions of all n900 hw parts (plus it is not in
> > last 3.11 kernel!) which means that DT is not usable for me
> > and other n900 people. This also means that I cannot
> > rewrite my patches for DT and test if they working.
>=20
> I usually stop looking at new code around -rc4 and concentrate
> on fixes until -rc1 or so. So there can be easily one month
> delays on reviewing stuff depending on where we are with the
> current merge window or -rc cycle, sorry if that's annoying.
>=20
> The .dts files will be separate from the kernel soonish, so
> that's not be a show stopper. Just like all the board specific
> .config files are separate from the kernel already. Too bad
> our .dts changes did not get merged for v3.12 because of
> conflicts with other branches, but hey, they should be
> independent from the kernel anyways.
>=20
> The board files will be going away as soon as things are
> working with DT. We've been pretty much only applying fixes
> to them for quite some time now. For the timeline, the
> earliest we'll be able to remove the board-*.c files and
> platform data is for v3.13 assuming the PM dependencies get
> sorted out before that. Making omap3 DT only is going remove
> about 25k LOC, so that's a good reason for doing that.
>=20
> Cheers,
>=20
> Tony

Thanks for clarification.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1431164.Jrtyb74O6d
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlI57WAACgkQi/DJPQPkQ1JXDACfas6684/9ZPirlnHQc0lE47/z
JD0AnA5aiHDaxtpUPX7nQ0QSMFBWf9oX
=YDPw
-----END PGP SIGNATURE-----

--nextPart1431164.Jrtyb74O6d--
