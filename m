Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677Ab3FFLPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:15:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38713 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3FFLO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:14:58 -0400
Date: Thu, 6 Jun 2013 12:14:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Message-ID: <20130606111437.GV31367@sirena.org.uk>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
 <7380889.l4hHqCT0mm@dtor-d630.eng.vmware.com>
 <51AF8730.4010507@itdev.co.uk>
 <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com>
 <51AFA02B.3000604@itdev.co.uk>
 <20130605210715.GA16013@core.coreip.homeip.net>
 <20130606094822.GB1883@sirena.org.uk>
 <51B06732.2050701@itdev.co.uk>
 <20130606104651.GS31367@sirena.org.uk>
 <51B06BE6.80909@itdev.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QoSTjIIX+pox8TBQ"
Content-Disposition: inline
In-Reply-To: <51B06BE6.80909@itdev.co.uk>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QoSTjIIX+pox8TBQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 06, 2013 at 12:00:54PM +0100, Nick Dyer wrote:
> Mark Brown wrote:

> > The retries can just be done further up the stack?  All regmap is doing
> > with I/O errors is punting them straight back up to the caller so the
> > caller can retry just as well using regmap as it can using the raw I/O
> > protocol.

> It would have to be put into users of the debugfs interface as well.
> There's quite tight timing required to make it work properly (see patch
> [40/53]).

This is yet another reason for implementing the protocol properly
instead of trying to bodge around the kernel.  It really seems like
the biggest problem here is the decision to try to bodge the entire
thing into userspace with no kernel support.

> > Without seeing the address thing it's hard to comment.

> Patch [36/53]. If the T5 message processor is from address 100-110, you can
> do a read of 50 bytes starting at address 100, and it will return 10
> messages, but anything in regmap that tries to do bounds checking would get
> confused, I think.

That's just not going to be supported, sorry.  You can implement custom
locks and access the device directly where you need to do stuff like
that while still using regmap for actual registers though.

> Also, we would like to implement address pointer caching. maXTouch allows
> us to skip the address part of the i2c transaction if the address pointer
> in the chip hasn't changed. This speeds up interrupt handler slightly. But
> it requires extra housekeeping at a low level to remember what the address
> pointer was on the previous transaction to know whether to send it or not.

That sounded like what you were talking about, it's pretty common and is
sane enough for reads.

--QoSTjIIX+pox8TBQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsG8aAAoJELSic+t+oim9y5IP/iQzJ/KjLMw1Cis3Yw83Fenx
DT4p7Ze/fcIa5z3HXuY4uyWp0o+Nhm0A3irUFRXgVG1Dwr7lob8caSRP6+4L968v
0O1DBvzTVjiZtKVog8pslgpfq7/dqZ0BJZ43lyfXYn3H9MCLDdfVMIwWOPeoACON
Lc0yqRn2Vwji1hd9HENOiFIhk8Y3fZ72R6Qzktgh3WyII4Wza9OU//9zh81XwTAo
ONTas+0fdqwAQDm/BMfejI4wMM6D5Aps8lD7x5UdmPF448dXywptJvLUjMPpFqXB
IOZFj3yrewjCEW3TeljAw5TWmCyz1ZGwHCv1BhAkI34Xb+CqsgJzwnseHHdqyR1x
OmXvnzYq0QDAK/IxngO6BfkTZA1roGr6AjgMHLMuxprMO/xrvLnbTqYLns8s0PLI
pRvBrGqLrs9BEwjyRQgcR6llA5leAB4265K3LeKKlOuKrh15li81TOd51JXYENGh
8k/hJfVc3p6caNE2xYkbxuFvUjpHHDYuWDVV2YOmL8THSKwhDq88UPDFMdoUkmQC
i89TvF2dZaiKUOefIFFYsUHFyZ7JWg9IAnQImerUTG2vbRjrEp/dXaIwG275HF2Z
W0ZNlJuu2pWuxnpWYL0Xclt9MlEXoxyY4jSsA32l9BesSMsBvUd6+kKf8tcxLQPC
ArVmNBEIGnYMbsXDdRVE
=5T7S
-----END PGP SIGNATURE-----

--QoSTjIIX+pox8TBQ--
