Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3LHHzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 02:55:35 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:62141 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab3LHHzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 02:55:31 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH 03/16] wl1251: add sysfs interface for bluetooth coexistence mode configuration
Date: Sun, 8 Dec 2013 08:55:24 +0100
User-Agent: KMail/1.13.7 (Linux/3.12.0-5-generic; KDE/4.11.3; x86_64; ; )
Cc: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, David Gnedt <david.gnedt@davizone.at>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com> <1382819655-30430-4-git-send-email-pali.rohar@gmail.com> <1383003587.3779.49.camel@bwh-desktop.uk.level5networks.com>
In-Reply-To: <1383003587.3779.49.camel@bwh-desktop.uk.level5networks.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2345310.ei2vD9nNdm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312080855.24999@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2345310.ei2vD9nNdm
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 29 October 2013 00:39:47 Ben Hutchings wrote:
> On Sat, 2013-10-26 at 22:34 +0200, Pali Roh=C3=A1r wrote:
> > From: David Gnedt <david.gnedt@davizone.at>
> >=20
> > Port the bt_coex_mode sysfs interface from wl1251 driver
> > version included in the Maemo Fremantle kernel to allow
> > bt-coexistence mode configuration. This enables userspace
> > applications to set one of the modes WL1251_BT_COEX_OFF,
> > WL1251_BT_COEX_ENABLE and WL1251_BT_COEX_MONOAUDIO. The
> > default mode is WL1251_BT_COEX_OFF.
> > It should be noted that this driver always enabled
> > bt-coexistence before and enabled bt-coexistence directly
> > affects the receiving performance, rendering it unusable in
> > some low-signal situations. Especially monitor mode is
> > affected very badly with bt-coexistence enabled.
>=20
> [...]
>=20
> This should be implemented consistently with other drivers:
>=20
> drivers/net/wireless/ath/ath9k/htc_drv_init.c:module_param_nam
> ed(btcoex_enable, ath9k_htc_btcoex_enable, int, 0444);
> drivers/net/wireless/ath/ath9k/init.c:module_param_named(btco
> ex_enable, ath9k_btcoex_enable, int, 0444);
> drivers/net/wireless/b43/main.c:module_param_named(btcoex,
> modparam_btcoex, int, 0444);
> drivers/net/wireless/ipw2x00/ipw2200.c:module_param(bt_coexis
> t, int, 0444);
> drivers/net/wireless/iwlegacy/common.c:module_param(bt_coex_a
> ctive, bool, S_IRUGO);
> drivers/net/wireless/iwlwifi/iwl-drv.c:module_param_named(bt_
> coex_active, iwlwifi_mod_params.bt_coex_active,
> drivers/net/wireless/ti/wlcore/sysfs.c:static
> DEVICE_ATTR(bt_coex_state, S_IRUGO | S_IWUSR,
>=20
> Oh, hmm, I see a problem here.
>=20
> Ben.

So where is consitency? Each driver doing this in different way:
btcoex_enable, btcoex, bt_coexist, bt_coex_active

Reason for this usage in wl1251 is to not break existing=20
userspace applications.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2345310.ei2vD9nNdm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKkJewACgkQi/DJPQPkQ1LKdQCgptn5HXUuYwcCHK4pgdvBEbzq
76YAnj3gOet+wgILzY+7bT8stsPHNQPk
=9GAl
-----END PGP SIGNATURE-----

--nextPart2345310.ei2vD9nNdm--
