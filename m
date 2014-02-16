Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaBPJDj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 04:03:39 -0500
Received: from ring0.de ([5.45.105.125]:38434 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbaBPJCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 04:02:44 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sun, 16 Feb 2014 10:02:39 +0100
From: Sebastian Reichel <sre@debian.org>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Jonathan Cameron <jic23@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-iio@vger.kernel.org
Subject: Re: [RFCv1 2/4] mfd: twl4030-madc: Add DT support and convert to IIO
 framework
Message-ID: <20140216090238.GA9066@earth.universe>
References: <20140214174040.GB26969@earth.universe>
 <1392403586-30540-1-git-send-email-sre@debian.org>
 <1392403586-30540-2-git-send-email-sre@debian.org>
 <CAAfyv36yfd0tSe9G2AnX+DzE-gObdRxYfgK+NKT8zwYmqt=QcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <CAAfyv36yfd0tSe9G2AnX+DzE-gObdRxYfgK+NKT8zwYmqt=QcQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Marek,

On Sat, Feb 15, 2014 at 02:31:41PM +0100, Belisko Marek wrote:
> >         /*
> >          * Phoenix provides 2 interrupt lines. The first one is connected to
> >          * the OMAP. The other one can be connected to the other processor such
> >          * as modem. Hence two separate ISR and IMR registers.
> >          */
> > -       madc->imr = (pdata->irq_line == 1) ?
> > +       if (pdata)
> > +               madc->use_second_irq = pdata->irq_line != 1;
> > +       else
> > +               madc->use_second_irq = false;
>
> Can we add some property to use second IRQ also in DT?

Sure, a boolean property like this could be added:

ti,system-uses-second-madc-irq;

I did not add support for it initially, since I could not find any
board in the mainline kernel with this setup. If such a board is
added at some later point the driver can be extended easily.

-- Sebastian

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTAH6uAAoJENju1/PIO/qaQm0P/1RmmaLyDoooZPnL95GpfOdR
stcpRhg01JGctEp5sFB+q8dYd+SxqCB3/Kk+m7I5PfzgMx+jsrnr0e+lDl3cbjeE
H3yvcfQiKa2AbdMscN6/uq7ju+7rxIQcRFUFq5vKFzwswGnPs373nb10rb9/I44B
AcK99HcgTK376Q+1KuMjOCzFuvu3khpj8HX2uwsciZ/LJvYIl3Nu1NqPSZVyS2JH
mJXluIIt0Y5HWtydvSyzF7YXBmITfN6Y9i0CMtzgFStAuMstot7BJ31edNilesma
uA3b9YSyWm9JE/1g2NYfWD1VymAB62K/5onDwot11IzfI4tWUcxwBejpEVJvRY6r
/WhPwqfXblreUqTPbgYxj1qlbB1l1klZxajUxeuddg1L9632zCiH+cgf9XEwzN1D
1JwWXOvApKOUKxx1D9HIljx6SSAR+fRph/q5kYoTD8EooxdrDZBmpClxkKpJsy+A
gZH6n10pc6uaw7IPFmoSyEV2533PGWEtHxaU+ipo8+IKF73v594E4NdjN37pssGY
dqk1tceSzaR3Kb2T65Jv32nzqbAz1zphyp/+atWCE8PbdC8YwPRToH9/2giTcRwB
hlxsFJu6NxSEjzpRwaDBmtURdCSJGVu8ptBoxd2RPGBKl3ZcgaJk2AEtVe8wyrkJ
WaIoYgsKXv9fxIK2Hiao
=yLlO
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
