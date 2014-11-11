Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaKKOdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:33:10 -0500
Received: from mail.kernel.org ([198.145.19.201]:34725 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaKKOdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:33:08 -0500
Date: Tue, 11 Nov 2014 15:33:00 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFCv2 1/8] [media] si4713: switch to devm regulator API
Message-ID: <20141111143300.GA23012@earth.universe>
References: <1413904027-16767-1-git-send-email-sre@kernel.org>
 <1413904027-16767-2-git-send-email-sre@kernel.org>
 <20141111090710.7a60a846@recife.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20141111090710.7a60a846@recife.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Tue, Nov 11, 2014 at 09:07:10AM -0200, Mauro Carvalho Chehab wrote:
> Em Tue, 21 Oct 2014 17:07:00 +0200
> Sebastian Reichel <sre@kernel.org> escreveu:
>=20
> > This switches back to the normal regulator API (but use
> > managed variant) in preparation for device tree support.
>=20
> This patch broke compilation. Please be sure that none of the patches in
> the series would break it, as otherwise git bisect would be broken.
>
> [...]

mh, the errors seem to be from the old code (without the patch
applied to drivers/media/radio/si4713/si4713.c) and the inlined code
fragment displayed by the compiler seems to be the new code (with
the patch applied to drivers/media/radio/si4713/si4713.c).

Possible reasons I can think of:

 * You are using some kind of object cache, which assumed it could
   link the previously compiled si4713.o
 * You started the kernel compilation before merging the patch and
   the commit was only half applied when the compilation reached
   the si4713 driver.

-- Sebastian

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUYh4cAAoJENju1/PIO/qaYqsP/j6SRe41NWwhYwhF5B3CDSUs
SKNXfUgBGu0ZmNKaTkpWem4+08g+qPhmj9XDlOvOr3lr3cvcaUA5+FTPehraYRh0
kju4widgN15lpJsvVngaV5rU48ksC6nbXko1OUKkWTSR/Ye8wvN7Xboor4vAw30V
cvBt+R3QG4Y5RHCmBKBSCYyO/yUYQ2IIsblKZEdby4ivZVJHyQ9qdb+c/E9I3UpF
vWtzVBnm1gKVYJc4BkZP3hPqkVFSiOqCG+1mnZNcJoEHEJOtKoOReIjO+qx6idsz
o3JX2/Zaqz9vCEN3GuIiiNdewPOQxaNR6lWavXhbAo08W9h9xUxkG5dQA3QxBTpn
xEzAkxTc/VA0uJd1MCcopDv4Ryu8m8938nhgmP5d920D5mV8rfEpOyyi80wTTCLV
RHd3dlgmDCePsTEyt3vxYDGh6ErRoYKBdQJPvm65wtBUc7AZ3Ih/fjTzvC5W/ZFY
moQCZP6dOr8lrv4Xqp4DDWuVzPuH09cPdGYsasM1nM4rlGGYvVpWBM8F7/KvlKjT
vF7Udnroh5zmyfYQfcexwPmuwAEqL3mBduvLHUfPvvLn5BwpAg69AEVMBcH4cgpt
NeLmzPP16fpoGUln0gtxOCn2offK8sT0hVwzEErrA5RPEQwWxEHnZVRqvgR7G1j0
Y9Yo10GblfzsXrF0s5L3
=3sNS
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
