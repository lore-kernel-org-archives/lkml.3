Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3BQG4D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 01:56:03 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:43573 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab3BQG4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 01:56:01 -0500
Date: Sun, 17 Feb 2013 01:55:58 -0500
From: tmhikaru@gmail.com
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: Re: [PATCH 2/2] dmi_scan: Refactor dmi_scan_machine(),
 {smbios,dmi}_present()
Message-ID: <20130217065558.GA2113@roll>
References: <1361037634.5374.437.camel@deadeye.wl.decadent.org.uk>
 <1361037742.5374.441.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <1361037742.5374.441.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 16, 2013 at 06:02:22PM +0000, Ben Hutchings wrote:
> Move the calls to memcpy_fromio() up into the loop in
> dmi_scan_machine(), and move the signature checks back down into
> dmi_decode().  We need to check at 16-byte intervals but keep a
> 32-byte buffer for an SMBIOS entry, so shift the buffer after each
> iteration.
>=20
> Merge smbios_present() into dmi_present(), so we look for an SMBIOS
> signature at the beginning of the given buffer and then for a DMI
> signature at an offset of 16 bytes.
>=20
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> This file mixes up __iomem and regular pointers a lot, and this patch
> fixes some but not all of those instances.  Presumably it is quite
> safe to read a BIOS image with any mov instructions the compiler
> generates, but in that case maybe we should explicitly cast away the
> __iomem qualifier in dmi_ioremap()?
>=20
> Tim, you might like to test that this doesn't cause a regression
> of the previous fix.

I can confirm that this works just as well as the last patch you gave me.
I'm sorry that it took me a while to reply.

Tim McGrath

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEVAwUBUSB+/pEncCrqzVruAQJ01AgAlHDoKGQjcTCh4dkTy0suSowFj3nf5D+8
4jDOuckigvmjUrCr/lLX2V2lfZhq262ZL33B5ddak5yN1SpH2OUo+7ST26IEHrKu
uOqWE4qVSIhYITy/aDE2S5sW9/VIw5YBIbL8tYYhecWFgNiXmm4QSz34GN+2rmAR
WqH/GBYqAcoqx4QN8Q8eEv03ijvkvaf7HjX9SdxSsslBw8/XcsTgxOT4FeHHodF/
6K3PS2pVBUEmSDLgUitOPTarsaRV0sLjpG8geiex8vzrHGg4LYZXF6N8LZisLTs8
fBoX4EhFscAVl2XYM8KEg3M6q33PRpwMJlQE7QFqzp+CC+mUNdav8w==
=2dO0
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
