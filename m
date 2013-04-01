Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab3DANYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:24:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39338 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757169Ab3DANYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:24:10 -0400
Date: Mon, 1 Apr 2013 14:24:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bryan Freed <bfreed@chromium.org>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH] spi: Unlock a spinlock before calling into the
 controller driver.
Message-ID: <20130401132407.GL18636@opensource.wolfsonmicro.com>
References: <1340409205-23606-1-git-send-email-bfreed@chromium.org>
 <1363198660-21656-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/jkxxxtAhYIHVDuh"
Content-Disposition: inline
In-Reply-To: <1363198660-21656-1-git-send-email-dianders@chromium.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/jkxxxtAhYIHVDuh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2013 at 11:17:40AM -0700, Doug Anderson wrote:
> From: Bryan Freed <bfreed@chromium.org>
>=20
> spi_pump_messages() calls into a controller driver with
> unprepare_transfer_hardware() which is documented as "This may sleep".
> As in the prepare_transfer_hardware() call below, we should release the
> queue_lock spinlock before making the call.
> Rework the logic a bit to hold queue_lock to protect the 'busy' flag,
> then release it to call unprepare_transfer_hardware().

Applied, thanks.  However...

>  		spin_unlock_irqrestore(&master->queue_lock, flags);
> +		if (master->unprepare_transfer_hardware &&
> +		    master->unprepare_transfer_hardware(master))
> +			dev_err(&master->dev,
> +				"failed to unprepare transfer hardware\n");

=2E..it'd be nicer to pay attention to and log the error code if we fail
to unprepare.

--/jkxxxtAhYIHVDuh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWYpgAAoJELSic+t+oim9ECIP/iup8GduvVOQinKDu+RE0ogo
cLnr0hWZfCUbYzcHxfgjdRIr8YQiqqpO0sUJ8+JVSdYet4frz0gPXToOTOoyjLdj
YjmJFrYBNd/D2LlYrIMLQxm1eQdIBgamBCftfVRuaE+kCMZ3IZY9qBYh86Iu3s6d
fn1IQ9e/rnPpiU3Q83cImSBUMGEURh9wn8YiUOzwybzZnexmREtOURAiuTkVjDzz
s3bNq5C07bnG0DcFRcgLuufxntQJ6eYT6V2w9O2UsurxWbjZysVn0/xUNI3ZxVkO
aH1HvG849SMIhSUrI3rdpqCDEl1HznYwzgGmX3Cx9q0kyt/LXyVsBhjvHAX3gpwH
CdYdRiqUoF4VM1K0Pf0di7WTa7B4C+5Xb3FRjczmqxJVFI5gD3ZKQ0ano06i1mJm
gEx7dSOUhtSxAKtZwXgkyVnCUtMdOMzPJLJXNv4j2oyohdB2H/MDeIVBUIG1hMYw
HEcY31rYcwWmCl1XaSL57DlRtIQQJfX2jgJ7ZwtAxV/R1tAMekeN8LG8KaD52K0H
vtirTTlNNqJ+scT32itF6b94xAToEEhFmYtMGQBFapE2pQuB7qZgs34tcyLDmDXD
EnJBTCKN1BoCDSfWgPvhtFrWRTjzGn0tmhnDak71RPngApfPCLUU9aqEiGvFGx28
l6Tv19xvtTGxo83L05Vm
=FaUh
-----END PGP SIGNATURE-----

--/jkxxxtAhYIHVDuh--
