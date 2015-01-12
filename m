Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbbALKN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:13:59 -0500
Received: from sauhun.de ([89.238.76.85]:59542 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbbALKN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:13:57 -0500
Date: Mon, 12 Jan 2015 11:13:49 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 02/11] i2c: add quirk checks to core
Message-ID: <20150112101349.GA995@katana>
References: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
 <1420824103-24169-3-git-send-email-wsa@the-dreams.de>
 <20150112095847.GD3625@ldesroches-Latitude-E6320>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20150112095847.GD3625@ldesroches-Latitude-E6320>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> I am not sure it will perfectly fit at91 quirks.

I think it does.

> The hardware can handle two messages by using the internal address
> feature. The internal address size is from one byte to three bytes. Then
> the length of the first message is limited to three but we don't have
> this constraint for the second one. If we have 'write then read' no problem
> but if we have two write messages, the second one will cause a quirk
> exceeded error.

Yeah, for this reason I seperated I2C_ADAPTER_QUIRK_COMB_WRITE_FIRST
out. The first message is checked against max_comb_write_len which is
set to 3 for your driver. The second is checked agains max_write_len
which is unset in your driver and thus can be of any length.

That should work, no?


--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUs55dAAoJEBQN5MwUoCm2gf4P+QECpDMLwMrK3kh5i4CYdzF3
c6wzWfew04QCEjN5xmZNJqcTeFZWcQ9x+RX8NWRhVSx6gVqsc8jGxKzZDALM63TF
1j3Zvn54NK99hBPVgeyI1VLqLrRfNDoSIp3Pdf9paGFO6cvsEY38FT9P/qTGC3fH
ckIiaCjlg/QLV8bp+gSJLUPyo5V8n7eLXi6tmzCYh79AfuFMZ0s8Ct4IAQA/hiOE
Kxyw1jVundVZatdmIsfVSdSrdbV5WE2m1vasj426uvVoVTFgp2Zz+ANNxzj3Z7aL
yQvYFUjbnFIunPAplVF8CTAUcPpfa3uv1EY9T+iN0rFeTVs9HIIBz+PfDDLgvvfB
gtniH+vqId9NK4JPKlmJcKzK8AXrfeEHIEiRMpofve6ts8QTDcpFJnJw3lvVn2yS
Y+GGKAqmOTLUwzMDk0I0/JYw+OoFQOdaEGZJogYCuvR/yVwagzoJKKq/dZpvqghY
By8yNEIZgfDDXYI2ZeMgn9tNpYUlBpka7pXtl0jhrQxrNm2p8SEnDsd9ZrbtECjZ
k6HSiPMhmWfg1X3856qQVm6OxNz4n+PJLjMCkh5kR956tIlK42x5bnJFIQVtLczB
Q1ITIUfeWpXOus1OX1rw5NQU5jibczKT4PK7ZcjbXGRefAhJYXRnDlLjzkgW1r7f
WzSXkfbxs+E6D0NLDa43
=Hhq0
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
