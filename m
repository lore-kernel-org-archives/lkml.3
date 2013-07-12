Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab3GLMMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 08:12:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53938 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193Ab3GLMMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 08:12:07 -0400
Date: Fri, 12 Jul 2013 15:11:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Rajendra Nayak <rnayak@ti.com>, Felipe Balbi <balbi@ti.com>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 2/2] serial: omap: fix wrong context restoration on init
Message-ID: <20130712121146.GC17053@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1373630142-21765-1-git-send-email-grygorii.strashko@ti.com>
 <1373630142-21765-2-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7qSK/uQB79J36Y4o"
Content-Disposition: inline
In-Reply-To: <1373630142-21765-2-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7qSK/uQB79J36Y4o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Fri, Jul 12, 2013 at 02:55:42PM +0300, Grygorii Strashko wrote:
> Since commit a630fbf "serial: omap: Fix device tree based PM runtime"
> the OMAP serial driver will always try to restore its context in
> serial_omap_runtime_resume(). But the problem is that during driver
> initialization the UART context is not ready yet and, as result, first
> call to pm_runtime_get*() will cause UART register overwriting by all
> zeros. This causes Kernel boot hang in case if "earlyprintk" feature is
> enabled at least [1].
>=20
> Unfortunately, there is no exact place in driver now where we can
> determine that UART context is ready - most of registers configured in
> serial_omap_set_termios(), but some of them in other places.
> More over, even if PM runtime will be disabled (blocked) during OMAP
> serial driver probe() execution [2],[3] it will fix only console UART,
> but context of other UARTs will be overwriting by all zeros during first
> access to the corresponding UART.
>=20
> To fix this issue:
> - introduce additional "initialized" flag and update PM runtime callback
> to do nothing if its not set. Set "initialized" at the end of probe().
> - read current UART registers configuration in probe and use it by
> default.
>=20
> [1] http://www.spinics.net/lists/arm-kernel/msg256828.html
> [2] http://www.spinics.net/lists/arm-kernel/msg258062.html
> [3] http://www.spinics.net/lists/arm-kernel/msg258040.html
>=20
> CC: Tony Lindgren <tony@atomide.com>
> CC: Rajendra Nayak <rnayak@ti.com>
> CC: Felipe Balbi <balbi@ti.com>
> CC: Kevin Hilman <khilman@linaro.org>
>=20
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
> tested on OMAP4 SDP with and without earlyprintk enabled.
>  drivers/tty/serial/omap-serial.c |   27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-s=
erial.c
> index f39bf0c..e1e9667 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -162,6 +162,7 @@ struct uart_omap_port {
>  	struct work_struct	qos_work;
>  	struct pinctrl		*pins;
>  	bool			is_suspending;
> +	bool			initialized;

you really think adding this sort of bool flag is the best thing we can
do ? Something which will, quite likely, spread through every single
driver ?

oh well...

--=20
balbi

--7qSK/uQB79J36Y4o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR3/KBAAoJEIaOsuA1yqREAM8P/0KBH59o9s1wvbaDv+hmMYRe
yPX7NUzO0y4IEBadl41CLKK00Gle/YXUJ/tQC24mzySVwOj/k94bS2bfeLaSnIxq
jRgj0sreP4jwoBiW++lRyzaH750KVO/qI+w/gHSvxBxYmFmRhXL6ttoqCQ4xv2z7
iYeV3Po4QUDJnqHTIpqnUIkLedGwM9hVAhMN0FA9ceC/7NyRYUHW8BckMSaUXwzu
5T4KFb+YlahGLVtmvNDaTOiNGnPI+gOXykRU6MHkoym7VNS5W0AJgkt6VD7G3pdy
1/5EFGIMI4ndrJ3Vuit9blNcvxE3q7hYqKwhsZAKcYcvyzTfQbobEeT8gR/j735o
r3mk3AuwUa9WiUbZX6JMaSfkMaBm3xh2boJtwVBHClM1/8gx3OHI9vyZzcw/fX+s
ek27O29iAu/g7qqePcPcgEysdQ2/7dMpCCxOaOzkDe2EGBP/N1yvDbWE6oMZO340
pG4dXWcUr6FniJadqr2MYmLCT4uaHH3Ki7+0uYkInZl9fB7FOJ0XcWPApLZ4H1eu
7YXjZUzZtoI19+1X3O81yRdqa30avnNsKbk/Z6ASAKLYeoFLRN1aYyJ3HDiS19cL
d1j1pXFoMzfei1YGLmHE/yWttCrh0kkf5PnnzBqWpB2flEfQC+FNtVX8tdMhXR//
PmCvE0G11PTxzTwABSEt
=xa+7
-----END PGP SIGNATURE-----

--7qSK/uQB79J36Y4o--
