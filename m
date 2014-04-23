Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaDWWSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:18:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaDWWSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:18:22 -0400
Date: Wed, 23 Apr 2014 15:18:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Luiz Capitulino <lcapitulino@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org,
        nacc@linux.vnet.ibm.com, Richard Weinberger <richard@nod.at>
Subject: Re: mmotm 2014-04-22-15-20 uploaded (uml 32- and 64-bit defconfigs)
Message-Id: <20140423151819.d752391e323a850ca0aded57@linux-foundation.org>
In-Reply-To: <20140424081019.596b5d23c624f5721ba0480a@canb.auug.org.au>
References: <20140422222121.2FAB45A431E@corp2gmr1-2.hot.corp.google.com>
	<5357F405.20205@infradead.org>
	<20140423134131.778f0d0a@redhat.com>
	<5357FCEB.2060507@infradead.org>
	<20140423141600.4a303d95@redhat.com>
	<20140423112442.5a5c8f23d580a65575e0c5fc@linux-foundation.org>
	<20140424081019.596b5d23c624f5721ba0480a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014 08:10:19 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

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

Stephen who?

Oh, that guy who sends stuff first then comes last when others use LIFO :)
