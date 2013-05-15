Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab3EOEqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 00:46:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60141 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3EOEqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 00:46:39 -0400
Date: Wed, 15 May 2013 08:46:04 +0400
From: Mark Brown <broonie@kernel.org>
To: Philip Balister <philip@balister.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20130515044604.GA24524@sirena.org.uk>
References: <20130512143344.GC3200@sirena.org.uk>
 <9e55c552-ce34-4663-9a57-bf2c626d7d58@TX2EHSMHS008.ehs.local>
 <20130513052135.GD6836@sirena.org.uk>
 <0bf5a185-86f7-4a93-a90f-42caefb06a1d@TX2EHSMHS009.ehs.local>
 <519112F9.2010102@gmail.com>
 <7c5e7537-6ed5-4622-a7a9-bf46820ef695@VA3EHSMHS033.ehs.local>
 <519124D3.2040403@gmail.com>
 <af51c63e-7ff1-4e73-9305-08309217ab38@TX2EHSMHS037.ehs.local>
 <20130514164611.10068.46384@quantum>
 <51927DEB.7090001@balister.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <51927DEB.7090001@balister.org>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.247.243.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 14, 2013 at 02:09:47PM -0400, Philip Balister wrote:

> First of all, the driver that loads the bitstream into the fpga
> fabric does not know ANYTHING about what the bitstream does. So it
> cannot do any setup based on the contents of the file that is
> loaded. (And this can also be loaded during the SoC bootup,
> bypassing this driver completely)

This is a problem that is going to need to be fixed - there will be some
things going on the FPGAs that do need drivers and so there needs to be
some way to instantiate a driver for a FPGA image.  Things like adding
extra DT blobs along with the FPGA image have been talked about

> Second, there are four clocks that feed the FPGA fabric. We will
> want to set these clocks from user space somehow. It is perfectly
> valid to use a uio driver to interface with logic in the fpga. If we
> take the approach of using such general purpose techniques to
> interface with fpga logic, we must have ways for the user to control
> the fpga clocks.

Right, and if the specific device is being controlled by UIO then having
UIO create some clocks makes sense but then that should be integrated
into the UIO instantiation rather than done as a separate thing.

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRkxMJAAoJELSic+t+oim9TloP/09KWTifHEusxdNgDH2WZOou
K0K6gLkl1uxOYzFteuewoM4m5kQMgmlZtdkdgZKCgiAq9RpBpwxPBtsXJns6PiDW
4rbFyS8XZ0lBHryLJ2g1ghrN8Im2mFLF2u722yQOVRrOalFmpoPhZB6LRcJmP1ts
mT037sdwCz5OWV397nYusnzoZKbCBwf363yw3hcgs0f0dKty16lEwJIzVcl0ba/T
+2mfdHoxL2KjwqsJgs+2bxlVGzXKmBXGEbB4Pbp0yTmQLqwXFxOeMvJR1fB2ZUAd
wbEQ326U+7YS5+waik6XUz84YUBFDHVzw0u6b7hK3bfCBoA6Od9QvARSrogvjLs9
v+TZBFnnn3VZ1f5xuQo5zv5j9bpZ8PtkY+zAtk4xPZ5mwBA/sWm94xJWtlaYQ0rF
iB83EXg7b7bQVr4KXQ8LR3ZXXaYdQNCPipx8RgPR+hdDMG47B/tR6JxmoE4hrKSN
b9Tz07+EnyZv1LExcZsF0/P+J/QzVyGQgf4/ekFZDAPHq6NgxZom30w2rDiYqeOQ
RTgryikXtRDSOiUsDQ6ZYpCgnB94w6lJe1d12q0WJu/RiF9kSAQd6PJ0htku7jqH
mq3L48xbcXhiU6i2FwsOxfUKRR3vjSF6BQ7qKZ2/STAPrufxqVOY5FzvmhGCdl+/
wMhevKQU6hCbYUBZEICe
=zteZ
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
