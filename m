Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab3GZJx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:53:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53280 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab3GZJxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:53:55 -0400
Date: Fri, 26 Jul 2013 12:53:47 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: core: modify IO memory resource after
 deferred probe completes
Message-ID: <20130726095347.GA2970@radagast>
Reply-To: <balbi@ti.com>
References: <1374769590-14491-1-git-send-email-iivanov@mm-sol.com>
 <A2CA0424C0A6F04399FB9E1CD98E030458DE112E@US01WEMBX2.internal.synopsys.com>
 <20130725205224.GA12209@radagast>
 <A2CA0424C0A6F04399FB9E1CD98E030458DE12C9@US01WEMBX2.internal.synopsys.com>
 <1374821306.1956.34.camel@iivanov-dev.int.mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <1374821306.1956.34.camel@iivanov-dev.int.mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 26, 2013 at 09:48:26AM +0300, Ivan T. Ivanov wrote:
> > > Also, this is not *modifying* what was passed, just skipping the xHCI
> > > address space so we don't request_mem_region() an area we won't really
> > > handle and prevent xhci-hcd.ko from probing.
> >=20
> > Hmm? platform_get_resource() returns a pointer to an entry in the
> > platform_device's resource[] array. And "res->start +=3D" modifies the
> > entry pointed at. If it didn't, the bug fixed by this patch wouldn't
> > have happened.
> >=20
> > Are you sure this code will work OK if you build the driver as a module,
> > modprobe it, rmmod it, and then modprobe it again? Seems like it won't,
> > unless the dev->resource[] array gets reinitialized in between somehow.

gotta try that one... Perhaps the correct way would be to copy the
resource to a private struct resource and modify that one, leaving
pdev->resources untouched.

> In addition, I think driver is wasting memory, because on every probe
> it will reallocate driver state variable. This also happens in several=20
> other drivers which are using deferred probe.

We can't do much about this since we're using devm_* API. Perhaps
deferred probe should make sure to destroy the device and add it back
later ? Otherwise what's the benefit of using devm_* ?

--=20
balbi

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8kcrAAoJEIaOsuA1yqREp8kP+wcczDmrzV5PvlIEz6uNjTMJ
xtrO0PUxWSdoYCFYLW6nf2ArJ2zDGCpiF31Xty6QT0HtwiyXYA7p2J/pmdXSaPfD
rTrRiGJ6rFDS3dMbE5TlzufZmBllx83WkjrNyISz7QEUF/DF0Nc8spe+omWEx9Ze
93YIOhj8B7O0vi04FC6eKzTb34zgLDJtPqxv0trsUYUOCVUme9NFX04/9QJCejw+
lzCXqDWydx8ItvZiMADK/YAz6lhn3j4srwVm2iZ8N+xXqM3gyga0R+Cld+7zAVQp
7k3UNVDjceJp612XmgGx84dQUgbx1XlDRxua46I3VfMzNFdkb8zTeqmUbwfhfOGe
9O5q4Y8pin1uyGc8PMrSYDBiFrosprWGULR7ljpEz4X50/wfnEWiTxCSbPeU8EDb
Fe5/XK+Zl4K7AEJbmfPHZtThT9Nyu+ejIIXUODshTR1J/7jAKF3BYzaiEQVIeH6F
+aDr6RjqG6Cr+8XxF+jn7UCBx7AIVvi+qSYDjY9fNJNudCfgfZv8v+hgqUOow42D
8Bb0+vzSibJ529erxMK7Gae4uPHLuazViqAaANnLghWjwmSisbtM2fjKTfXnys+0
IzqAEDRI9sQ8IGzZZsH2cOmQp/2U5eNzJAKmTYULHOjhL+iUduuyZJ0deBZLB+D2
X5JGxxup5XxJCCFOsP0+
=/Bux
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
