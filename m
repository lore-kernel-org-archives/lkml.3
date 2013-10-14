Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab3JNNRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:17:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:39657 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157Ab3JNNRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:17:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,492,1378882800"; 
   d="asc'?scan'208";a="418884270"
Date: Mon, 14 Oct 2013 09:03:11 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/8] ACPI, x86: Extended error log driver for x86 platform
Message-ID: <20131014130311.GA1695@gchen.bj.intel.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-4-git-send-email-gong.chen@linux.intel.com>
 <20131011152451.GF5925@pd.tnic>
 <20131014031633.GA12189@gchen.bj.intel.com>
 <20131014102635.GC4009@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <20131014102635.GC4009@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2013 at 12:26:35PM +0200, Borislav Petkov wrote:
> Date: Mon, 14 Oct 2013 12:26:35 +0200
> From: Borislav Petkov <bp@alien8.de>
> To: Chen Gong <gong.chen@linux.intel.com>
> Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
>  linux-acpi@vger.kernel.org
> Subject: Re: [PATCH 3/8] ACPI, x86: Extended error log driver for x86
>  platform
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> On Sun, Oct 13, 2013 at 11:16:33PM -0400, Chen Gong wrote:
> > But this driver can be loaded as a module. If this module is unloaded,
> > extlog_print is gone. I can't keep such a pointer internally.
>=20
> Sure you can - you define a weak extlog_print() function in a
> compilation unit which is always builtin. Maybe mce.c or so.
>=20
Oh, yes. Let me do it.

> > This macro is great and I'd loved to use it. But it looks like a
> > litttle bit weird to let eMCA depends on a header file like edac.h.
> > Meanwhile, I found in drivers/video/sis/init.c:3323 we have a very
> > similar macro for this purpose. So how about writing a separate patch
> > to clean it up first?
>=20
> Actually, you're right. Those macros are much more generic and
> could be exposed to the general public by putting them, say into
> include/include/bitops.h, for example?
>=20
> Btw, the sis one generates unsigneds (4 byte on x86) while the edac one
> 8 byte ULLs. So you could call them
>=20
> GENMASK
> and
> GENMASK_ULL
>=20
> How does that sound?

This kind of mask is often unsigned. So how about following mode:

GENMASKL / GENMASKQ
or
GENMASK_L / GENMASK_Q

>=20
> > Because I think in theory "CPU < 0" is impossible. When it hits such
> > situation, it should be a very serious H/W or firmware bug. At least,
> > It think it should be a WARN_ON.
>=20
> Yes, I think a WARN_ON is much better than the heavy hammer. We can
> always turn it into a FW_BUG later if it really starts to trigger
> anywhere...
>=20
Agree.

> Thanks.
>=20
> --=20
> Regards/Gruss,
>     Boris.
>=20
> Sent from a fat crate under my desk. Formatting is fine.
> --

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSW+uOAAoJEI01n1+kOSLHUPMP+wcvtXl3jrPm94dMWfbgSgVS
0DQBouyL8hiIKntks0ijHWBJfltCrXQtaHMGJO9hF+1lGdXkOHkCT8eDpKqQDJ17
EE35N5xVaaTV9cbeZ3ts26HzGmr1umbeKDFid1QzmBtWWbA2L2XI1qQA+kpRTvIL
s4vAIR00VpfDZZGLAVCCzhAK4WtE3XyvyWKuC0k+zmuHs93ilS34GmhdEsukTD4N
KIwBp367Eb1yKBx5QhdauQQljFzwUEZ3ZKZ3KlEbOF7zbwcc5kIavdqRH0cCSbfu
eC/PsWQCSVQ6FvIRa8xp+mIyFHLVDjfzTd096N5isgLPKmYdrwoUZQ42Oyc/yuh4
x5fyRb+pEVRSqu3IZCF6SGjp3T/Wi83UC5Y8TvS4t1WNfL0mW4pf7nRQ+udLu0eU
EwZdndIBL31Fqe9/JtaCwxDUqB0T4G9kPe8Xc3ZQQcrBK1LVMb9l/lUfsezMI4gK
hLlYBtf8jVRDbHTLijQf798raA7mV56F7LrbN1EXYy/qnqLoidc9kPtbJNE2bbYF
RrKq6JNrHgDWNDSH0AckaJO/xYWdMvV8K6b0NIFW5vPIIIfTygDC7gb0CwMWR79+
R5LOBE89zIDb1jmpoFD4+VzJV3sKuZOKPinFqxrwANZdIxCajmbUGyDKkJwuYxBW
Sg8JjxqF/9dWompwWLtq
=aRKN
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
