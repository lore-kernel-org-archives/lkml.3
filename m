Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab3BNFER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 00:04:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48627 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750729Ab3BNFEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 00:04:15 -0500
Message-ID: <1360818247.5374.300.camel@deadeye.wl.decadent.org.uk>
Subject: Re: 3.2.38 most of the time has 100% cpu use reported
From: Ben Hutchings <ben@decadent.org.uk>
To: tmhikaru@gmail.com
Cc: linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2013 05:04:07 +0000
In-Reply-To: <20130212050116.GA2146@roll>
References: <1360160863.32217.30.camel@deadeye.wl.decadent.org.uk>
	 <20130207173630.GA8355@roll> <20130208190819.GA16894@roll>
	 <20130210151140.GA2307@roll> <20130212050116.GA2146@roll>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-pzcN6ffP9rHXu9ycrd2T"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pzcN6ffP9rHXu9ycrd2T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-02-12 at 00:01 -0500, tmhikaru@gmail.com wrote:
> 	Okay, I finally have located the patch causing this bizzare problem
> for me. Before I discuss it, I'm going to drag out the kernel bug reporti=
ng
> guidelines and try to make a proper bug report out of this.
>=20
> [1.] One line summary of the problem:
> 3.2.38 most of the time has 100% cpu use reported
>=20
> [2.] Full description of the problem/report:
> Reverse applying the patch for
>=20
> [9a1f08a1a192f9177d7063d903773aed800b840f] drivers/firmware/dmi_scan.c: f=
etch dmi version from SMBIOS if it exists
>=20
> on top of a clean 3.2.38 tree makes the problem go away.
[...]
> I have to admit I have no idea what the patch I'm reversing actually does=
,

It changes how we look for the version of a BIOS interface (DMI or
SMBIOS).  All the code that it touches, and the version number variable,
are discarded after boot and therefore can have very limited effect on
what happens later!

> what the cpu is doing when it's stuck at 100%, nor how I would diagnose t=
his
> further or whom I should contact.  I'd like to help anyone who wants to f=
ix
> whatever went wrong, so please contact me.

'perf top' will tell you where the CPU is spending its time.

Ben.

--=20
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camu=
s

--=-pzcN6ffP9rHXu9ycrd2T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAURxwR+e/yOyVhhEJAQo+xxAAvNSCXVmqUR8n2LK1BLj8vgPvFN68iiVq
0AVRwmc+D0j+M/dhCa/+eyNckTd4gkdTN+7w8k+F9Uc2s77VmtKAqUwWM9O5MN4L
2yXhd5IEx0Go3VM6FH7PpyBZH8wdgxRNZimTcQg2DbWv+JkngZzGGGcuJxetURTB
SzkQt+nex/d3Wdy5pBt6QJt6r2St9aEXrUTpe/NLUiSs8I3VEWsQWeAe3P0fQO65
M7K/L4uIjJ6ujsPnVUh0UPSuo5hg1s0m7DM5ZAmWm9ZAOTW1PuyKWDmirn9yDYCW
Zcdo+y5umqQAjRJ9EllCcnZJi6XjrHNrhuHAwxxdunVxzWT51VkHEAvzHNCtoWD3
4kfPsfUBtJfrbVP8OtCCt//FUGQcmEAyTqUq5y5GfElTsKz4AY6EM0P3JobSsVwI
YkuxxOtn1rTvmFodwWcH/6zoNmw87dtBl/9vHuDxccrHaU/MqaICbioJIot6qFGa
7a7YUNu5lXzcWFOdbKUTwLYi4gZkgHl1/Q1Fyp0mEaVQgHEP95H2zKyeUtZqVp0+
093ZoZcB7Vzd18rIZMqpy27oUWG2r7MMubUF2GlS42AGD+Q2c68QzAh94ZV9ZASV
82n5K8KwqUQ34o9ztlvUQPihS88CCoDQuB2NPtEVCwAgJPDGGKC7qVOLfBRVq2MF
uv2DRlCqRfo=
=bcmV
-----END PGP SIGNATURE-----

--=-pzcN6ffP9rHXu9ycrd2T--
