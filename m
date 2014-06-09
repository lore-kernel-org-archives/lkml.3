Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaFIBim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 21:38:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:6523 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbaFIBie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 21:38:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,1000,1392192000"; 
   d="asc'?scan'208";a="554144241"
Date: Sun, 8 Jun 2014 21:10:15 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Message-ID: <20140609011015.GA26536@gchen.bj.intel.com>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	"Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
	"m.chehab@samsung.com" <m.chehab@samsung.com>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20140530092232.GA13495@gchen.bj.intel.com>
 <20140530100716.GE28131@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F32823D2B@ORSMSX114.amr.corp.intel.com>
 <20140530210759.267a854e@gandalf.local.home>
 <3908561D78D1C84285E8C5FCA982C28F3282545B@ORSMSX114.amr.corp.intel.com>
 <20140602125748.7093ced8@gandalf.local.home>
 <20140603083606.GA15476@gchen.bj.intel.com>
 <20140603103544.207eaa6e@gandalf.local.home>
 <20140606065141.GA10998@gchen.bj.intel.com>
 <20140606112127.37d2cf95@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <20140606112127.37d2cf95@gandalf.local.home>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 06, 2014 at 11:21:27AM -0400, Steven Rostedt wrote:
> Date: Fri, 6 Jun 2014 11:21:27 -0400
> From: Steven Rostedt <rostedt@goodmis.org>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
>  "m.chehab@samsung.com" <m.chehab@samsung.com>,
>  "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, LKML
>  <linux-kernel@vger.kernel.org>
> Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
> X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
>=20
> On Fri, 6 Jun 2014 02:51:41 -0400
> "Chen, Gong" <gong.chen@linux.intel.com> wrote:
>=20
>=20
> > +/*
> > + * MCE Extended Error Log trace event
> > + *
> > + * These events are generated when hardware detects a corrected or
> > + * uncorrected event.
> > + */
> > +
> > +/* memory trace event */
> > +
> > +TRACE_EVENT(extlog_mem_event,
> > +	TP_PROTO(struct cper_sec_mem_err *mem,
> > +		 u32 err_seq,
> > +		 const uuid_le *fru_id,
> > +		 const char *fru_text,
> > +		 u8 sev),
> > +
> > +	TP_ARGS(mem, err_seq, fru_id, fru_text, sev),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(u32, err_seq)
> > +		__field(u8, etype)
> > +		__field(u8, sev)
> > +		__field(u64, pa)
> > +		__field(u8, pa_mask_lsb)
> > +		__dynamic_array(char, fru, 48)
> > +		__dynamic_array(u8, data, sizeof(struct cper_mem_err_compact))
>=20
> For constant size arrays, don't use __dynamic_array() just use
> __array().
>=20
Thanks a lot! I will update it.

BTW, any comments from other guys? Boris, Tony? If not, I will send out the
new version tomorrow.

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTlQl3AAoJEI01n1+kOSLHJDoQAJR275d+5yxWI3uD87vKSwYd
KtlCCOYPLnufEsCXWtHgxctTyKljD50q+6davMeirPRg6ZMAtG2FoM3p+3GcDVg8
tf50E6ZLPZmK8Do96uJ51mMBoGke3bUWNWVz2T4iMnqEWAPA3cGXuDC2vnJc81A4
BexV8ic1boPe4B9qSOr7xDfqjff5R95EhVmmuSCnc7mIXPKT8FbMmAHNPSGRmA2y
Wv20dQRc9Gl7Jkrk3MvUcjkvNlCLJho3PsNZtM8figPVigOrrm3oimd/NEzJmaYs
A063W5fMn0UcBVxy8Eyv5GyVNC9DMGOw6VrqXOl1lWpKuP/7kU1bZ056eZxAGtlg
rgEPlEMSeEjnpX5XqxcwhlRU8bD0wJf6Mfvp2lBngbNlKOamPHhGIDPFD7BNNZ8A
unK6RWu4bOpWO5oYyP8gnV5B3B5ztng5FzGfnMB9MayZqQT/9oXkBwwlDKQz5/GE
uHFdIhZLvyZQ0C99AAVCkvNSjz4T78+MMIP/ZnWl654ljAaUbqsCsybn36x9x7FL
EfATmXRW9KHCY/REnyG/VRythH7rpu3Y4uqw3ONRHSVO8vtWRyPyw25Qqp1T25x7
MUF5r48XckiLpbK5ilj4VfXCCgS0SDaa9r2osf5cy8dEFPYvcydjmkZpAkRQMfK5
SneuHpoFiHpHvAdT/CH2
=8yEV
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
