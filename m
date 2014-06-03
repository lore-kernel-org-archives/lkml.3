Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbaFCMYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:24:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:41306 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaFCMYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:24:08 -0400
Date: Tue, 3 Jun 2014 14:24:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, arjan.van.de.ven@intel.com,
        len.brown@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        pjt@google.com, bsegall@google.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, rajeev.d.muralidhar@intel.com,
        vishwesh.m.rudramuni@intel.com, nicole.chalhoub@intel.com,
        ajaya.durg@intel.com, harinarayanan.seshadri@intel.com,
        jacob.jun.pan@linux.intel.com, fengguang.wu@intel.com
Subject: Re: [RFC PATCH 12/16 v3] Bias select wakee than waker in WAKE_AFFINE
Message-ID: <20140603122401.GL30445@twins.programming.kicks-ass.net>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
 <1401431772-14320-13-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lUGOeNWztp/TKlGK"
Content-Disposition: inline
In-Reply-To: <1401431772-14320-13-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lUGOeNWztp/TKlGK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2014 at 02:36:08PM +0800, Yuyang Du wrote:
> In WAKE_AFFINE, we do not simply select idle, but bias wakee than waker
> if the cc of the wakee and waker (in this order) is capable of handling
> the wakee task
>=20
> Signed-off-by: Yuyang Du <yuyang.du@intel.com>
> ---
>  kernel/sched/fair.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>=20
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 0c188df..d40ec9e 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4370,7 +4370,18 @@ static int select_idle_sibling(struct task_struct =
*p, int target)
>  	struct sched_group *sg;
>  	int i =3D task_cpu(p);
> =20
> -	if (idle_cpu(target))
> +	/*
> +	 * we do not select idle, if the cc of the wakee and
> +	 * waker (in this order) is capable of handling the wakee task
> +	 */
> +	if (sysctl_sched_cc_wakeup_threshold) {
> +		if (idle_cpu(i) || cpu_cc_capable(i))
> +			return i;
> +
> +		if (i !=3D target && (idle_cpu(target) || cpu_cc_capable(target)))
> +			return target;
> +	}
> +	else if (idle_cpu(target))
>  		return target;
> =20

So now you make a function called: select_idle_sibling() explicitly not
pick an idle cpu, and you don't think there's anything wrong with that?

--lUGOeNWztp/TKlGK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjb5hAAoJEHZH4aRLwOS6KKMP/2N05J50/zNv5isvZPeo3Dkg
QZ1716bNVDS5WZh/Pg2M2oL7+DXFdh9yE+CyiS0YZ/T8oIbQLBJJIGw/lrWPsnYm
wqElJ5oSKs6kHMBdQ5w3iNzkKe5d2kMiPEswfMxjLCnRLa6S96hzJZbGFrK7z22U
utqSW1dZpo0mD6vW5t1Zcu/iUFtlDisIFn7E4obl6SDDtpa6F/9clMv3tNayeWOW
GIPOngxDQWh2PxX+4qNbp6D6iV17iY88aE3mAkxRHERUf0FCMSFkBkruG7hPAbbn
mu8DbVuNSH4uMRf8et7JFmf08SKdOZbqADBucOFUzhpU7veM4drF4Kau1jl4NobS
Yy/gzjngt8Zd3hglb5YASetw2hMTK5fXzftZo/hm4VV3rHljrNDGK7DhDwx/zT8S
4wiqvHzN5X8LZbcYIcWJxOP2S2DPmrrv4ThHg6x/9E6glFWnvPQD5RSF3DHrXbSo
d3cw0E+5zNSIqhhn2jm8QUMhEYBYDVIqSnc0AQTqwlBfs8bqYfnfnrYC/7QvMyab
m13nxNGzanT7vkDCDr2Feuk0jWaGIiAdwaBfZuBTJcfrDFN6Dlus0E1eo13H9+x3
DBXxiCdpJGktahocDn0JRhHw3RKOzEZCl3zfNRmcgPSEorCKZXLPbkJtyLU8WrdN
2SD1sILfHYUhVYu8uPWz
=bFzb
-----END PGP SIGNATURE-----

--lUGOeNWztp/TKlGK--
