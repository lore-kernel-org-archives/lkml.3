Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaG1Rp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:45:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59908 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaG1RpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:45:22 -0400
Date: Mon, 28 Jul 2014 18:44:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Olof Johansson <olof@lixom.net>
Cc: Graeme Gregory <graeme.gregory@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>
Message-ID: <20140728174410.GD17528@sirena.org.uk>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
 <1406206825-15590-20-git-send-email-hanjun.guo@linaro.org>
 <CAOesGMhKHGkVK3dOLXXx9GQBMxDmjBu1WDBgHmwdGe1UK3jfcg@mail.gmail.com>
 <53D60D11.8050205@linaro.org>
 <20140728162340.GA32359@quad.lixom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TCJSbVjzg7MjJqGR"
Content-Disposition: inline
In-Reply-To: <20140728162340.GA32359@quad.lixom.net>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 19/19] Documentation: ACPI for ARM64
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TCJSbVjzg7MjJqGR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 28, 2014 at 09:23:40AM -0700, Olof Johansson wrote:
> On Mon, Jul 28, 2014 at 09:42:57AM +0100, Graeme Gregory wrote:

> > >>+On no account should a Device Tree attempt to be replicated in ASL using such
> > >>+constructs as Name(KEY0, "Value1") type constructs. Additional driver specific
> > >>+data should be passed in the appropriate _DSM (ACPI Section 9.14.1) method or
> > >>+_DSD (ACPI Section 6.2.5). This data should be rare and not OS specific.

...

> > >I see these two sentences as contradictory, given that the _DSD doc
> > >worst case turn into quite a mess.

> > >Given that ACPI can present completely different data based on what OS
> > >is running, it's quite common to indeed have OS specific data in
> > >there. How does that relate to this document and these practices?

> > OS specific data has traditionally not worked out well for ACPI, I
> > would like to "persuade" people not to use it on ARM.

> It hasn't? I think Microsoft disagrees. It's also how vendors have been able to
> present an older machine description to keep their newer hardware compatible
> with older software, isn't it? How do you expect to handle that if you can
> only present one table? It's the same challenge that DT has.

It seems sensible to recommend against using OS specifics if possible if
only from the point of view of improving the robustness of the system -
the less paths there are to test in the BIOS the more likely it is that
the active path is one that's been well tested.  It's legal in the spec
and you can do it but encouraging people not to do it will hopefully
make life easier down the line.  Similarly encouraging people to put as
little as possible in there should reduce the opportunities they have to
get things wrong.

The best use case for OS testing is to enable a non-default workaround
for older versions of the OS but in the case of Linux that's a bit
tricky since we don't have clear versions to test against - even with
the kernel version number it's never clear if it's been patched by a
distro or something.  Windows is a much more fixed target here.

--TCJSbVjzg7MjJqGR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT1ovnAAoJELSic+t+oim9ii8P/3ThrFfXf5feXkDPmK24Wis0
igV/LE7WNK+i2D36rUn8Gm5KpkKoRDd3dcRw1V79s6+1ezfJc4AqGXCLQHQ9k5Mp
uY3GxRpUCTemN61dlrO2T/vS6Jy4jvacxcOZ4PYUc+EcEXncEQIDoYq0JgA9iPVs
parp50FIxjQauOT6MiXo61h/JgIb/05zyFogyvu8QHHNpFEne27VU0uYAXWISJww
B+lErnZf7s/SialvKPteyds3+IEibN22G9/VvPGXhtQOELhL7PF6hE9erCeiwtku
PLJ4jdeQNuZEsO2gAz1fpPI3+gIJMY6Q5CwB1AXpqVBo7gQWo157NY9P03+kKQaY
aIHJw3eUTQqc1BK06vd5DCYec40Rk4KceeheWDcW38WSB34g1Btqwjnx0DzzDA7E
W/UXant9mWcpOQgfrCjaru1zwD6HTzvL2VtoYflPUOaG7ioTqd5w1c91HCmEBrre
B6LNvTzfT0BJd50kdAHWjgUjnQZsYv2iLxaBIytpjAN/FJN5jKdwzvLojvkkNuQS
qrQ6yn8HhWq6yVLgbRLhbs92OK1cr2wgHE912OxPQadBJv8WqZgQAaifmGUx+xMW
1LgjHWasrWI+hDcImzrsB0yzSbKeUhhHtu02S/pFErtGd+2Y2dSGYvTUCoZ2IaEX
cl2YG17TrpAUOT/+xO8E
=iUQH
-----END PGP SIGNATURE-----

--TCJSbVjzg7MjJqGR--
