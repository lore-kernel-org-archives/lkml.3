Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab3CZRIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:08:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59189 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751526Ab3CZRIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:08:45 -0400
Date: Tue, 26 Mar 2013 17:08:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>
Subject: Re: Driver lis3lv02d_i2c not working on Nokia RX-51
Message-ID: <20130326170841.GG18316@opensource.wolfsonmicro.com>
References: <201302170046.26569@pali>
 <201303242345.00176@pali>
 <20130324230435.GE18316@opensource.wolfsonmicro.com>
 <201303261602.40219@pali>
 <20130326154442.GE18316@opensource.wolfsonmicro.com>
 <CA+55aFwYvq5fZawbDVDPBu0ox2W7DQf5JmmyQHJYpBTOOTu_nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="II8oT75hj15qngTC"
Content-Disposition: inline
In-Reply-To: <CA+55aFwYvq5fZawbDVDPBu0ox2W7DQf5JmmyQHJYpBTOOTu_nQ@mail.gmail.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--II8oT75hj15qngTC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 26, 2013 at 09:08:08AM -0700, Linus Torvalds wrote:

> This is a regression, and it needs to be fixed. The "device needs

This isn't a regression, the commit they're complaining about (ec400c)
was added in October 2011 with a note about all the in-tree users having
been looked after and then the commit adding the registration of the
device (3b511201) was added in May 2012 - the device has just never,
ever worked in mainline on this board as far as I can tell.  It's not
like this was even two commits going in in the same release cycle.

As far as I can tell what's happened here is that someone got round to
testing what was sent upstream for the board and noticed that it never
worked.

> power" crap is just that - crap. Nobody cares. OF COURSE all devices
> need power, but that is totally irrelevant for a driver. The SSD in my
> system "needs power", but I have absolutely zero regulator information
> for it NOR DO I F*CKING NEED ANY!

Right, and this is why the core provides facilities for stubbing things
out.  There's no point in every single driver going and implementing the
same code for handling this stuff, it's repetitive at best.

> I'm going to revert that commit unless you can fix it some other way
> (dummy regulators when you can't find a real one or whatever). The

That's pretty much what I'm telling them to do - put the stub regulators
in if they don't know how things are connected on their board (there's
helpers to make this easier).

There is also an existing Kconfig option to just stub out any missing
regulator which people can use but it's not recommended for production
since it confuses things that may really have optional supplies and want
to handle that.

> notion that you have to have regulator information in order to use
> some random device is insanity. I don't understand how you can even
> start to make excuses like that. It's so obviously bogus that it's not
> even funny.

There's definitely room for improving the stubs, I would like to see
something which lets boards say "these specific regulators are mapped,
these supplies don't exist and stub anything else out with a dummy", but
users like rx51 should be well enough catered for at the minute.

--II8oT75hj15qngTC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUdYSAAoJELSic+t+oim9PqYP/0edcgKNZdvoQZgPUejkT5F9
bJqRkpLlp9JpWFMY0HX19MxuOQvRkpuk5sCKTwNM1tRjdi8aXxM7OfNvkbXy0hid
VUTZ4jZv1t/AhCE0brGCeW6X+zF2GdU2JsMMWVQ4V1ysf3l4UUffaEBCR0JfkZ1j
3w180DCZpUgm6itbIDzAN4OGFaPmootgSTyG87TtxQ4DlyT9Ns1Gm1kQrRfSoFRj
K92F5kBHK8lacTnRRytpcxEBbWA0T/KOaMqDdIqyC317bpP0Outk3cWrmeTC1+ty
k4ZL9+Gg/hh9zKxsJ0es64VrsETW1KdmolOF71yKPQGG+l5nRtI5c5h7Khp9ZqHD
5P8IEb7HYc9K41jwsXpGFAC97liscjI2uOTUfqTnlc4026Osy0XJYBDcIPouKEBZ
bpawbCzBkFA3OHPUxNB73VYO7NFW2mc05zmFJ8Afh3erUd8/ZhCYdP1kg0/dyfl4
XVSE5TSwH2MjodPchnZ1It2uSl3XZJyvtZtf/TXX0tKdJKY8kHLWW7n7T68x+nnb
PZglGFZgfI4q1oyn6R/VOnTIC4tGyCk6jEVUBK8GcLXxEVPwzF3cmUadyarxq9PI
GlU94lhnKHVfyIJbqSrvzImQkNNzYOQNZnqV0xXaBgJ3PcqEWarrEFYh4dSSXr78
xIRiY9HdL/FFfAENUE6N
=LykC
-----END PGP SIGNATURE-----

--II8oT75hj15qngTC--
