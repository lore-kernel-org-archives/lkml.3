Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab3H0ITY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:19:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:46592 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab3H0ITV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:19:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,966,1367996400"; 
   d="asc'?scan'208";a="386997072"
Date: Tue, 27 Aug 2013 04:07:05 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/hwpoison: fix return value of madvise_hwpoison
Message-ID: <20130827080704.GB23035@gchen.bj.intel.com>
Mail-Followup-To: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <1377571171-9958-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1377571171-9958-3-git-send-email-liwanp@linux.vnet.ibm.com>
 <1377574096-y8hxgzdw-mutt-n-horiguchi@ah.jp.nec.com>
 <521c1f3f.813d320a.6ba7.5a17SMTPIN_ADDED_BROKEN@mx.google.com>
 <1377574896-5k1diwl4-mutt-n-horiguchi@ah.jp.nec.com>
 <20130827073701.GA23035@gchen.bj.intel.com>
 <20130827080523.GA22375@hacker.(null)>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <20130827080523.GA22375@hacker.(null)>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2013 at 04:05:23PM +0800, Wanpeng Li wrote:
> Date: Tue, 27 Aug 2013 16:05:23 +0800
> From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> To: Chen Gong <gong.chen@linux.intel.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Andrew Morton
>  <akpm@linux-foundation.org>, Andi Kleen <andi@firstfloor.org>, Fengguang
>  Wu <fengguang.wu@intel.com>, Tony Luck <tony.luck@intel.com>,
>  linux-mm@kvack.org, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2 3/3] mm/hwpoison: fix return value of
>  madvise_hwpoison
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> Hi Chen,
> On Tue, Aug 27, 2013 at 03:37:01AM -0400, Chen Gong wrote:
> >On Mon, Aug 26, 2013 at 11:41:36PM -0400, Naoya Horiguchi wrote:
> >> Date: Mon, 26 Aug 2013 23:41:36 -0400
> >> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> >> To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen
> >>  <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>, Tony Lu=
ck
> >>  <tony.luck@intel.com>, gong.chen@linux.intel.com, linux-mm@kvack.org,
> >>  linux-kernel@vger.kernel.org
> >> Subject: Re: [PATCH v2 3/3] mm/hwpoison: fix return value of
> >>  madvise_hwpoison
> >> User-Agent: Mutt 1.5.21 (2010-09-15)
> >>=20
> >> On Tue, Aug 27, 2013 at 11:38:27AM +0800, Wanpeng Li wrote:
> >> > Hi Naoya,
> >> > On Mon, Aug 26, 2013 at 11:28:16PM -0400, Naoya Horiguchi wrote:
> >> > >On Tue, Aug 27, 2013 at 10:39:31AM +0800, Wanpeng Li wrote:
> >> > >> The return value outside for loop is always zero which means madv=
ise_hwpoison=20
> >> > >> return success, however, this is not truth for soft_offline_page =
w/ failure
> >> > >> return value.
> >> > >
> >> > >I don't understand what you want to do for what reason. Could you c=
larify
> >> > >those?
> >> >=20
> >> > int ret is defined in two place in madvise_hwpoison. One is out of f=
or
> >> > loop and its value is always zero(zero means success for madvise), t=
he=20
> >> > other one is in for loop. The soft_offline_page function maybe retur=
n=20
> >> > -EBUSY and break, however, the ret out of for loop is return which m=
eans=20
> >> > madvise_hwpoison success.=20
> >>=20
> >> Oh, I see. Thanks.
> >>=20
> >I don't think such change is a good idea. The original code is obviously
> >easy to confuse people. Why not removing redundant local variable?
> >
>=20
> I think the trick here is get_user_pages_fast will return the number of
> pages pinned. It is always 1 in madvise_hwpoison, the return value of
> memory_failure is ignored. Therefore we still need to reset ret to 0
> before return madvise_hwpoison.
>=20
> Regards,
> Wanpeng Li
>=20
It looks like the original author wrote in that way deliberately but
botching it. FWIW, I just think its harmness is more than good.

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSHF4oAAoJEI01n1+kOSLHZAkP+gLNWq5DcaaG1Gi82xp0b9xO
u0BkDux5P0cfyz0B8BIIET7njzx4Ip+GLAxsduuN7y4KvqFwitoxSGXZEvsg/sd1
j1GVT3J5mjc0gPld5y9DO4EN1TL7KQxI/iASbNZDBtQkAtzhGxX/DRcO5kiF77SL
QnufNdp7uK1G/Xp8uOeTlU/WWGFnOWLsGn2ShHuwDRLSZejUFqX2/giU1kfHfB6C
NtUcRF8eE3BX1cAiRrHlCEtwswB4F99zERYmRvErUxnK7+NCzagAdGOkup5i4GSY
YcTw4XLyjx65KRZuyev11BOm2mcTXiGIF3SQLyBo8v8JuXm3+3UVJ6vcRAwbMzCP
Fp62Y6/8Mh80tjYGP85TSST1a/JS3SHeCtLfVsX61EqSSr8qAe82qlhoh8wrfX+x
YFCGd+0ufa48P+SfSrlicl8DXou8ayXJHawXjPjC2xlho1W/29v6xl/NBdwq/u+D
sIF2A00s9BP8+Gs51zveNI4I7QMnWmxTImqhj6RRHkLIts6CVwSi4kIF7niOSwE1
1qFsEreAjDnCRm5j074bAfFz6XIIJ0re5FTdzkzdDnWWp/m6/VW/ZgibY2IBeLvH
j/9kzrXkebPbD2iazCTRd0KGkUflBKlpKyShU4Ahcbm9Q+WoMxFUB+6wXgGjB1cM
C7ijSB+WSEZhmEpyMXF4
=HLph
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
