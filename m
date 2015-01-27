Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbbA0Vh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:37:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbbA0Vh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:37:56 -0500
Date: Tue, 27 Jan 2015 13:37:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, arnd@arndb.de,
        linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/7] lib: Add huge I/O map capability interfaces
Message-Id: <20150127133755.85fd18b4483d7554c083f99b@linux-foundation.org>
In-Reply-To: <1422320515.2493.53.camel@misato.fc.hp.com>
References: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
	<1422314009-31667-3-git-send-email-toshi.kani@hp.com>
	<20150126155456.a40df49e42b1b7f8077421f4@linux-foundation.org>
	<1422320515.2493.53.camel@misato.fc.hp.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015 18:01:55 -0700 Toshi Kani <toshi.kani@hp.com> wrote:

> > >  static int ioremap_pte_range(pmd_t *pmd, unsigned long addr,
> > >  		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
> > >  {
> > > @@ -74,6 +112,12 @@ int ioremap_page_range(unsigned long addr,
> > >  	unsigned long start;
> > >  	unsigned long next;
> > >  	int err;
> > > +	static int ioremap_huge_init_done;
> > > +
> > > +	if (!ioremap_huge_init_done) {
> > > +		ioremap_huge_init_done = 1;
> > > +		ioremap_huge_init();
> > > +	}
> > 
> > Looks hacky.  Why can't we just get the startup ordering correct?  It
> > at least needs a comment which fully explains the situation.
> 
> How about calling it from mm_init() after vmalloc_init()?  
> 
> void __init mm_init(void)
> 		:
>         percpu_init_late();
>         pgtable_init();
>         vmalloc_init();
> +       ioremap_huge_init();
>  }

Sure, that would be better, assuming it can be made to work.  Don't
forget to mark ioremap_huge_init() as __init.

