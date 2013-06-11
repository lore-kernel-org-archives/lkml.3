Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3FKTsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 15:48:25 -0400
Received: from mail-bk0-f65.google.com ([209.85.214.65]:35522 "EHLO
	mail-bk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab3FKTsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 15:48:23 -0400
Date: Tue, 11 Jun 2013 21:48:19 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "poeschel@lemonage.de" <poeschel@lemonage.de>,
        "rob@landley.net" <rob@landley.net>
Subject: Re: [PATCH v4] pwm: add sysfs interface
Message-ID: <20130611194819.GA29980@mithrandir>
References: <201306101612.07708.hartleys@visionengravers.com>
 <20130611101432.GA932@manwe>
 <51B709F5.8070909@gmail.com>
 <ADE657CA350FB648AAC2C43247A983F0021DA690F61B@AUSP01VMBX24.collaborationhost.net>
 <ADE657CA350FB648AAC2C43247A983F0021DA690F63A@AUSP01VMBX24.collaborationhost.net>
 <20130611183521.GC29842@mithrandir>
 <ADE657CA350FB648AAC2C43247A983F0021DA690F6BE@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0021DA690F6BE@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2013 at 01:45:37PM -0500, H Hartley Sweeten wrote:
> On Tuesday, June 11, 2013 11:35 AM, Thierry Reding wrote:
> > On Tue, Jun 11, 2013 at 11:47:23AM -0500, H Hartley Sweeten wrote:
> >> On Tuesday, June 11, 2013 9:09 AM, H Hartley Sweeten wrote:
> >>> On Tuesday, June 11, 2013 4:29 AM, Ryan Mallon wrote:
> >>>> On 11/06/13 20:14, Thierry Reding wrote:
> >>>>> On Mon, Jun 10, 2013 at 04:12:07PM -0700, H Hartley Sweeten wrote:
> >>>>>> +config PWM_SYSFS
> >>>>>> +	bool "/sys/class/pwm/... (sysfs interface)"
> >>>>>> +	depends on SYSFS
> >>>>>> +	help
> >>>>>> +	  Say Y here to provide a sysfs interface to control PWMs.
> >>>>>> +
> >>>>>> +	  For every instance of a PWM device there is a pwmchipN directo=
ry
> >>>>>> +	  created in /sys/class/pwm. Use the export attribute to request
> >>>>>> +	  a PWM to be accessible from userspace and the unexport attribu=
te
> >>>>>> +	  to return the PWM to the kernel. Each exported PWM will have a
> >>>>>> +	  pwmX directory in the pwmchipN it is associated with.
> >>>>>=20
> >>>>> I have a small quibble with this. Introducing options like this mak=
e it
> >>>>> increasingly difficult to compile-test all the various combinations=
, so
> >>>>> I'd like to see this converted to a form that will play well with t=
he
> >>>>> IS_ENABLED() macro. We already have the same issue with DEBUG_FS, o=
nly
> >>>>> to a lesser degree because it doesn't have an additional PWM-specif=
ic
> >>>>> Kconfig option.
> >>>
> >>> How about removing the Kconfig option and just doing:
> >>>
> >>> obj-$(CONFIG_SYSFS)			+=3D sysfs.o
> >>>
> >>> This way the PWM sysfs interface is always compiled and included in t=
he build
> >>> as long as CONFIG_SYSFS is enabled. The check in the header would cha=
nge to
> >>=20
> >> That didn't work. As Ryan pointed out we get undefined references due =
to
> >> sysfs.c being compiled but not core.c when CONFIG_PWM is not enabled.
> >
> > Why not add dummies for the missing functions? It was my impression that
> > we had dummies for all of them already, but if not they should certainly
> > be added to match what other subsystems do.
>=20
> I just looked it over and the undefined reference was for pwm_set_polarit=
y().
> The dummy for that function is missing.
>=20
> The other problem with this approach is the sysfs.c file gets compiled wh=
enever
> CONFIG_SYSFS is enabled even if CONFIG_PWM is not enabled.

Perhaps add something like this to the Makefile:

	ifeq ($(CONFIG_PWM),y)
	obj-$(CONFIG_SYSFS) +=3D sysfs.o
	endif

That should solve the problem of building sysfs.c if SYSFS && !PWM.

I'm tempted to take your v5 patch and make a note to clean that up
separately at some point (along with similar changes for the DEBUG_FS
support).

Thierry

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRt38CAAoJEN0jrNd/PrOhv6sQALhSDMAF+9w9o4+hc05KmckB
SwWTl75kVHz7whb1gNEkxjc9BaS36zeqme/DIvHdRCy+rfnpJZ1wmrGv7FdJ1NQZ
8HjadtyXjujxhlVJXLs0T5vgx0a//ioFd7R1HgIyx9q5uklhywASyNd8dvF0cBUe
Kq4CgfFoqK8A7DDurI/rI4PpAZmYSNylEsKzSPkeV+it6E0EbqcbCTOtX5ioWcbY
4Ah3DjbOQRDnFPZUZu0bnOjWUuetUHeZiui67SbGtAwKc25SAEW0jxFcFif/W6P9
u8fddcwKF8r9wKOol3WCMhB+WsffCpJmEhGLBrUfaWsTDLY4WjW/qlZLgnvuNbfn
WORV63GSolJMArs7o366oeaYmlJ6eJQXovWIG0yb+blpnqAYkgz1552tCAaFeTrD
IDBPx4E+jtWvCNcf80FAAjToXwZQ9USzOpIn651TZn5RqxkWr/iRVZMxB0qMcCmW
dZu5U147l5wDHcmKWPCNi6A+ymR4cW7pQ2JmdcNke8As8BFLhUGN09JmZbjwEk2q
3iUl2KS21Fz+Gfz5Oz3/x+FYfH+qrsntyxXxyD4P8Z+WkWr4UtmYbD5bbTJ9j3nj
FscfZMVP1nuqmbigJVEN9UZx8LPJQtWFePMjawZwmpfO/N2JcrlofbiiCFgiDK1S
ICoTraR2/GZqk6qCjOrI
=awzE
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
