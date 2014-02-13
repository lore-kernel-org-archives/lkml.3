Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaBMQXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:23:04 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41541 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaBMQXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:23:00 -0500
Date: Thu, 13 Feb 2014 16:22:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Arend van Spriel <arend@broadcom.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>
Message-ID: <20140213162249.GT28112@sirena.org.uk>
References: <1392059868-8782-1-git-send-email-arend@broadcom.com>
 <52FC8CB3.4090305@gmail.com>
 <52FCB571.4020904@broadcom.com>
 <52FCBC1D.7050501@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XabuzTTlKwS6ZQpP"
Content-Disposition: inline
In-Reply-To: <52FCBC1D.7050501@samsung.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC] dt: bindings: add bindings for Broadcom bcm43xx sdio
 devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XabuzTTlKwS6ZQpP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2014 at 01:35:41PM +0100, Tomasz Figa wrote:
> On 13.02.2014 13:07, Arend van Spriel wrote:
> >On 02/13/2014 10:13 AM, Tomasz Figa wrote:

> >>The BCM43xx WLAN chips I used to work always have been controlled by a
> >>simple power enable GPIO of the chip itself. Has this changed in newer
> >>chips?

> >>If you need to simply toggle a GPIO to control the power, you don't need
> >>to use the regulator API at all, controlling the GPIO directly.

> >Not sure I understand. Do you really mean 'chip' or 'wifi module' here.
> >The chip needs to be powered and for that it is hooked up to a
> >host/module provided GPIO (at least that is my understanding).

> Your binding asks for a regulator, not a simple GPIO, which is all I
> believe you need for BCM43xx power handling.

> Mark (added to Cc), could we get your opinion on this?

If it's a GPIO connected directly to the device it should be using
gpiolib, the fact that it happens to have an effect on power rather than
(say) just being a reset isn't terribly relevant to anything outside the
driver.  If it's an external regulator that happens to be controlled
using a GPIO on the current system then a regulator is better since
another system might use a regulator with a different control interface.

--XabuzTTlKwS6ZQpP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/PFWAAoJELSic+t+oim9TS8P/iEEmFWQlIuSvW+YdyBjtxdh
CYMzbCsBeQdbaZljW7xTZDn4MTGQuGMmNH8Y2sDfuDRCS/zY9OFQkVuy5lgg6e+Z
T3L3OiRCppMKZImTbTqR1xY8vqod5WfuRlY1z7hojZIk3KRUvWzlgKWJabnqM+2i
ZPeRmA02CX0CwEZSV4jCku8bgkrwNl0kxw9HnQQBPJOs55tNaemqEe/ugj+0d4id
rlzMOgONCgYKMWBsP/rS3xzQE9WlLQnBE8n3zETnYl2Ha5BuqUfNR3p8izQIQ82N
W5vcRCXfShpWfb20RnBXZUrKBUIrn+zPcmv0H0ac0RcJtH5w/ZRyGxIB+uPy2QPn
v3+AJw00079jCfhFXfSYYVINnF1MhcNUIJndBe5T8G5WG26izG2ivwjV+/Uz5dVB
syugr1dGFcYtcbKEzVOU6jsVzbJ736zXH4pJP9k6QsOWkcXhCse18Di0fY7NA+t9
uK9cygXjx5hUAEBlT1pqIZTfqUHafP9CAMKhzEthR9ckcdSqBcaYkdEQ/D50lxNF
AS/NnHBXgngfu4uoz+a7Dk6bFyC1GTCKbUfWYgv3dpjOIyFDqaMVHd6MUvhKlmeP
doPupDAsMC1W9N1P4kpuZGXeH7mGKXczJI5HEWiusnj2mzS+QAM206bHUwKa4wt7
0xUZaS8OtKf/L185PHLW
=OenJ
-----END PGP SIGNATURE-----

--XabuzTTlKwS6ZQpP--
