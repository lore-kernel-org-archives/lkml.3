Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762094AbaGRQC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:02:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58093 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009AbaGRQC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:02:56 -0400
Date: Fri, 18 Jul 2014 11:02:09 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Hurley <peter@hurleysoftware.com>
CC: <balbi@ti.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH 4/5] tty: serial: 8250 core: add runtime pm
Message-ID: <20140718160209.GQ24914@saruman.home>
Reply-To: <balbi@ti.com>
References: <53C6A050.2050409@linutronix.de>
 <20140716160614.GI1365@saruman.home>
 <53C7EC6F.6060902@hurleysoftware.com>
 <20140717154300.GA16623@linutronix.de>
 <20140717160206.GI10459@saruman.home>
 <53C7F4A3.5080508@linutronix.de>
 <20140717161848.GK10459@saruman.home>
 <53C8DC3E.3020701@linutronix.de>
 <20140718153116.GN24914@saruman.home>
 <53C942F1.2000408@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MXxcbiX/Q4+iy5U7"
Content-Disposition: inline
In-Reply-To: <53C942F1.2000408@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MXxcbiX/Q4+iy5U7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 11:53:21AM -0400, Peter Hurley wrote:
> On 07/18/2014 11:31 AM, Felipe Balbi wrote:
> >On Fri, Jul 18, 2014 at 10:35:10AM +0200, Sebastian Andrzej Siewior wrot=
e:
> >>>On 07/17/2014 06:18 PM, Felipe Balbi wrote:
> >>>
> >>>>> >>No, this is okay. If you look, it checks for "up->ier &
> >>>>> >>UART_IER_THRI". On the second invocation it will see that this
> >>>>> >>bit is already set and therefore won't call get_sync() for the
> >>>>> >>second time. That bit is removed in the _stop_tx() path.
> >>>> >
> >>>> >oh, right. But that's actually unnecessary. Calling
> >>>> >pm_runtime_get() multiple times will just increment the usage
> >>>> >counter multiple times, which means you can call __stop_tx()
> >>>> >multiple times too and everything gets balanced, right ?
> >>>
> >>>No. start_tx() will be called multiple times but only the first
> >>>invocation invoke pm_runtime_get(). Now I noticed that I forgot to
> >right, but that's unnecessary. You can pm_runtime_get() every time
> >start_tx() is called. Just make sure to put everytime stop_tx() is
> >called too.
>=20
> The interface is asymmetric.
>=20
> start_tx() may be invoked multiple times for which only 1 interrupt
> will occur, and thus only invoke __stop_tx() once.

alright, thanks for the info.

--=20
balbi

--MXxcbiX/Q4+iy5U7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTyUUBAAoJEIaOsuA1yqREMbsP/2Oa69FBgz0pYwFcBD4hJ/h7
lqRL9qdvoiu/oS8K6ULUTNLCHWyPzJ9c0UlAdjpaX+8iFV1u4xB8QZ73GYwIZp2x
T8f2kIjiU0glItx7LYEVN/I86STGpGT8qfL3vROgMPn7yhrp3lKMqQ+oDMuk/Q7v
EXFeJHH7JwgUle2B6Yj+stMv5rS+T6baxqZgo5vJpZWgND0BRxtZNott0TN3q28z
Zx9+8QL3cNhl4W2B+hcANSGCO7I0eokC2XdrO/HWQqaeexDSm11jV8OSEXhKOB5T
oFtmSBmyGSMATNwlXvRVqo01wbfNyq1A+EqzXSkMWYZR2GFQUDBFDRBslE4JFe0C
txRBRdcB20bfrsqpsus5VXOPiEAlNq/F+Ump5M7mIOv9c6b8KspdWXX2vUmiJOeI
QCVldCy8/ZZPBEGdgD3WXRImRKgca2J4tXZ3WjJyTxF2nWHRiFdOCN2YxGGDMxyC
nMvPQo/MtoqOahyCpUTsOCDwEgnySk9CJIEZNdQrkfcGE5MLa1rH0Kq8Bhsl46fR
63Ldk3rSTfmeTifrleV/euuwek4lqNqWDN7V8PuXr3Ez/P8oFhp+KplF7pEhcQQj
qrovf6QR5Ye6hUoxhU6zpm5bH6WfD9mkI9bsHfDYN3mNCed27JD99t98atCRijAL
T4TD/Jo4qc9KgDGBsBWi
=20XI
-----END PGP SIGNATURE-----

--MXxcbiX/Q4+iy5U7--
