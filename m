Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761AbaAaRut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:50:49 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42904 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbaAaRus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:50:48 -0500
Message-ID: <1391190643.3475.7.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] mm, hugetlb: gimme back my page
From: Davidlohr Bueso <davidlohr@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jonathan Gonzalez <jgonzalez@linets.cl>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Fri, 31 Jan 2014 09:50:43 -0800
In-Reply-To: <alpine.DEB.2.02.1401301256540.15271@chino.kir.corp.google.com>
References: <1391063823.2931.3.camel@buesod1.americas.hpqcorp.net>
	 <52EA57AC.3090700@oracle.com>
	 <alpine.DEB.2.02.1401301256540.15271@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-30 at 12:58 -0800, David Rientjes wrote:
> On Thu, 30 Jan 2014, Sasha Levin wrote:
> 
> > VM_BUG_ON_PAGE is just a VM_BUG_ON that does dump_page before the BUG().
> > 
> > The only reason to use VM_BUG_ON instead of VM_BUG_ON_PAGE is if the page
> > you're working
> > with doesn't make sense/isn't useful as debug output.
> > 
> > If doing a dump_page is causing issues somewhere then dump_pages should be
> > fixed - instead
> > of hiding the problem under the rug by not using it.
> > 
> 
> It sounds like dump_page() isn't necessarily at fault itself but rather 
> that using it is opening a race even wider that causes this failure to 
> occur more often than it normally would.

It turns out this issue goes way back, you just have try hard enough to
trigger it under very specific conditions.

