Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965785Ab3FUMrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:47:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:11882 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965683Ab3FUMrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:47:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,913,1363158000"; 
   d="asc'?scan'208";a="353512385"
Date: Fri, 21 Jun 2013 08:38:58 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/MCE: Update MCE severity condition check
Message-ID: <20130621123857.GA2784@gchen.bj.intel.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com,
	linux-kernel@vger.kernel.org
References: <1371719773-27572-1-git-send-email-gong.chen@linux.intel.com>
 <20130620094152.GJ32694@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <20130620094152.GJ32694@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 20, 2013 at 11:41:52AM +0200, Borislav Petkov wrote:
> Date: Thu, 20 Jun 2013 11:41:52 +0200
> From: Borislav Petkov <bp@alien8.de>
> To: Chen Gong <gong.chen@linux.intel.com>
> Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] x86/MCE: Update MCE severity condition check
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> On Thu, Jun 20, 2013 at 05:16:12AM -0400, Chen Gong wrote:
> > Update some SRAR severity conditions check to make it clearer,
> > according to latest Intel SDM Vol 3(June 2013), table 15-20.
> >=20
> > Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
> > ---
> >  arch/x86/kernel/cpu/mcheck/mce-severity.c |   15 +++++----------
> >  1 file changed, 5 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kerne=
l/cpu/mcheck/mce-severity.c
> > index beb1f16..1fa12ea 100644
> > --- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
> > +++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> > @@ -110,22 +110,17 @@ static struct severity {
> >  	/* known AR MCACODs: */
> >  #ifdef	CONFIG_MEMORY_FAILURE
> >  	MCESEV(
> > -		KEEP, "HT thread notices Action required: data load error",
> > -		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI=
_ADDR|MCACOD_DATA),
> > -		MCGMASK(MCG_STATUS_EIPV, 0)
> > +		KEEP, "Action required but non-affected thread is continuable",
> > +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI=
_ADDR),
> > +		MCGMASK(MCG_STATUS_RIPV, MCG_STATUS_RIPV)
> >  		),
> >  	MCESEV(
> > -		AR, "Action required: data load error",
> > +		AR, "Action required: data load error on user land",
>=20
> You mean "data load error in a user process"?

Yes it is.
>=20
> >  		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI=
_ADDR|MCACOD_DATA),
> >  		USER
> >  		),
> >  	MCESEV(
> > -		KEEP, "HT thread notices Action required: instruction fetch error",
> > -		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI=
_ADDR|MCACOD_INSTR),
> > -		MCGMASK(MCG_STATUS_EIPV, 0)
> > -		),
> > -	MCESEV(
> > -		AR, "Action required: instruction fetch error",
> > +		AR, "Action required: instruction fetch error on user land",
>=20
> ditto?
>=20
ditto

> --=20
> Regards/Gruss,
>     Boris.
>=20
> Sent from a fat crate under my desk. Formatting is fine.
> --

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRxElhAAoJEI01n1+kOSLH+v0QAKcJGgsb0YANrSRAfM7L0ETR
33VRuuV24+m4UoslPl8bngyfWsD+53Fnkk+0eRhj6JvVd8il8ftPgrjRMhhlSO7u
QZxubuGWTL1tpoQq25zkq0wAHtQXuzeFzrV25ZMjH1s1644pnr6lNyAwCKEb/Jsb
nqGxz6vn8Hh9NjZAkS5l3E6N/XaBfXZJtis1RCOxqLF7td+AhKEfzFM43aElTuEs
JV/e6g2xDgCc4Xx0tUVS9HHjoFFt81IdTRge0pTvOtP6URrc6XuhHRM/Vuba/qp+
gmdI9CWdUCpFVCMQYlogF0l8ssKn1p9ynL+XPDFcKeTmkv8o5aOsyvzRa0ALNW6h
pblPdKsJ69s2yIMx16z2F9qX7JpxbDH1Qe4BKpGCb16GZVhjGQj0owzJ9yWFvujJ
cH5uWHKFqzbTABdVPSUlvelO1cGOSIwh8ws+qBmWIEE3/UXifxMD62Kjry1mXFIc
ZQJiPnu8bgkdsoFoZKzXVSkIuoZa4wv182VsHR0DJcTgFHRLc03t7YLQr3H8tHKN
VHURtNV97p5BSyE1zRR8O6U4BbiV4xHldxNPe4m3wgi5a1rYf0vg3b/mW0MLDvaz
r68Eh/91np06VIL0TbwCnJhmqGeLKWIFMbt1TTvo65qL3QbMF/4YCWGD92r0ZWXT
9hwSneqPEB6mnXvqqXSv
=cnS8
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
