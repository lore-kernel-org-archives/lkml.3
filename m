Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaATXPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 18:15:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57315 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaATXPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:15:17 -0500
Date: Mon, 20 Jan 2014 23:14:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tushar Behera <tushar.behera@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        jslaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Message-ID: <20140120231457.GZ17314@sirena.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
 <1390208555-27770-2-git-send-email-tushar.behera@linaro.org>
 <20140120100530.GY15937@n2100.arm.linux.org.uk>
 <CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com>
 <20140120214305.54f65ffa@www.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q3mG+ZLxscYP/cqM"
Content-Disposition: inline
In-Reply-To: <20140120214305.54f65ffa@www.etchedpixels.co.uk>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
 device probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q3mG+ZLxscYP/cqM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 20, 2014 at 09:43:05PM +0000, Alan Cox wrote:

> The dynamic major/minor is the right patch. If the userspace breaks then
> the userspace was broken, but I see no evidence in the discussion that
> the userspace broke.

The userspace breakage is that if someone has a static /dev that doesn't
handle any dynamic devices then renumbering the device will cause that
static /dev to stop matching the kernel.

> Thats what the list says. Samsung should have followed the rules, they
> didn't so they get to pick up the pieces. The Amba driver wants moving as
> well. It's easy. If you want something to be ABI then make sure you get
> it upstream first, if not you get to own all the pain down the line.

This stuff is all upstream already, a quick check suggests both drivers
predate git - it's been noticed because the ARM multiplatform work has
caused people to try booting kernels with both built in.

> If the hardware isn't present then the driver shouldn't even register
> with the tty layer in the first place so it doesn't make any resource
> differeneces either for properly written code.

Right, that's not the idiom that has been followed by any of serial
drivers though so needs fixing too.

--q3mG+ZLxscYP/cqM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS3a3uAAoJELSic+t+oim9LzQQAIIgnpJvqjh/LeaUU+MFQ52b
d+4bqte6ONik6wbOkMM1anqU9sLvlRewoHbOw0Vu5sK/pas49HPNQmTAtBAKTBGl
YuMLDub18lm01+9IHWa697GJOYeY7XLxh6UghCOGQzsFbxvs1Ws20o7EDgURByV4
x1067JDm2f+CreeZlmr8OyczALh6bC6ctYjcEPcRFNgGnGfTkDFDloQONOgAlI61
YuyiuwIQAng0ZVl9T7Kjpdmq5X8SZ3VU7zQON1bMVKKfUxiuhvIGBLfHespQgqCP
YvJ3p9mQOawqQHaoFQ5vnYqYJBxCW3N0jWH1Ksaibh88FlGBtsvvScSpffhae1zK
Hpc8+4tQIHpLBiTPVVkbv0eOHzRw0w6TnSp/ggDhugmNDP7weBAe4jdzfSrRTF0o
sfB24VX5xXi2AceWItnwXJXhNOqVCygQIN11Fzp2HfoagSWQ1omdlDXclwhLs9ZB
PgvRUTdCM7kCroZYX7Qkkv+3qGEWfUFbuC7SQExSZUOZQJCBI3VHuIT/iCCxc7on
nkYBqk/MCAp4QtZP+EK16PFqHGGBHhLqc4NxkiLNWhRyG7s0wGuaHQ92BXO1Xn3b
fHolOJxY/GBXjreCzXWKnYNsF10/sY/r0UCTzaK5ma5Dzmf4nd5jXbMlHvu2cmKW
It7zn1o5p8cR7Zu3fpdQ
=3Cyd
-----END PGP SIGNATURE-----

--q3mG+ZLxscYP/cqM--
