Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab3JOJdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 05:33:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:34599 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab3JOJdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 05:33:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,498,1378882800"; 
   d="asc'?scan'208";a="411144602"
Date: Tue, 15 Oct 2013 05:18:35 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Lance Ortiz <lance.ortiz@hp.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/8] ACPI, APEI, CPER: Cleanup CPER memory error output
 format
Message-ID: <20131015091835.GA21097@gchen.bj.intel.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-acpi <linux-acpi@vger.kernel.org>,
	Lance Ortiz <lance.ortiz@hp.com>,
	"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-8-git-send-email-gong.chen@linux.intel.com>
 <20131011160208.GL5925@pd.tnic>
 <20131014045500.GC12189@gchen.bj.intel.com>
 <20131014103616.GE4009@pd.tnic>
 <CA+8MBbJ9P1GVf3SCh7LMY_LH+pxQg3GWkxKMzni1b1Wyx1o8NQ@mail.gmail.com>
 <20131014184717.GK4009@pd.tnic>
 <CA+8MBbKDhFvRmJv1csMp5At8WfvHvSsDBbCKvOfQhVdgmnwBWg@mail.gmail.com>
 <20131014215047.GL4009@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <20131014215047.GL4009@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2013 at 11:50:47PM +0200, Borislav Petkov wrote:
> Date: Mon, 14 Oct 2013 23:50:47 +0200
> From: Borislav Petkov <bp@alien8.de>
> To: Tony Luck <tony.luck@gmail.com>
> Cc: Chen Gong <gong.chen@linux.intel.com>, Linux Kernel Mailing List
>  <linux-kernel@vger.kernel.org>, linux-acpi <linux-acpi@vger.kernel.org>,
>  Lance Ortiz <lance.ortiz@hp.com>, "Naveen N. Rao"
>  <naveen.n.rao@linux.vnet.ibm.com>
> Subject: Re: [PATCH 7/8] ACPI, APEI, CPER: Cleanup CPER memory error outp=
ut
>  format
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> On Mon, Oct 14, 2013 at 02:03:16PM -0700, Tony Luck wrote:
> > Do you have a suggested mechanism for this disabling of dmesg?
>=20
> Hmm, how about a 64-bit flag variable (we can use the remaining bits
> for other stuff later) called x86_ras_flags which is private to
> arch/x86/ras/core.c (a new file)...
>=20
>  [ btw, I'm thinking of something similar to efi's x86_efi_facility which=
 we
>  nicely query with test_bit and set with set_bit and clear_bit, etc, etc ]
>=20
> Also, look at arch/x86/platform/efi/efi.c::efi_enabled() how it hides
> the actual variable and we can do something similar so that eMCA and
> other users like cper.c can do
>=20
> apei_estatus_print_section:
>=20
> 	if (!ras_tracepoint_enabled())
> 		cper_print_mem(...)
>=20
> We set the bit in x86_ras_flags from, say, debugfs, i.e., a userspace
> tool sets it and from that moment on all RAS output is rerouted to the
> trace event. I.e., the output for which there is a trace event...
>=20
> How does that look like?
>=20

Looks fine to me. But a little bit out of current patch series. How
about adding such interfaces after this patch series is merged?
And from your words, it looks like you prefer to reserve all current
fields to avoid breaking user space things. IOW, drop patch [7/8]
and use another patch with above idea to get the same purpose. This
is what you want, Boris?


--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSXQhrAAoJEI01n1+kOSLHtE8P/AgitrlX7c1sU0u2cK+oSQA2
1HCrfx7ZGoqev4kuFQGmmgX+KZDpU89/906n9v8cubH6SaioPlQlVeFFD9BSHuvT
NVkDaq41DYLToB+HJbDIPSu6YHuf+J6ptUNSKlTwjK3Fe9HxklLkZ5aHw3Kc/Lkc
g2m5KHOHgig4bMxko5Yv5J19p04knarL9byyPOa985/XzFWrp8X8IRp9L4PyZCSS
+40byeZAAwNXOabokZJiwLQvEa5UpNSQ8tOaD8tJ7H7T9gZYFfcPw1tVBJZ1Asaq
VKaCPv+Fzoo6YxMqIF/O2J9Lqgc/PK0JnBlXyFaIb6oO+VxtLiece55BcmXwZQu3
C5bJQpsCuphsa2GTsvboeXFX9lvxt1ULdQrnrnAtMVj5bu5Ur+iX29edsZH31JTd
0wvt1GtqgkTyuNPd6jCMl6OVC/MJzmvkMD8Q72Ye1j6OC7ursrUA0w5wpFMO8HVs
3AueD09nU9l9GeJcCiQ1ePrER/meVl3MWGgRh1xwS3k4JWACBNoSSopvT2PRxB25
SOfysKypLT0pb5qhfF6RWMNsq4sG7DEt5GJ+dkFzg9lcWdo+5aH+McsofNkFiYj5
Hh21T0w5YsbUkblhcHpbaa9dOOZKhTZu1aFGnlP2PBGSgbWfU0Nm4k8bRn2ht2Km
7TD9m3EIE5q2NFTOLLN3
=EKgU
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
