Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab3ICD1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 23:27:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:2030 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab3ICD1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 23:27:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1011,1367996400"; 
   d="asc'?scan'208";a="397300275"
Date: Mon, 2 Sep 2013 23:15:19 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm/hwpoison: fix miss catch transparent huge page
Message-ID: <20130903031519.GA31018@gchen.bj.intel.com>
Mail-Followup-To: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <1378165006-19435-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1378165006-19435-2-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <1378165006-19435-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 03, 2013 at 07:36:44AM +0800, Wanpeng Li wrote:
> Date: Tue,  3 Sep 2013 07:36:44 +0800
> From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu
>  <fengguang.wu@intel.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
>  Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
>  linux-mm@kvack.org, linux-kernel@vger.kernel.org, Wanpeng Li
>  <liwanp@linux.vnet.ibm.com>
> Subject: [PATCH v2 2/4] mm/hwpoison: fix miss catch transparent huge page=
=20
> X-Mailer: git-send-email 1.7.5.4
>=20
> Changelog:
>  *v1 -> v2: reverse PageTransHuge(page) && !PageHuge(page) check=20
>=20
> PageTransHuge() can't guarantee the page is transparent huge page since i=
t=20
> return true for both transparent huge and hugetlbfs pages. This patch fix=
=20
> it by check the page is also !hugetlbfs page.
>=20
> Before patch:
>=20
> [  121.571128] Injecting memory failure at pfn 23a200
> [  121.571141] MCE 0x23a200: huge page recovery: Delayed
> [  140.355100] MCE: Memory failure is now running on 0x23a200
>=20
> After patch:
>=20
> [   94.290793] Injecting memory failure at pfn 23a000
> [   94.290800] MCE 0x23a000: huge page recovery: Delayed
> [  105.722303] MCE: Software-unpoisoned page 0x23a000
>=20
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  mm/memory-failure.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index e28ee77..b114570 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1349,7 +1349,7 @@ int unpoison_memory(unsigned long pfn)
>  	 * worked by memory_failure() and the page lock is not held yet.
>  	 * In such case, we yield to memory_failure() and make unpoison fail.
>  	 */
> -	if (PageTransHuge(page)) {
> +	if (!PageHuge(page) && PageTransHuge(page)) {
>  		pr_info("MCE: Memory failure is now running on %#lx\n", pfn);
>  			return 0;
>  	}

Not sure which git tree should be used to apply this patch series? I assume
this patch series follows this link: https://lkml.org/lkml/2013/8/26/76.

In unpoison_memory we already have
        if (PageHuge(page)) {
                ...
                return 0;
        }
so it looks like this patch is redundant.

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSJVRHAAoJEI01n1+kOSLH8moP/RFQ3ZOEI8aYMpMXkS/jamTw
KX6z5PRBF/hX1k9DJJLCgpdrQ38YlMkf2+/D50KyZC83z8Cc3wpfSxJHelTR5m5M
/szwq/VN2ZwIULV9dyEV/0g2n5mCCDnlgKCe6tJkslRlYrYXUq+q716mRflaNP+R
4VpVwjN2CxaO2ImHc1KrbXQq2/+XneyGL8ihRqEndkciuFo4d3b/2e/HnJADD+X6
OSyKKb31JoOq5IRqp1hI3zsj0ANLxt8FmJ/5hwxVOAXS+/gfWHdrBkmSj5q7cfX4
v04JeviNyWICsycVpLK5zHHZeiC48G1TSkv6R+w13/6dVcmmaD2CRBbf1JET4hdV
zrYeWtHfkQ7w9U1uabi//w7Re0Q/kyEX78O6Obq8Pez8kBQMUw5Mo54ppdnfKdKF
ld8g4Ay6TrsZy4MFWKDqwZLp+N5AveQUV9ch9g21vbN9GhtleZD5QOewT9yFqQD+
tzQyM3ed9x9ORJd6N0Q4YzTlFjUudxYPyRD4m9rkmo10B5jTDCweEvY/m0SXbgq4
GYpcW6Mzf83GAauJwsNnc95lamqFpQqYhOk1sCl4hLm+VCi2OcahAaau2KxT40O0
8HbKz2N7qY0ehVB0D3b6hkseQ2y2D/qq11zBOC301sd2RVK+P+we+8VPoD5Px40g
bP9lGntS0KLJG6Zu9fTp
=lHm5
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
