Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaDWXbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 19:31:37 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49050 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaDWXbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 19:31:34 -0400
Date: Wed, 23 Apr 2014 16:31:24 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: Re: mmotm 2014-04-22-15-20 uploaded (uml 32- and 64-bit defconfigs)
Message-ID: <20140423233124.GA3869@linux.vnet.ibm.com>
References: <20140422222121.2FAB45A431E@corp2gmr1-2.hot.corp.google.com>
 <5357F405.20205@infradead.org>
 <20140423134131.778f0d0a@redhat.com>
 <5357FCEB.2060507@infradead.org>
 <20140423141600.4a303d95@redhat.com>
 <20140423112442.5a5c8f23d580a65575e0c5fc@linux-foundation.org>
 <20140424081019.596b5d23c624f5721ba0480a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424081019.596b5d23c624f5721ba0480a@canb.auug.org.au>
X-Operating-System: Linux 3.13.0-24-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042323-9332-0000-0000-000000978FDB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.04.2014 [08:10:19 +1000], Stephen Rothwell wrote:
> Hi all,
> 
> On Wed, 23 Apr 2014 11:24:42 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > I'll try moving hugepages_supported() into the #ifdef
> > CONFIG_HUGETLB_PAGE section.
> > 
> > --- a/include/linux/hugetlb.h~hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix-fix
> > +++ a/include/linux/hugetlb.h
> > @@ -412,6 +412,16 @@ static inline spinlock_t *huge_pte_lockp
> >  	return &mm->page_table_lock;
> >  }
> >  
> > +static inline bool hugepages_supported(void)
> > +{
> > +	/*
> > +	 * Some platform decide whether they support huge pages at boot
> > +	 * time. On these, such as powerpc, HPAGE_SHIFT is set to 0 when
> > +	 * there is no such support
> > +	 */
> > +	return HPAGE_SHIFT != 0;
> > +}
> > +
> >  #else	/* CONFIG_HUGETLB_PAGE */
> >  struct hstate {};
> >  #define alloc_huge_page_node(h, nid) NULL
> > @@ -460,14 +470,4 @@ static inline spinlock_t *huge_pte_lock(
> >  	return ptl;
> >  }
> >  
> > -static inline bool hugepages_supported(void)
> > -{
> > -	/*
> > -	 * Some platform decide whether they support huge pages at boot
> > -	 * time. On these, such as powerpc, HPAGE_SHIFT is set to 0 when
> > -	 * there is no such support
> > -	 */
> > -	return HPAGE_SHIFT != 0;
> > -}
> > -
> >  #endif /* _LINUX_HUGETLB_H */
> 
> Clearly, noone reads my emails :-(
> 
> This is exactly what I reported and the fix I applied to yesterday's
> linux-next ...

Actually, I think (based upon the context) that your fix is slightly
different. Your fix puts hugepages_supported() under CONFIG_HUGETLBFS.
Andrew's puts it under CONFIG_HUGETLB_PAGE. I think they are effectively
tied together as options go, but it semantically makes more sense with
CONFIG_HUGETLB_PAGE.

Thanks,
Nish

