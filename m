Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaGBKTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:19:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58782 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaGBKTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:19:03 -0400
Date: Wed, 2 Jul 2014 12:18:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH V4 05/16] perf, core: pmu specific data for perf task
 context
Message-ID: <20140702101852.GX6758@twins.programming.kicks-ass.net>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
 <1404118253-19532-6-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9cIZjEJojpWZsxxj"
Content-Disposition: inline
In-Reply-To: <1404118253-19532-6-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9cIZjEJojpWZsxxj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2014 at 04:50:42PM +0800, Yan, Zheng wrote:

> @@ -3068,6 +3077,14 @@ alloc_perf_context(struct pmu *pmu, struct task_st=
ruct *task)
>  	if (!ctx)
>  		return NULL;
> =20
> +	if (task && pmu->task_ctx_size > 0) {
> +		ctx->task_ctx_data =3D kzalloc(pmu->task_ctx_size, GFP_KERNEL);
> +		if (!ctx->task_ctx_data) {
> +			kfree(ctx);
> +			return NULL;
> +		}
> +	}

Can we delay this allocation until such time as that its actually
needed? Otherwise we're wasting all this memory..

--9cIZjEJojpWZsxxj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTs9yMAAoJEHZH4aRLwOS6fNIP/jJh6pWda/oJAe2TJVmjcxE1
4mfv7/6n8GidDSeKo2Kv5NS0JDU2k/IrbFCtdckOMwEbjbZaFwiCdEv1ndwdtv60
k5SJFTX1w1GzM3pod8q5Og8XBQ/5ykyOzUV6bP51xOMZvOTvymI3eFcES5baEcn0
rt+ykNq/HksjPqpIMrShwVBdWtYANQIodEZTs4EStlH3eMwuYHp08PI1y10FtLYQ
iLamL2VCZoYYJjUdjc7GpWzSvXphHtXqZMrs6iGNwdkjGfriYbEA218aLe4JtZE4
MXEGzWN90CiJFPZrk1l3oxczArIRlFD8Nsewvfjn8MwTNXvlly1KBEoerQC9ZxHh
Ixf6cjk1xYQHyuFg1HvYOncR7IfuD1EoRm4/eKYp077QYsNGSZbubSaTBuVaaMVi
7EklFeG1vUDYy6L7AMWYobmk1MWJFFyCIVHV0lk8Tb55mBH9WaLi40TUEaTeuHel
c4t8bbworkWUntxR4t05GBSohz7NKyMsbZszAgmcmzOY9QW/DQSy1n6Zxc8O+7EM
8Rwaf6GVCT+XShRCAzac7rOV5BqnezoUzkw3Y5ReXfpir452IeSFPzMMqhEW6A1a
CZkrGfqtZE0r+1N5t05DP3h3+1emXOSnXwEDPRjwKmvKraLqrnU49WLxQxkx7aut
PHLSXHyvQax/c7RdEhz+
=qzew
-----END PGP SIGNATURE-----

--9cIZjEJojpWZsxxj--
