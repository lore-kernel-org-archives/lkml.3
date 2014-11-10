Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaKJJxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:53:33 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:32791 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaKJJxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:53:31 -0500
Date: Mon, 10 Nov 2014 10:53:26 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: swarren@wwwdotorg.org, daniel.lezcano@linaro.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, tony@atomide.com, mark.rutland@arm.com
Subject: Re: [PATCH] timekeeping: Move persistent clock registration code
 from ARM to kernel
Message-ID: <20141110095325.GC12126@ulmo>
References: <1415388855-35074-1-git-send-email-anatol.pomozov@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
Content-Disposition: inline
In-Reply-To: <1415388855-35074-1-git-send-email-anatol.pomozov@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 07, 2014 at 11:34:15AM -0800, Anatol Pomozov wrote:
> ARM timekeeping functionality allows to register persistent/boot clock dy=
namically.
> This code is arch-independent and can be useful on other plaforms as well.
>=20
> As a byproduct of this change, tegra20_timer becomes ARM64 compatible.
>=20
> Tested: backported the change to chromeos-3.14 kernel ran on tegra 64bit
> board, made sure high-resolution clock works.

Using this on an upstream kernel doesn't work, though, because 64-bit
ARM doesn't implement struct delay_timer which the driver needs since
v3.17.

But I suppose the delay timer infrastructure could be moved into the
core similar to the persistent and boot clock as this patch does.

Thierry

--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUYIsVAAoJEN0jrNd/PrOhP2gQAIq3dXzLlzPdAUe5ZqwwaVjw
2bG24nAbEOrSYTFov6xv2/p4PlveZlA5e7dHSohjLWWqwB3OjxLB1GRjmb2felU2
sJ+lViGQZjh0fOuPI++ByrKa38fUrtHf2WgdyOIO2rsAUOKLFMJhxShtEi+i7ISJ
jhvioOZpHd2FZzF22em13jVx0HQX+sSpups5JDb6hFDtJGUr/2hIa/x/DW0nM2oU
4bqNfUddk7OlssL/npjn4X5eTEUun7gyodRrw71JVW249nDj08dnqjlSsA/GBVxJ
gpUsX0vyG0bC+kQZKJg4lHPR2l0YvbgPmLzfMxelUB0siLvetCYIGbHCNBk1MSq1
uAO5uxmI1BupvxSssAPwdZYoqi9YsFVXmhUhEqZaqd1TfJGwXIyS0SVunY/AzebB
fcCDyGJUbWwekRrzIiyDVjZqHVzeqoTxP6N1stE9mVIlkp/kr5Zsae2LabcHDFDf
g2TbkzpcUkNiaQASIRFFcl6AOVLl823LeaqRono7CHBX/9/uczgpOkespsjdPqqR
THtvd5YXodacMfh0N338E12KNjciY6xzCRDEISmfBfqnJTErhPa0gZaawdiOD5K8
TMk5aQjeHlElRgu+AeuYIsKhFnX5PXD3rW/uiwC0mLqPaE8NAfdK6UsdDXejKIJE
2Adhu06JP7uWM+4QOVik
=nFkv
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--
