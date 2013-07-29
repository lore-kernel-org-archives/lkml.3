Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab3G2OOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:14:22 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:63363 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3G2OOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:14:20 -0400
Date: Mon, 29 Jul 2013 18:14:17 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] mm: Save soft-dirty bits on file pages
Message-ID: <20130729141417.GM2524@moon>
References: <20130726201807.GJ8661@moon>
 <51F67777.6060609@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F67777.6060609@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 06:08:55PM +0400, Pavel Emelyanov wrote:
> >  
> > -	if (!pte_none(*pte))
> > +	ptfile = pgoff_to_pte(pgoff);
> > +
> > +	if (!pte_none(*pte)) {
> > +#ifdef CONFIG_MEM_SOFT_DIRTY
> > +		if (pte_present(*pte) &&
> > +		    pte_soft_dirty(*pte))
> 
> I think there's no need in wrapping every such if () inside #ifdef CONFIG_...,
> since the pte_soft_dirty() routine itself would be 0 for non-soft-dirty case
> and compiler would optimize this code out.

If only I'm not missing something obvious, this code compiles not only on x86,
CONFIG_MEM_SOFT_DIRTY depends on x86 (otherwise I'll have to implement
pte_soft_dirty for all archs).
