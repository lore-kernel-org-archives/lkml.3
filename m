Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaE1RJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:09:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaE1RJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:09:23 -0400
Date: Wed, 28 May 2014 19:09:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
Message-ID: <20140528170913.GU30445@twins.programming.kicks-ass.net>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
 <20140528081053.GP11096@twins.programming.kicks-ass.net>
 <20140528145831.GH29957@tassilo.jf.intel.com>
 <CABPqkBQZWC33egtrpGLUHKizzrFRAz68-AsP-GWxB=Q--bjf8g@mail.gmail.com>
 <20140528165144.GK29957@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xCod2j9FiOMpaQ8M"
Content-Disposition: inline
In-Reply-To: <20140528165144.GK29957@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xCod2j9FiOMpaQ8M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 09:51:44AM -0700, Andi Kleen wrote:
> > The only part I don't quite follow here is this:
> >                       if (__test_and_set_bit(bit, (unsigned long *)&sta=
tus))
> >                                 continue;
> >=20
> > Which seems to indicate the code is making sure each counter is
> > processed only once. But it can only be processed once, if you have
> > only one record. And if you have multiple, you want to be able to
> > handle the same counter multiple times, at least once perf PEBS
> > record. So I am a bit confused about this test.
>=20
> Each PEBS record is only for a single counter overflow. So it
> always should only be a single perf event.

OK, so what Stephane said, that two counter's having their assist on the
exact same cycle results in but a single record is false? That would be
good.

--xCod2j9FiOMpaQ8M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThhg5AAoJEHZH4aRLwOS6dvoP/1Wk3dEW9oUTnS4ckohnA5ih
Iwx8+tZwUPr43x/OTsl4YWe6fKTHltYCWcWjIOUnHmVXruRg5oF1ZPwivpzPJr8T
JVVQ3/XqqbBWiV6eV0NbRmRLAix5BMCTJT3w9+vjKdAq4y1zsUxQl84RLS5ztThK
a0f5Zg1aFSclJYg3YVUo9P+6FGhCVednd3SNiSD1l5FiqjNlo+GnfaDQOv/8tfAu
rBfy/IEOUizijx90hojlbA4knOYCNef9ceNrTqbPJ2XZ5Wp9DDDN16lYZFek4WxA
cuyQ9Ua8HiZVHldOLZZNaZlCCh5OYeagemihtCGDPM0Us95QLQ04Qrdqv0E/mdX7
MXBOt/c9ZG5Uf9tFXyub0FCnH3iQiBbJt6DCg8LW12MazTE3woH70f1ZUh+3dBFD
GRlx69+ArkGDgUiKV4Tq3QFEyOFJHm/lBQLcDp0C57ezZSADFAXiSEgUw6cA4Szr
KcPIYRkfWWDQ763l1G0aRuUuRewXT/FaEFDN8nQlt8qYXBL5tgg16CjRirQI8kXi
tfbDKOP5l/58pUAVyVof0ITLgAob89668l7+bgWpJCifDzfwmBk2pSASdm1lpe6m
D12PKSdU7H+aKKscIBHc75008QkUqCJ/g8ySwe125QEx0TnnzT348gjIfbyG/TO2
ptSH8jDjM6d8yKt2DPBd
=IJ8y
-----END PGP SIGNATURE-----

--xCod2j9FiOMpaQ8M--
