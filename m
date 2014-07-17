Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbaGQNVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:21:45 -0400
Received: from sauhun.de ([89.238.76.85]:37689 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169AbaGQNVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:21:42 -0400
Date: Thu, 17 Jul 2014 15:21:35 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Randy Dunlap <rdunlap@infradead.org>, Jean Delvare <jdelvare@suse.de>,
        linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: stub: Add support for SMBus block commands
Message-ID: <20140717132135.GI2740@katana>
References: <1404742983-27303-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2xeD/fx0+7k8I/QN"
Content-Disposition: inline
In-Reply-To: <1404742983-27303-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2xeD/fx0+7k8I/QN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2014 at 07:23:03AM -0700, Guenter Roeck wrote:
> SMBus block commands are different to I2C block commands since
> the returned data is not normally accessible with byte or word
> commands on other command offsets. Add linked list of 'block'
> commands to support those commands.
>=20
> Access mechanism is quite simple: Block commands must be written
> before they can be read. The first write selects the block length.
> Subsequent writes can be partial. Block read commands always return
> the number of bytes selected with the first write.
>=20
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2: Make new functionality only available on request via functionality
>     module parameter
>     Add more details about SMBus block mode support to documentation
>     Use correct sizeof() variable in devm_kzalloc
>     Use stub_find_block() only in SMBus block command itself.
>     Store first word of block data in chip->words[].
>     When writing block data and the written data is longer than
>     the first write, bail out with debug message indicating the reason
>     for the error.

Thanks for doing this and thanks to Jean for the thorough review.

The thing I miss is the documentation that SMBUS_BLOCK must explicitly
be activated and the description how to do it. A comment in the driver,
above STUB_FUNC_* defines might not hurt as well.

Also, I'd prefer to squash Jean's "increasing block length" patch into
this one if both of you are fine with that?

Regards,

   Wolfram


--2xeD/fx0+7k8I/QN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTx83fAAoJEBQN5MwUoCm2PzQQAK9LHsereWaz8VFEVzpY/mnV
cSoRRphO5AOGTe1VXpEg2uivEhNgBRLuxUXqTN/f5YNY4MqwizXe2bstuCYc+jFX
VhdeecDbFg9yw9UHsB/zRu3941VtFJAGkP/nIggu+XdtrnQiS3x64OmTtCMnuHAx
1rOE1scs6xCu5u3PxmcF8KUGJt8HI2N2BVG9YQCiOMxvs24ZkZJGgZr0c2IUgYOa
YxcSvkyAlFLSuPm2E9LUCPWnYWotuUqRt517Ki93jfXcHx9VcB9j7XF2ArpVV8Dv
epIhUTA49OYP+2mwlVWkv7TmS1qMxGQsO5IEVTBjLcMfjfSg3uGOzMoZzKZDEXAx
uT99x9l3bE8yHddPQBFYzd4byEVK6HF55Qn9PGjM8UPb3Pb2DdH0ZP7TSikV9vx3
KOIqnUumNAc30l4foepmNFidVThUp/TR2gvqC+RP25mhMqpvlYuGrnIjcotcN+tD
boPj66RTLagVCu4xw3gCIeiXXU2N1bnxQWmaDB9aiTiM9xRIVNz2LmHgCZbP2r1c
BHLQ6+B2qcn2UQdQQB6Yx1gGE9YKZ57upqr4o6zNRzQLUH2f4IruhrgCFI5hjUfG
CzXCcqRyyBiqzVR0VlYYScjVBv5Y56nF0Pkp+7N33bh6UPIhIjJG/Z+JVX6nyX19
uyTfpJR3yJ1NBce9xkew
=qHnC
-----END PGP SIGNATURE-----

--2xeD/fx0+7k8I/QN--
