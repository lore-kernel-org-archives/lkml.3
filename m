Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030838AbaLMMOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 07:14:39 -0500
Received: from sauhun.de ([89.238.76.85]:58976 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030648AbaLMMOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 07:14:37 -0500
Date: Sat, 13 Dec 2014 13:14:26 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Muthu Mani <muth@cypress.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rajaram Regupathy <rera@cypress.com>
Subject: Re: [PATCH v4 2/3] i2c: add support for Cypress CYUSBS234 USB-I2C
 adapter
Message-ID: <20141213121425.GA1034@katana>
References: <1417241986-17841-1-git-send-email-muth@cypress.com>
 <20141203110755.GA1039@katana>
 <BN1PR06MB06912FCBAAE08006E352008CC600@BN1PR06MB069.namprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <BN1PR06MB06912FCBAAE08006E352008CC600@BN1PR06MB069.namprd06.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> For repeated start (Sr) scenario, the STOP bit will not be set. For
> dummy write scenario (writing EEPROM address from I2C EEPROM slave),
> the STOP bit should not be set. But, for normal I2C write, the STOP
> bit should be set. We provide control to user to control when to
> STOP/NAK to handle different scenarios.

No, your driver needs to do all of that.

> The reset is an additional provision given to user to reset the I2C
> read or write engines. It does not require unloading I2C kernel
> module. The status indicates the information about the last i2c
> read/write operation.

I don't see the need for the user to do this. Better skip it,
there should be a real need for userspace API.

> In this version of the driver, we handle only single i2c message. In
> future iterations, we will add support for multiple i2c messages.

Then please resubmit when all this is done. It is OK to add features
incrementally, but hey, the essential things should be there right from
the beginning. Also, it would be nice if you told me your plans about
incrementally working on it right from the beginning. That would have
saved me a bit of reviewing time, a resource which is too scarce
already.


--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUjC2hAAoJEBQN5MwUoCm2UswP/iKEQf70svv9O7sG8x5OoeZj
8WzJvMRNUlP4Q9xBwpP+ZUWPGCGFwA+4hQn4gtHp7n8rVtUmStIGV0jTy/EpJk3V
rZ8G5hQ6pHdFazLoAqE260MFLwxH5S7LXUD1qdcscYAtC67HYQIAV91mdoq0BHMG
WMAmLc+siAdye2UPVDAfqZvApVWWsbBV9X6gaxZfOYPpNfO/VoziXH+IRlO0IYRz
AFa3rguJbqRe8qvQ+0KBlIkfJ826M9nxeLLP9Uv529L543OzAkc0JBhUl1QLlsDL
jT+I6TolCL9R6DD9+GqxPraEN/ON52b7M8nAEWfja7quZ5Ug8hkjIiCb9ytBtRHL
PiDENvZYth3QodGJgPLIpmygBehgweXZYKZmAKn4/fcidzdmm7ti0JXHgtCvzHM1
AdAd9MYLfppXcoVhfbrkikpHyje1rxm9lW++HywbPc0qSR9akOIRYpEftwXOpzIh
5V1mts+RxvWf8vTuVcGc0bmRIa+6dEAL5oYwD68Nj/LSeT+1k3YY78N4HkHbyRJw
KXUQyPbQDem8f2yP+iIxLdRkwKu+eCjcJJ57OsA/bt4Nx23J9GxlsLlx0au1O/st
kAvpWWRQKgNK2/Qoo4BrnLTZg5mDVJHRuTQwpMXYY53FQRf2iz7oU0TRgMkEdMsn
4zEVKRGR2z7zRVqMkUYk
=5gep
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
