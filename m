Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab3CGOWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:22:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38117 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754787Ab3CGOWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:22:46 -0500
Date: Thu, 7 Mar 2013 22:22:21 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>
Subject: Re: virtual irq isssue - regmap_irq
Message-ID: <20130307142218.GA19401@opensource.wolfsonmicro.com>
References: <1362639472.484.22.camel@dhruva>
 <20130307071349.GF22554@opensource.wolfsonmicro.com>
 <1362657155.1796.4.camel@dhruva>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <1362657155.1796.4.camel@dhruva>
X-Cookie: Courage is your greatest present need.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 07, 2013 at 05:22:35PM +0530, Ashish Jangam wrote:
> On Thu, 2013-03-07 at 15:13 +0800, Mark Brown wrote:

> > This is a bug in your platform which will affect anything using a linear
> > domain.  The platform isn't setting up its interrupts correctly so that
> > the core knows that those interrupts are reserved, ideally the platform
> > would just use domains for everything but at least irq_alloc_decs()
> > needs to know what is going on.

> Thanks I got this, however in this case should regmap handle such
> condition where domain is unknown?

There is no "condition" or unknown domain for regmap to handle.  regmap
asked its irqdomain for an interrupt number and was given one, it's got
no way of validating what it gets back and we don't want to end up
having workaround code all over the kernel for broken platforms.

> By the way, I was testing on smdkv6410 where Dialog device is not a
> component of the board.

The board is broken anyway; fix the board.

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJROKKRAAoJELSic+t+oim9aY8P/1z2lNFw+P42PjZ8a0xXhrDo
r/P+48Wz3l3VpmGq78qcFcSRUxVF3jF2Nls8TJA/FWJr9RYXsr3E3YiE7nkf+Rj+
ICQ3I8R6/EBgDIzixpvDYUUZFi1bn+02IaoPaZOm4LgT/d7ThsvF27mCRY2tidMW
f6VwHYJAv5rIPT9RWJuhCxtSvwRQt3HeCNGhqTL+VIEi9PKpGoF/JfI6UI0Z79Hj
N2St0icUw8OHTpf3Y8q/4qqgW6JsDsSE03uV3kXgUphO0TbYMjbrTMcAlc2nZ7OM
P55JGOUvtYp5boVJU+jtzTf2CICtjHpx4FwbN3QitSwbOJJbB/xlBErgTKXR8hsn
m7p6S7fEQ6Th29X3KCGkVAna8vYHxAt3PAtqgx+BBDM+egbFIa8UwYiC5aWtw2jH
o2dWnc8Y7XibSaAzmQFpEiHLctvCN2LxBBAT6jnFP96M35GU1MkukGxk0k3ftNzy
YZZ5S318Q0TYg7LQYM/UEcdQxiVCCp/HVHBfeHTERCoF4loqAK4wo9cBVdnYNrGU
wZMbmC3/CqaHmWIqCppGRp3QsbzKzgUHlg+8RR0ZzHJI3kiSGQcdIO67Y6syuE+T
CDxlTXjX/PA0J+h3ftiu0iaegWmjMK63vHYnY1nkM74AU7YmO9gJLKyfPex5e0MM
Xx3pQ15z8ERcgVs8Qs4i
=Lz59
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
