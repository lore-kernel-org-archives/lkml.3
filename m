Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaE1JxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:53:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59659 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaE1JxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:53:17 -0400
Date: Wed, 28 May 2014 11:53:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf: Differentiate exec() and non-exec() comm events
Message-ID: <20140528095308.GS11096@twins.programming.kicks-ass.net>
References: <1401266704-22572-1-git-send-email-adrian.hunter@intel.com>
 <20140528085538.GR11096@twins.programming.kicks-ass.net>
 <5385A7A9.80702@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aa1lHgJENwUhkhu9"
Content-Disposition: inline
In-Reply-To: <5385A7A9.80702@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aa1lHgJENwUhkhu9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 12:08:57PM +0300, Adrian Hunter wrote:
> On 05/28/2014 11:55 AM, Peter Zijlstra wrote:
> > On Wed, May 28, 2014 at 11:45:04AM +0300, Adrian Hunter wrote:
> >> perf tools like 'perf report' can aggregate samples by comm
> >> strings, which generally works.  However, there are other
> >> potential use-cases.  For example, to pair up 'calls'
> >> with 'returns' accurately (from branch events like Intel BTS)
> >> it is necessary to identify whether the process has exec'd.
> >> Although a comm event is generated when an 'exec' happens
> >> it is also generated whenever the comm string is changed
> >> on a whim (e.g. by prctl PR_SET_NAME).  This patch adds a
> >> flag to the comm event to differentiate one case from the
> >> other.
> >>
> >> In order to determine whether the kernel supports the new
> >> flag, a selection bit named 'exec' is added to struct
> >> perf_event_attr.  The bit does nothing but will cause
> >> perf_event_open() to fail if the bit is set on kernels
> >> that do not have it defined.
> >>
> >=20
> >> --- a/include/uapi/linux/perf_event.h
> >> +++ b/include/uapi/linux/perf_event.h
> >> @@ -302,8 +302,8 @@ struct perf_event_attr {
> >>  				exclude_callchain_kernel : 1, /* exclude kernel callchains */
> >>  				exclude_callchain_user   : 1, /* exclude user callchains */
> >>  				mmap2          :  1, /* include mmap with inode data     */
> >> -
> >> -				__reserved_1   : 40;
> >> +				exec           :  1, /* flag comm events that are due to an exec =
*/
> >> +				__reserved_1   : 39;
> >> =20
> >=20
> > Yah.. that's just sad :-(
> >=20
> > the only capabilities mask we have is in the mmap() page, so without
> > mmap()ing we have no way to test that.
> >=20
> > Would it make sense to call it comm_exec?
>=20
> Yes, that is better.  Do you want me to resend the patch?

Nah, I'll frob it. Thanks!

--aa1lHgJENwUhkhu9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThbIEAAoJEHZH4aRLwOS6aFIQAKBSFSFPcxy/fxmCU13Ggwyu
RnEWkYWalWWCfOMRZMdT7TEQhS4JRIb5cHkgPhiZ/2Nf/cEx1QheSU8M40ovZOkB
dRRtBkCooZXDRMWaeQvh7lVPnsVgYkVulgjQSS70GuD8JDrb2BIxj+IatjYgut3c
E9wfrBJhLbCgjGN03dNJCs2EAAzwpNkXasb0X9P+RJG4tTVNjxoDhE+7eiQpOU5F
mPiuKynWCNwWZ3V6ukF6ILO9sVK5E8Ma+VAgUfLj9mmOyXEx9H/FzzKOsyPlrHmn
bVOzTT156kJDi0tOdP6yPUnsU1hxY9n/ggA/UB3ncBr9DKpF2N/NgazLzIHXZ8qy
QCDfuZKqmJgTPp7YrkUIibbPUC7PHroQY1QSoYQNBOZ8REBolv7it2ZBg+DZ5lhX
AZeWtJ9L8kAPucrXu/d+sV+kO0D4HlHE4rl3tEn6XXCpLUutmsUDfwX4OFm+9lTg
ZhliUHYMyznBhueK8mmmy0ri2hx/0Ifo85CnTzskCwlpJD0bu5kFlhFSeEtqafz0
xfQO1xHi8GXQ9SrJNFlpZcxRvBdh6fbPP8W/mTpaU1ofeoQYCRfJPSgS0ctmHJ+J
OgDd16PGmDTSsxFBXMfVHBwRuf6GrLKqGkR0TrOI3ePjC4pGpQ5/Nn7k60f+Es1F
H72Yd5N6kHmhm0hIEse2
=5IZh
-----END PGP SIGNATURE-----

--aa1lHgJENwUhkhu9--
