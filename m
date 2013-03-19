Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934259Ab3CSW23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:28:29 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:50313 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274Ab3CSW22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:28:28 -0400
Date: Tue, 19 Mar 2013 17:28:22 -0500
From: William Hubbs <williamh@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: w.d.hubbs@gmail.com, hpa@zytor.com, rob@landley.net, mpagano@gentoo.org,
        ryao@gentoo.org, gregkh@gentoo.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] init: fix name of root device in /proc/mounts
Message-ID: <20130319222822.GA2338@linux1>
References: <1359672699-23540-1-git-send-email-w.d.hubbs@gmail.com>
 <510AFCA1.5000700@zytor.com>
 <1360032141.12062.12@driftwood>
 <a6a99589-ac94-4cfc-a871-095431bfd8ef@email.android.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <a6a99589-ac94-4cfc-a871-095431bfd8ef@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

All,

I haven't heard any more on this patch, so I wanted to ping the thread
again and find out the status.

The original message is linked below[1].

The issue is that /dev/root appears in /proc/mounts if you do not boot
with an initramfs, but /dev/root is not a device node. In the past, udev
created a symbolic link from /dev/root to the appropriate block device,
but it does not do this any longer. Also, devtmpfs does not create this
symbolic link.

This is causing bugs with software that depends on the existence of
/dev/root [2] for example.

Do you need any more information on this patch, or is there some reason
it can't go in?

Thanks much,

William

[1] https://lkml.org/lkml/2013/1/31/574
[2] https://bugs.gentoo.org/show_bug.cgi?id=438028

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlFI5oYACgkQblQW9DDEZTiqpQCaA2VastTrGEa/ZXJWYhCpq5Vc
KacAniA9CiS+lL9i6AqXTCrDYuMaJa50
=F85/
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
