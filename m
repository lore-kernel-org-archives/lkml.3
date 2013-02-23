Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab3BWR7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 12:59:25 -0500
Received: from mail.gw90.de ([188.40.100.199]:40927 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757763Ab3BWR7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 12:59:23 -0500
Message-ID: <1361642349.6787.12.camel@mattotaupa>
Subject: Re: [PATCH] sp5100_tco: Remove code that may cause a boot failure
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Takahisa Tanaka <mc74hc00@gmail.com>
Cc: linux-watchdog@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Arkadiusz Miskiewicz <arekm@maven.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        Florian Mickler <florian@mickler.org>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Joseph Salisbury <josephtsalisbury@gmail.com>
Date: Sat, 23 Feb 2013 18:59:09 +0100
In-Reply-To: <1361619112-7481-1-git-send-email-mc74hc00@gmail.com>
References: <1361619112-7481-1-git-send-email-mc74hc00@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-DmdotBvBK8MiSHgBwj2s"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DmdotBvBK8MiSHgBwj2s
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Takahisa,


Am Samstag, den 23.02.2013, 20:31 +0900 schrieb Takahisa Tanaka:
> The critical problem which can't boot OS until the power is completely
> cut off found on PC with SB700 chipset.

all SB700 boards or just a specific one?

> This patch fix the problem, but, this patch prevents the sp5100_tco
> driver from using watchdog timer function of chipset on PC with SP5100
> or SB7x0 chipset.
>=20
> Re-programming the MMIO address registers for the watchdog timer must
> have generated the problem. However, I don't know root cause so far.
> So, I decided to remove the concerned codes.

Is that problem there since the first implementation or just with your
second patch? (I do not have the commit hashes and summaries ready.)

> Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1116835
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D43176

The Bugzilla entry is not really related to this report. Please make
clear that this is the report the original patch wanted to fix. As
nobody closed it yet, it does not need to be reopened.

You can reference the LKML thread directly though.

https://lkml.org/lkml/2013/2/18/353

> Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
> ---
>  drivers/watchdog/sp5100_tco.c | 140 ++++--------------------------------=
------
>  drivers/watchdog/sp5100_tco.h |   2 +-
>  2 files changed, 14 insertions(+), 128 deletions(-)

[=E2=80=A6]

To address Greg=E2=80=99s comment, your patch first has to land in Linus=E2=
=80=99 master
branch and only then it can be backported/applied to the stable series.
This will be done automatically if you just add

    CC: stable@vger.kernel.org

to the end of the commit message.


Thanks,

Paul

--=-DmdotBvBK8MiSHgBwj2s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlEpA20ACgkQPX1aK2wOHVhj3ACdH7ZumVZrLbh7uxfaH8dJuEB+
5skAn2JG68N+RUUjChmFptsquZS3HffB
=oa+W
-----END PGP SIGNATURE-----

--=-DmdotBvBK8MiSHgBwj2s--

