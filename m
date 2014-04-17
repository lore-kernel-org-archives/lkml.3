Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaDQTJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:09:53 -0400
Received: from smtp104.biz.mail.gq1.yahoo.com ([98.137.12.179]:34767 "HELO
	smtp104.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751019AbaDQTJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:09:45 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: V216CLAVM1lFhQ6WFhnxDWUsG4X.XNAOkLcElD1rT7fZkPS
 mpflb4lDDuJ_JTnKlvodpGECsIig6NB1_RQwaZmqPnOFY.nAKEhhsG_5v20r
 qWLcH0fl2L3lOijd4WmYtYwZtBEddkPXklWrxR8C.bhkoeH0W3Sx1xSox3GS
 d9bKUr2Zwn70udmJwVuUB9ZhciYShUB4oMWX7U.wAeo6lDLF1HPDWT0QfFqt
 8IcR1NtraYlYZDi7rukjx1Mwy5C4cOCtB_U5oXPPiDyWs2_m8oq.b522jg3_
 vJIJ3K7AKPeDur.TJNJ3p3lxjuiapLv17bv9AiPU_MEPzSb8Cumqi4DTY1v6
 6W7UrEt9CyBEyloo09V021TKCdo1XDqyLwLgKZhC3q0FFqIJRp9qHUtUFd8E
 .qPcEItPW5MZCKOid1Pse2wfWBGLN2ptIZ2LSRLcxGPXkjHrxm9K4S8h5TXn
 P6wq9enVfqGQEnrQjyZuF2UEzc4_iRu_lN2IGRAYJd4tlTqi2tFrldi1lLkj
 lT5zzMJjinKKHW6tMZEQ-
X-Yahoo-SMTP: qGLgp.mswBDSnFfWmYVMF5Rmg6NJ
X-Rocket-Received: from fdwdc.com (sfking@66.235.32.29 with plain [208.71.40.208])
        by smtp104.biz.mail.gq1.yahoo.com with SMTP; 17 Apr 2014 12:09:44 -0700 PDT
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [uClinux-dev] v3.15-rc1 slab allocator broken on m68knommu (coldfire)
Date: Thu, 17 Apr 2014 12:09:43 -0700
User-Agent: KMail/1.9.9
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201404141745.44279.sfking@fdwdc.com> <201404161044.11416.sfking@fdwdc.com> <20140417014911.GA3284@js1304-P5Q-DELUXE>
In-Reply-To: <20140417014911.GA3284@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201404171209.43848.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2014 6:49:11 pm Joonsoo Kim wrote:
> On Wed, Apr 16, 2014 at 10:44:11AM -0700, Steven King wrote:
> > On Wednesday 16 April 2014 9:06:57 am Geert Uytterhoeven wrote:
> > > Hi Steven,
> > >
> > > On Wed, Apr 16, 2014 at 5:47 PM, Steven King <sfking@fdwdc.com> wrote:
> > > > --- a/mm/slab.c
> > > > +++ b/mm/slab.c
> > > > @@ -2572,13 +2572,13 @@ static void *alloc_slabmgmt(struct kmem_cache
> > > > *cachep, return freelist;
> > > >  }
> > > >
> > > > -static inline freelist_idx_t get_free_obj(struct page *page,
> > > > unsigned char idx) +static inline freelist_idx_t get_free_obj(struct
> > > > page *page, unsigned int idx) {
> > > >         return ((freelist_idx_t *)page->freelist)[idx];
> > > >  }
> > > >
> > > >  static inline void set_free_obj(struct page *page,
> > > > -                                       unsigned char idx,
> > > > freelist_idx_t val) +                                       unsigned
> > > > int idx, freelist_idx_t val) {
> > > >         ((freelist_idx_t *)(page->freelist))[idx] = val;
> > > >  }
> > > >
> > > >
> > > > then v3.15-rc1 will boot using the slab allocator.
> > >
> > > Is "idx" ever larger than 255?
> > >
> > > Gr{oetje,eeting}s,
> >
> > Yes.  If I stick
> >
> >         if (idx > 255)
> >                 pr_info("%s %d\n", __func__, idx);
> >
> > in get_free_obj and set_free_obj and see values for idx up into the 400s.
>
> Hello,
>
> Yes, it's my mistake. idx can be larger than 255 if freelist_idx_t is
> unsigned short. So unsigned char idx isn't appropriate here. Your
> system's PAGE_SIZE may be 2^13, so freelist_idx_t would be unsigned short
> and idx will be larger than 255.
>
> Your fix looks good to me, so could you send it quickly to Pekka with
> some description? If you don't have enough time to do it, I can handle it.
>
> Really thanks for notifying this issue.
>
> Thanks.

Why don't you go ahead and do it, you know whats going better than I do.
