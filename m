Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaFCJEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:04:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:3786 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbaFCJEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:04:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="350737363"
Date: Tue, 3 Jun 2014 04:36:07 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Message-ID: <20140603083606.GA15476@gchen.bj.intel.com>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	"Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
	"m.chehab@samsung.com" <m.chehab@samsung.com>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1401247938-22125-2-git-send-email-gong.chen@linux.intel.com>
 <20140528112832.5f83c66b@gandalf.local.home>
 <20140528163452.GF17196@pd.tnic>
 <20140528125625.6f6dcf7f@gandalf.local.home>
 <20140530092232.GA13495@gchen.bj.intel.com>
 <20140530100716.GE28131@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F32823D2B@ORSMSX114.amr.corp.intel.com>
 <20140530210759.267a854e@gandalf.local.home>
 <3908561D78D1C84285E8C5FCA982C28F3282545B@ORSMSX114.amr.corp.intel.com>
 <20140602125748.7093ced8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <20140602125748.7093ced8@gandalf.local.home>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 02, 2014 at 12:57:48PM -0400, Steven Rostedt wrote:
> Also matters how big you expect these events to be. If you get a
> "christmas tree" set of flags, how big will that event grow with all
> the descriptions attached?
>=20
> The max event size after all headers is 4056 bytes. If you go over
> that, the event is ignored.
>=20
Hi, Steven

Normally, the length of one eMCA trace record is between 200 and 256 bytes.
Once CMCI storm happens, before it is turned into poll mode, there are
about ~15 CMCI events are recorded, because I don't use rate limit for
trace so they should be recorded so seriously, some records will be lost.
But they are repeated and similar records so maybe the *lost* is not a=20
big issue.

Return to how to print trace record. To avoid buffer waste, I need to
print data when TP_printk called, in the meanwhile, the print content
is an array of [name, value], but we don't know how many items are
valid. Here is the question: I can't create a dynamic printk format
like "%s %d, %s %d, ..." in TP_printk. So the only way to me is
printking them all, even some of them are invalid, which means an 12
group "%s %d", or somthing like "%.*s" to make output format graceful.
This is what we want?

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTjYj2AAoJEI01n1+kOSLHnLwP/3swsyjyzcxMpyAza5JH1P+w
FXEpHeSoeGN6Kf0g/oaZ+CCBUUZ70V7zWrvtGbvJE0X3zBct/GslGEu8mKr0DTN7
lXK0N+b8npWQx4E0joi+XtcnwfZ6XZrxvYpFLP9qgSk5Lo6tyFYgaPXejEh/pORy
7/1Auq3IpE03FkTZFCnszoWIEcDS1zATldT07gJ9sKbh4DK3Mv//wI6nYcoqIyge
00U2GTdjrpr8DDssPgXjEF7br9NjL23/SamAAIvy4NYcb115M85br2Mvym/8Iaxk
JP2GtANZxGymEP0jJXRtdk5Vz9RAhjdexseDDDk/aidiJfWRZKle2+4Vubic9vSa
Hg/TQzc0X9hzUKsaPrqDxrbPED8Dd5Vy+HymHwrdHbGi+yuB2gBQ7alpuhOcmDzE
YpQQrKVZPtjUhwHMe8zXeGkOcBKpJQj1qPJWNFeKcOPhif5QFZPWuMRi3IHHVQLI
BemtakXC8qaS09Lo0G4FvlXGCVPHabsmnGtVPCpv386ntjRDuzs4hqMj7sDTA9Gw
MKEUWgoIhoWM8jgsjc0xnAJmG0/seFZazqcGAtLdgD3sTyhcN6f2orjJU4Q/2lsh
+4BOjWvg+bCcwxNxqflvigTYwDtdp91vLPesgRJq0jIxHP2kJ7iS7gEjD+0W3CL/
uNMET6lqzntt6G7OT+MG
=p1/f
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
