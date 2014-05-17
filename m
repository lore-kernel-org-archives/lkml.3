Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780AbaEQJlh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 05:41:37 -0400
Received: from sauhun.de ([89.238.76.85]:38069 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009AbaEQJle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 05:41:34 -0400
Date: Sat, 17 May 2014 11:41:20 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: rjw@rjwysocki.net, mika.westerberg@linux.intel.com, awilliam@redhat.com,
        lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V2 5/9] I2C: Add smbus quick read/write helper function
Message-ID: <20140517094120.GA2602@katana>
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
 <1398695268-28645-1-git-send-email-tianyu.lan@intel.com>
 <1398695268-28645-6-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <1398695268-28645-6-git-send-email-tianyu.lan@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 10:27:44PM +0800, Lan Tianyu wrote:
> Add i2c_smbus_quick_write/read() helper function. These will be used
> in the implementation of i2c ACPI address space handler.
>=20
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

We had such a function once but removed because of no users. Please
check 67c2e66571c383404a5acd08189194da660da942 what it takes to bring
them back. Especially missing are documentation updates...

> +s32 i2c_smbus_quick_write(const struct i2c_client *client)

=2E.. and I like the original function much better.

1) It is named *_write_quick which follows other function name patterns
2) It uses a parameter for the r/w bit. Make sense to me, since this bit
is the information we send to the device. quick_read doesn't make sense
to me. We don't receive a bit from the device.


--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTdy7AAAoJEBQN5MwUoCm2NSUP/2EZxG4n2opUpSHD0ZrcWkVY
KRqmpf0RkmKo49EyPtZvF43kBzqKB4yFSHdVR8J7oAgQkn8v7v7YDcRKy7cPW0jN
JR9eKSi8ETvoUCO6hyxtyT/C3gYuCk0QAAsWh3Gkn59an4slL3knOKPD0D+yEK7W
1wmkWP0SuE40a2TikN627uw+Du2Wyh+v+EecRUcctAD6Xbg0SF5jdPK2jH/giHbh
n0bfX15mPPdkCD4aGh39LnAQZqw7TbV5o/TrYKGLM0MRj0qiEWNd9HctrupTwcMW
lJydAauSHTNJNZ3FBMSb79Q/fcsf3HzhLpcqBkv1bX/Ldmtb+uXPi460XLorMLaX
MBPzPvnTIxjwu4GVuKjXxiiFwTpf1T9dSaUaOPKBmEjGcjxNGrEnRukwGqJFbllz
VPm5YHRTBEeL74Zx8qvC7brqGk0ttBtN9qSKFfjy3YQ2whid96cLEEcq/VA/tYej
Nngw5ho6zs4X+ReeVZDZJlmuwTWiamTGCXqhf81UBDXbTVwbQJmlH29fSWM8O5m8
PlH/ZDC1i1kBPlCdqmJYQ5fW2WWu4OqO+R8d6ywNRV4c5o7z+V0iWvgybO58DUQD
C6cv65MjEMAbn4V5sU5bgiuE0rUewuJgHm7Eec4dZV1ra/e/AjPnqZP1VUa1vTdJ
L3XtiCzNndwg6onviNfP
=4bzq
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
