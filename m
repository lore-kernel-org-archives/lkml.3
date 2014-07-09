Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaGIO6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:58:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:59821 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbaGIO6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:58:18 -0400
Date: Wed, 9 Jul 2014 16:58:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH V4 1/2] perf ignore LBR and extra_regs.
Message-ID: <20140709145809.GG9918@twins.programming.kicks-ass.net>
References: <1404838181-3911-1-git-send-email-kan.liang@intel.com>
 <20140709141631.GE9918@twins.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F077014D2005@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MrRUTeZlqqNo1jQ9"
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F077014D2005@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MrRUTeZlqqNo1jQ9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 09, 2014 at 02:32:28PM +0000, Liang, Kan wrote:
>=20
>=20
> > On Tue, Jul 08, 2014 at 09:49:40AM -0700, kan.liang@intel.com wrote:
> > > +/*
> > > + * Under certain circumstances, access certain MSR may cause #GP.
> > > + * The function tests if the input MSR can be safely accessed.
> > > + */
> > > +static inline bool check_msr(unsigned long msr) {
> > > +	u64 value;
> > > +
> > > +	if (rdmsrl_safe(msr, &value) < 0)
> > > +		return false;
> > > +	if (wrmsrl_safe(msr, value) < 0)
> > > +		return false;
> > > +	return true;
> > > +}
> >=20
> > What does this thing return after patch 2? does the write still fault o=
r will
> > KVM silently take writes too?
>=20
> If applying patch 2, the function will return true. The KVM just simply i=
gnore the reads/writes.

OK, then that's broken too. We want a function to return false for any
malfunctioning MSR, ignoring writes and returning 0s is not proper
functioning.

--MrRUTeZlqqNo1jQ9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTvViBAAoJEHZH4aRLwOS6HHYP/imLIsUJ8Z2qUFtIPInFDg97
g8HtI3AxDt30wZk4IJ8OU8YANVwTvaBcr+BGpVECgeU95QqQldeWySc+rt3gbC1o
qxEd6JCQqV7ECdoTMVxmRScq268SOC82FB/cZzWOwej7SA6BHbXv9/aMQ+oI/fOY
/jIlpWPdckNEDarDhVRqqHXa5cQ4Vt2fDRWiIYY9ffLBOvvcq/WT29FKLdr1fd5Q
VPlYsz/nXFcK2hxLcCBLbGUsleB35te21temSxl6osSAWRE8kLk9xYb0YkyiYk9b
82edfmOCOIcPK2sORVIb2nAye8ieq+5RrpBgiPRfeKPDxxFoWj44FPs856qzm8SP
STIJmlZ5KPcop3wITbyjxFa69aHOI9q9K7XrKpX0Vif7D0GdOFVjgflK/IBYKEew
sInGf4u1byB6KF+HGPov23NrqnhpDuZzW6OZG0N3fWylL4/HbGC0ksre0WT954zS
aJNTRoWAqdfjOqwpYVbsJIegv5Ims2GZBo7mCbeD/+CQBnjFv8xh3uBY8A/nRHR7
p+TFH+hp8rgv1TSpuzOd+uj2jl2x360YAUxJFTIDWIRrzYB6QJEqIogbK45154Zr
IkMjED8iwzjBwpbft16iB9hycG21MTnOKrcQ0mY9jUQVHXyx8A8PkrvUsytbZj5l
gC3rgTwF7MQLmLrqhAnt
=Y0fz
-----END PGP SIGNATURE-----

--MrRUTeZlqqNo1jQ9--
