Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbaDPRoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:44:16 -0400
Received: from smtp103.biz.mail.gq1.yahoo.com ([98.137.12.178]:38119 "HELO
	smtp103.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750928AbaDPRoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:44:13 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: HciB_6EVM1njIajwuKxDsv9mNA6_0CnbQ.b8_BbYUdADVzy
 fAZetwyONufMrzSWcHpBNIR_7Mjn6lAioEnvccxPeI8k9gcsqLf0KTSyxd9y
 cTbn6WskLH8jqO8Nxpbc0e5n..nvH1e0UyythzcYwFlSmCbnBbdzzCVTKx6O
 BIqGtrxTM4v2VtbC9_RNEX8yYRN.VWOdZoFXdx5TentX.QmeQXFaiQFt.MGU
 YloQvfWjDMZZCwWEm9FMOsgU26n9zOWsHajY_fF0Nx47a9JUN2Tmh807RYKS
 2RozyiXJzWFQ8yle0C0UUWntpqFeZ_qixihDhm5cdDO2LMuThEn4SiXXIxih
 c1W.JZhgW4rjn4lYjNOcygNsU_9LImxFrk7.zGRUty78lRNQEjzE2QdBNltp
 qIXPG3FRvdy9ZcFoylixLUpAGKrony_iD98On.A7EpFKfdJrtJ6sp0t0xOjb
 TccU8ngWpKGnuTjScEdc_9ehhNU9mzgEl3KrqRptuDycnybfDHcrzFTuLP4F
 Tvq9SSDhX5w938T1CYg--
X-Yahoo-SMTP: qGLgp.mswBDSnFfWmYVMF5Rmg6NJ
X-Rocket-Received: from fdwdc.com (sfking@66.235.32.29 with plain [208.71.40.208])
        by smtp103.biz.mail.gq1.yahoo.com with SMTP; 16 Apr 2014 10:44:12 -0700 PDT
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [uClinux-dev] v3.15-rc1 slab allocator broken on m68knommu (coldfire)
Date: Wed, 16 Apr 2014 10:44:11 -0700
User-Agent: KMail/1.9.9
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        uClinux development list <uclinux-dev@uclinux.org>
References: <201404141745.44279.sfking@fdwdc.com> <201404160847.27300.sfking@fdwdc.com> <CAMuHMdV2zSWaDbHNv3QQeEgu26PQX9TWn7cHA=4U0YOK0bbExg@mail.gmail.com>
In-Reply-To: <CAMuHMdV2zSWaDbHNv3QQeEgu26PQX9TWn7cHA=4U0YOK0bbExg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201404161044.11416.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2014 9:06:57 am Geert Uytterhoeven wrote:
> Hi Steven,
>
> On Wed, Apr 16, 2014 at 5:47 PM, Steven King <sfking@fdwdc.com> wrote:
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> > @@ -2572,13 +2572,13 @@ static void *alloc_slabmgmt(struct kmem_cache
> > *cachep, return freelist;
> >  }
> >
> > -static inline freelist_idx_t get_free_obj(struct page *page, unsigned
> > char idx) +static inline freelist_idx_t get_free_obj(struct page *page,
> > unsigned int idx) {
> >         return ((freelist_idx_t *)page->freelist)[idx];
> >  }
> >
> >  static inline void set_free_obj(struct page *page,
> > -                                       unsigned char idx, freelist_idx_t
> > val) +                                       unsigned int idx,
> > freelist_idx_t val) {
> >         ((freelist_idx_t *)(page->freelist))[idx] = val;
> >  }
> >
> >
> > then v3.15-rc1 will boot using the slab allocator.
>
> Is "idx" ever larger than 255?
>
> Gr{oetje,eeting}s,

Yes.  If I stick

        if (idx > 255)
                pr_info("%s %d\n", __func__, idx);

in get_free_obj and set_free_obj and see values for idx up into the 400s.
