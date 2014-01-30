Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaA3U6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 15:58:05 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:34307 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbaA3U6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 15:58:03 -0500
Date: Thu, 30 Jan 2014 12:58:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sasha Levin <sasha.levin@oracle.com>
cc: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jonathan Gonzalez <jgonzalez@linets.cl>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm, hugetlb: gimme back my page
In-Reply-To: <52EA57AC.3090700@oracle.com>
Message-ID: <alpine.DEB.2.02.1401301256540.15271@chino.kir.corp.google.com>
References: <1391063823.2931.3.camel@buesod1.americas.hpqcorp.net> <52EA57AC.3090700@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, Sasha Levin wrote:

> VM_BUG_ON_PAGE is just a VM_BUG_ON that does dump_page before the BUG().
> 
> The only reason to use VM_BUG_ON instead of VM_BUG_ON_PAGE is if the page
> you're working
> with doesn't make sense/isn't useful as debug output.
> 
> If doing a dump_page is causing issues somewhere then dump_pages should be
> fixed - instead
> of hiding the problem under the rug by not using it.
> 

It sounds like dump_page() isn't necessarily at fault itself but rather 
that using it is opening a race even wider that causes this failure to 
occur more often than it normally would.
