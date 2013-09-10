Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3IJSC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 14:02:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42832 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab3IJSCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 14:02:24 -0400
Date: Tue, 10 Sep 2013 19:01:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: linux-gpio <linux-gpio@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <20130910180143.GA29403@sirena.org.uk>
References: <522BC27A.5080303@att.net>
 <20130909110640.GV29403@sirena.org.uk>
 <522E39B5.4090906@att.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Le4TR3oiO0NnCuo/"
Content-Disposition: inline
In-Reply-To: <522E39B5.4090906@att.net>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: "Virtual" Interrupts -- Need help please
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Le4TR3oiO0NnCuo/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 09, 2013 at 04:12:21PM -0500, Daniel Santos wrote:
> On 09/09/2013 06:06 AM, Mark Brown wrote:
> >On Sat, Sep 07, 2013 at 07:19:06PM -0500, Daniel Santos wrote:

> >>I have some secondary (and less important) questions about how to
> >>integrate this with device drivers that want a DT / open firmware
> >>config (which I know almost nothing about at this time), but that
> >>can wait.

> >Could you be more specific about what you mean by "integrate" here?

> One of my original requirements for this driver is that it is
> reusable for different devices that use the MCP2210, not just my own
> hardware.  There are a number of ways to accomplish this, but I'm
> still new to Linux device drivers, so I don't know how an "abstract
> driver" would work other than just making it a library that doesn't
> register its self as a driver.  The theory is that you should be
> able to specify your own USB vid/pid and have your driver probe on
> that, then feed the generic MCP2210 driver/library your board wiring
> information and any parameters your other drivers need (spi or
> gpio-driven peripherals on the board) and let the MCP2210
> driver/library do potentially everything else for you, unless your
> device has some needs that aren't covered.

OK, this is a lot like the plugin modules that are fairly common in
embedded reference designs.  I do have some ideas for how to put an
indirection layer in front of them but I'm not sure they're that
exciting - I expect what you end up doing will be having tables of child
device configurations registered based on the vendor ID, the vendor ID
support in the USB subsystem will let you provide either an index into
an array or just a pointer to the data for the specific board.

> Another requirement is for my specific device to vary its hardware
> somewhat, but (possibly) use the same vid/pid for these.  Maybe this
> is some cardinal sin and a unique pid and model number for each
> variant is called for (like I said, I'm still new to this stuff).
> None the less, I've dealt with these two problems by creating an
> encoding scheme (which I've dubbed "Creek", since I figured I was up
> one if it didn't work) that compresses the data so that it will fit
> easily in the 256 bytes of user-EEPROM on the chip.

That doesn't seem so bad, you can just have the decode of the main
VID/PID kick off the decode of the EEPROM contents.

> At the time I wrote this, I knew very little about the device tree
> and nothing about this Open Firmware format, so now I want to make
> sure I'm not re-inventing some wheel or circumventing a standard
> unnecessarily.  Then, as I was working on figuring out how to
> propagate IRQs, I noticed that the irq_domain_add_linear() accepted
> a pointer to struct device_node and didn't not accept NULL. This
> made me think that I was missing something.

Device tree is more applicable on a system level, it's not something
it's sensible to mandate for a USB device.  The struct device is as much
for in kernel usage as anything else, there are helpers to make DT
transparent but it all works perfectly fine on systems that don't even
have DT support built in.

> So in summary, I need to make sure that what I'm doing 1.) makes
> sense, 2.) adheres to standards (unless the standard fails to
> fulfill the real-world requirements) and 3.) doesn't unnecessarily
> introduce a new way to do something that's already done better
> elsewhere.

It doesn't seem unreasonable to me, though it'd be good to review the
specifics of course.

--Le4TR3oiO0NnCuo/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSL16EAAoJELSic+t+oim9wqcP/0SjGnWdBRAu5mSXTuOJ655d
VmdV1mFsyIQ1SKAh0XCT8bo7HiNaMQlYXXtTZSgWAk1znPTqBOvY09amIwZbH2SV
3J1Cg84+eLhKGrXQoReJABZp/WGd9GA9KDb21QFqAwXeAN7DFuxtsMBx4Jol5pUX
AdpiP+4WaO3w/jVLE6+jfNyMQXBH4L1n69dOK+B3aMjz/l5ftk2gYVe/bH/D5O2l
Bh4U5j30FaxTe9nw/Xpw7NLh3yvAanJedKsKCccgg+NIoHAOBjKjDG62QAnk3T3Q
M/ZVED4STf/3vuV6Gr9i+KNrRXQnBFKgIkmpx675qdranzQoOAwtw2k0AfhsYVY8
W6sWu1HrOxRfg+l0rGD763WBGDTbqOeaKBcwlcKHVCYXka7Hv/c54c6Kc6T+4FaT
EMWtfdDHpB2RctHpfUN2T5HkMPvOW+CaqBB+yz4Y1pxtPfKIuv0f33+TnaBBH1io
NFShcaDukeHdgXy3SIdBzYY+Q+WL6K4Db70+M3XYQHsbeRJyKEulTzSo4VX5GrjR
o2Fs+Fb8Dr0lM7r8zvJulRol0lOVmMdkAYCDk/aDJ6fRMvBowYHWBDAVWNk9zD7W
2h66He4DEoaKtVUXWxcKFrQznv+NbiGP7LqUdQEYazMV5dEWgFOuy+/dvhQ6zqM6
U/GHF+1CBb1JhHhcJhTb
=JFqg
-----END PGP SIGNATURE-----

--Le4TR3oiO0NnCuo/--
