Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaJAP6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:58:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57012 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaJAP6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:58:13 -0400
Date: Wed, 1 Oct 2014 16:57:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: kernel@pengutronix.de, pawel.moll@arm.com, lgirdwood@gmail.com,
        robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux-kernel@vger.kernel.org,
        shawn.guo@linaro.org, festevam@gmail.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Message-ID: <20141001155733.GA4273@sirena.org.uk>
References: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com>
 <1411779588-22031-3-git-send-email-stefan.wahren@i2se.com>
 <20140928101650.GL27755@sirena.org.uk>
 <5428FE7B.8060700@i2se.com>
 <20140929171314.GW16977@sirena.org.uk>
 <2002781663.91096.1412169824110.JavaMail.open-xchange@oxbaltgw04.schlund.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dwbdSPijtzn/UKh9"
Content-Disposition: inline
In-Reply-To: <2002781663.91096.1412169824110.JavaMail.open-xchange@oxbaltgw04.schlund.de>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: add mxs regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dwbdSPijtzn/UKh9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 01, 2014 at 03:23:44PM +0200, Stefan Wahren wrote:

> Is it better to let the core handles the ramp delay instead of set_voltage_sel
> with a busy wait?

> I've found that polling DC_OK is only reliable for increasing voltages. So i
> think about defining ramp delay in the regulator description.

It's better to use the notification from the device if it is reliable;
dead reckoning isn't going to work well either for voltage reduction
since the time taken to implement a drop in voltage is more a function
of the loading than anything else, the regulator can't really control
it.  For most DC-DC loads it'll be quick enough though.

--dwbdSPijtzn/UKh9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJULCRtAAoJECTWi3JdVIfQoNQH/2zjMc4KZ/IoWBJAU9JUY7LJ
SEkoSMJGhSFr8rZD1nvOc9c0AuKCYUREn51tciLLpBvjUNRstacxcw49VcFwPRUc
suzc0KBefJZ5a4V+/SSEU1xmrTGGUQg9qQBHENqsLu4IRwVhIZKj6lyb0j5mZTqt
SkQSpgTLPW8F7gKBG4QwQmwGQl4K9UJg9fw3NCWn88ACCzdJph1Y+OOxezn9kVlg
L1HDQs256pju0kybGW9SlQ/0b2BqT3e2JQKRkCcwRvdPymIRyg3BmTVRGOYJF27M
MtHIFsPDYHSanq320oiDTU1bWZpqGcJf4RHNExBJTPuVTaZ3SDnU3SLy576i9N0=
=Gkbl
-----END PGP SIGNATURE-----

--dwbdSPijtzn/UKh9--
