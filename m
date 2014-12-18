Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaLREog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 23:44:36 -0500
Received: from omr1.cc.vt.edu ([198.82.141.52]:32900 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbaLREoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 23:44:34 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: NeilBrown <neilb@suse.de>
Cc: Nicholas Krause <xerofoify@gmail.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:md: Remove no longer needed fixme comment in raid5.c
In-Reply-To: Your message of "Thu, 18 Dec 2014 10:19:06 +1100."
             <20141218101906.55b7772d@notabene.brown>
From: Valdis.Kletnieks@vt.edu
References: <1418831373-18415-1-git-send-email-xerofoify@gmail.com>
            <20141218101906.55b7772d@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1418877863_3430P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Dec 2014 23:44:23 -0500
Message-ID: <4371.1418877863@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1418877863_3430P
Content-Type: text/plain; charset=us-ascii

On Thu, 18 Dec 2014 10:19:06 +1100, NeilBrown said:
> On Wed, 17 Dec 2014 10:49:33 -0500 Nicholas Krause <xerofoify@gmail.com> wrote:
>
> > Removes the no longer needed fix me comment related to not needing the agrument faster for the function,
> > sync_request. Due to getting warnings when building without the agrument it seems that this fix me was
> > wrong and we must keep this agrument in order to avoid build warnings when building without it.

Examining raid1.c, which *does* use the go_faster parameter, I suspect
that the *real* meaning of the FIXME is that the code in raid5.c *should*
possibly be doing this that's done in raid1.c's sync_request():

        /*
         * If there is non-resync activity waiting for a turn,
         * and resync is going fast enough,
         * then let it though before starting on this new sync request.
         */
        if (!go_faster && conf->nr_waiting)
                msleep_interruptible(1000);

(Which is one of the few flow differences for the sync_request() code
in raid1.c versus raid5.c.  I'll however defer to actual RAID experts
on whether raid5 needs resync throttling, or if it's accomplished via
other means I'm not spotting.  Finding a FIXME outside of drivers/staging
is usually a "Here be fearsome and nasty dragons" comment....


--==_Exmh_1418877863_3430P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVJJbpwdmEQWDXROgAQKUcw//QIAx0CGAwZCP9ih0GupbNBsJu5xmdryP
WElaB6MMMuwXsSuHfJ9SH1ZIm525QjOsixp8bN6SSJ0GOYyvZtnHEHbUyPRD5l72
v3CfQFAxTPcHPtMWiWI4dTxW3ehMgVeW8FMZsQAOJMpwApnUGsuyjQ0k7R8Wa7R0
kOcFDC3/urSRMt0MCUaexnG+7PziGnWFrjkgT/hevrnQrp3APLuMxvhKeDkul7lI
N8wpbfp9RvVbfj5LE4rtOnwwccMzij9DDFW3veG0k/LvbSf+NRG0o6jg5zM5zIIb
EIKZ8iqoUsp21VoVOd6gzK9789q09h9wW/B96h0w9o2xIUsMJCnbwhAvpbzPnzGP
r+cRq9XtQXIvhbKsbvW8X/DK/OJLTddPgX8br9AbJTGuHtAlHGz7rjzmcxhbQu6S
9uy9GN+IIHyyGJppN3/RI+vyU4xvus4wTJdd5StHTDMW7B2180sT3jrOtl4dJZ5Q
wN11nZHPLTP8b8c3AC+dPKgogoOdh4LTr5LmnZWj0n41REjA8xXQ5OEBAo75zDxm
GgwTNgPsrKnNmwhr05AchbysevZv6WF4xODdbdAlWPlwCgSqVKZIrt0/1SpvSjT2
xODRtq4j67prNx68wVSqTP5oTZXZraQ71W7MqwfD3MqFhdUt4TXkW1PenIfxcmwH
vhu73FtJ6TQ=
=At2c
-----END PGP SIGNATURE-----

--==_Exmh_1418877863_3430P--
