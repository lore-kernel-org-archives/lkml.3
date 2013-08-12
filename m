Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab3HLUip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:38:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45358 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3HLUin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:38:43 -0400
Date: Mon, 12 Aug 2013 21:38:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@kernel.org" <devicetree@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130812203803.GF6427@sirena.org.uk>
References: <20130811190826.GH6427@sirena.org.uk>
 <Pine.LNX.4.44L0.1308112146410.29546-100000@netrider.rowland.org>
 <20130812095136.GJ6427@sirena.org.uk>
 <20130812110714.GA6616@e106331-lin.cambridge.arm.com>
 <52092491.7060605@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qbWslfj5jix8J1iW"
Content-Disposition: inline
In-Reply-To: <52092491.7060605@wwwdotorg.org>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qbWslfj5jix8J1iW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 12, 2013 at 12:08:17PM -0600, Stephen Warren wrote:

> In a similar way, I wonder if the USB case can be considered the same
> way? This seems less like a good fit since I don't expect the resources
> are always so similar there, and also there's the case of the bus being
> potentially behind a few levels of USB hub.

That won't work for the hub on Arndale in a system where it's fully
wired up - it's got an I2C interface for control and the idea is that
you bring it out of reset, write the configuration out via I2C and then
you can complete startup using a GPIO or another I2C command.

> And of course it all gets a little more messy when you get
> board-specific logic that needs setup, rather than something more common
> across multiple devices.

I think we could probably cover many cases by putting common things onto
the bus but we still need to confront the cases where the device driver
really does need to get involved in what's going on.  Things like the
SDIO WiFi cards seem very interchangable as you say and would probably
benefit a lot but there's other applications that are less regular.

--qbWslfj5jix8J1iW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCUeoAAoJELSic+t+oim9HksP/2vGRH4S6IiSyoSlu0dN9EnM
lWh/bDMRqaoXbDnw9r/kLJtQYA4K04Z2rs/syNNSoxWJgltxVngOnNM4ASU//+5o
TfqNORqFLUi/MmMKOEgvvIKjFar9OQ1k1OcWhGzLHTxK36fTbU9wNekVE/DdeYJm
3OJa40sENBz/hJQAXOSyBVmbWtRo5K3sSdlzxvFN/HrRnBg1wCb2OKuDq18d27CA
tkBAaDKIdGVv+jcVtCJPpmtxwc0ojBK1NgJ2bCfB13jVJJ1WGKLP6dh3MfzhoXpf
bb79knVWPZQ3v048u0mAk0pW1Z5DRmcNxUzyReLBn+/BeZLLZ2i6g5ArsNUq6eEq
llTLs3eAayE0mVta4ABWOevlpooHpduJ8KJyheATeiGGH02Nvje6zHYhs2gw0jaE
hCozeKrg/8zTKOHCT6UW/Czy1ZXh8v7Yg3En7ewR29MT/+Z2pDZ2jkPZYXfp0bFx
HbC9LnGU6/mn4COZ8VM92O+5RnK8z2erDQddHKFKDqiIAr8lr5SWpQ068pbJFx1O
AEsN+mfm2kwkN7I7H7aqnz3KCcREZ02O3B8ne6ZkXjpmvztzSQIRWhX6ACYz1ftn
GDrU8U/gTFbxVzECAcpEjFe5I6Z1JBPji2CiwxJmEhSDocNCaeq9y6wIJpj7juVX
DR5j1JkYdWOJVAacQWh1
=bt8+
-----END PGP SIGNATURE-----

--qbWslfj5jix8J1iW--
