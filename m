Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaEHMlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:41:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50474 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaEHMla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:41:30 -0400
Date: Thu, 8 May 2014 14:41:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
Message-ID: <20140508124121.GU11096@twins.programming.kicks-ass.net>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com>
 <20140507152640.GR30445@twins.programming.kicks-ass.net>
 <87wqdwzbxy.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wbs6g7essDTrqL3S"
Content-Disposition: inline
In-Reply-To: <87wqdwzbxy.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wbs6g7essDTrqL3S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 03:34:17PM +0300, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
>=20
> > So the aux_head/tail values should also be in the file space and not
> > start at 0 again, similar for the offsets in the AUX record.
>=20
> Thinking some more about it: if we keep aux_{offset,size} in userpg,
> then it would make sense to have aux_{head,tail} run from 0 to infinity
> similar to data_{head,tail}, especially considering that neither data_*
> nor aux_* pointers are file offsets anyway.

Yeah, this might make it easier. So then the rule is *_offset +
*_{head,tail} is the actual file offset into the buffer.

--wbs6g7essDTrqL3S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTa3txAAoJEHZH4aRLwOS6BhIQAIGSJNkr6YT4ejyLpLUYFPKC
iXp10WJOFZpaEJmf8oe4/Q+Tf0pHZ+nxX2QZXOGTYWtwuhwyJI66jnTM2awfGTdZ
YSQ2/38B9UuF71SCvy73vBPVcR2ai/00zg9w1VoDzhDpuUuKM666u6LLRE8TsBNW
V8zwB7InsYIV6fK33hzJOqm2b19+vIJwZBrBuP1W6Tj+7thp8jj+FD+0jHr2njYf
leYTtLijKkSIyWr5x6ntOouAsOh3/rnK66ntSZDVzOBilhIalRQUimsuGRLWSSWt
SI7Up+rCAPwI+1/TC8ajbfFMT1Bb2s+voZaCktw7qiDZY+4aEwcLCg0extK00OGL
sVbIjFVMSrVJXVg5RB8MUEGskX7tU/V/Hc5vecp4/DhRSDqQ3B3cq4TReJdQ5ZtZ
owfr9dneyUrHLYoZ8zVGPb2lFdVVqPVQHpm0tZnOg7DNdaYaME/7/K90dKyorbAo
BpWTskBcNKl3r2n8dOZWO60NbBwvJzmC7Ko9GtU5uawGRSahaOiO/v/FNoVdXeNJ
mJqKy+g3mcij8ZhI554o9orAF8k/3RBjejJAC8n+Z8BdgibhgYF9ibQRfq1BiEYp
GXdsZc9ukENzqkPjaK1x3vBa2VViufWUR5ERPnwkHtilLLBH5rcXnrWFwg5XTnKr
53CxAjp0ruI8ithiWBkY
=RDCy
-----END PGP SIGNATURE-----

--wbs6g7essDTrqL3S--
