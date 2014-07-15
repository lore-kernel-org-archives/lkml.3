Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaGONgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:36:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33538 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaGONgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:36:42 -0400
Date: Tue, 15 Jul 2014 15:36:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose
 number of tasks running on cpu
Message-ID: <20140715133627.GS3588@twins.programming.kicks-ass.net>
References: <cover.1405074379.git.tim.c.chen@linux.intel.com>
 <1405110784.2970.655.camel@schen9-DESK>
 <20140714101611.GS9918@twins.programming.kicks-ass.net>
 <1405354214.2970.663.camel@schen9-DESK>
 <20140714161432.GC9918@twins.programming.kicks-ass.net>
 <1405357534.2970.701.camel@schen9-DESK>
 <20140714181738.GI9918@twins.programming.kicks-ass.net>
 <1405364908.2970.729.camel@schen9-DESK>
 <20140714191504.GO9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GFHULmA0mO3kKGOo"
Content-Disposition: inline
In-Reply-To: <20140714191504.GO9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GFHULmA0mO3kKGOo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 14, 2014 at 09:15:04PM +0200, Peter Zijlstra wrote:
> I still loathe all the async work, because it makes a mockery of
> accounting etc.. but that's a story for another day I suppose :-(

So, just to expand on this, we're already getting 'bug' reports because
worker threads are not cgroup aware. If work gets generated inside some
cgroup, the worker doesn't care and runs the worker thread wherever
(typically the root cgroup).

This means that the 'work' escapes the cgroup confines and creates
resource inversion etc. The same is of course true for nice and RT
priorities.

TJ, are you aware of this and/or given it any throught?

--GFHULmA0mO3kKGOo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxS5bAAoJEHZH4aRLwOS6RQAQAJMKhbWMWaeaKsQG5RbOSn4g
rQ0UJ1jpqCioLu6D6lIFtPEK9b3Dl6iFGkJBXv32u1dpAppGmqQNrc5UN/6Rds0G
fXC0lJXkxxDfNTNQRW/H27KIMuSaO092/QWToLfhYY1c+B4L2JuzFe9AO81s2OyY
OVoycnDw/SGCaKVD/B+kCYpK13pQiWPu7AUVxIzGhKHIiatvqkCZcmFRaySCF64r
DstBzmXsVVp+5Q+ffVAgbDBt7QHrlPjtHCNwVRJqhfKZh17E3St9kiOnR6HPBilI
faC1ynOoJ8JEugnhiqjKy2ayS1o/lMf06f3ewI0FaxorA4SaN+g1FadEUlgd6iVr
EJN8XGCNcfGGkafQhi3wFtJrxQjyBiA7s6iL7gnq0Y2yOVTPWlyacyTQ7V7AdThq
paJlkDEK2+Xm6UT+6GMSEB27n0wx71aXzNxljiCGVurXkVbQVd8Dx0nDCv+pcDc3
RNI2Z7T7idAO3YqohyGRz1eK/DswoxLASYqPx9LKje6iRg1zx6GW6Diuo+3DH0oL
qB7QedJmX3i6f+UdQ8LxLF0W1TriXhxeHm1rmtG04QcAoV267cArCxWVnNJEb+jv
iPCbQNUFCO0f87qsmnIjIe2aV+3HJjIH9sLJ1FHIUFIyUrxDOcZ0U78qY6ksICz6
3ZBm6Tlcme+7bBQ6+iMU
=Q0Zt
-----END PGP SIGNATURE-----

--GFHULmA0mO3kKGOo--
