Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaAPSgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:36:55 -0500
Received: from www.sr71.net ([198.145.64.142]:43227 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbaAPSgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:36:52 -0500
Message-ID: <52D82668.1060400@sr71.net>
Date: Thu, 16 Jan 2014 10:35:20 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, penberg@kernel.org, cl@linux-foundation.org
Subject: Re: [RFC][PATCH 4/9] mm: slabs: reset page at free
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180054.20A1B660@viggo.jf.intel.com> <alpine.DEB.2.02.1401141847230.32645@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401141847230.32645@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 06:48 PM, David Rientjes wrote:
>> > +/*
>> > + * Custom allocators (like the slabs) use 'struct page' fields
>> > + * for all kinds of things.  This resets the page's state so that
>> > + * the buddy allocator will be happy with it.
>> > + */
>> > +static inline void allocator_reset_page(struct page *page)
> This is ambiguous as to what "allocator" you're referring to unless we 
> look at the comment.  I think it would be better to name it 
> slab_reset_page() or something similar.

I stuck it in mm.h and deliberately didn't call it 'slab_something' so
that zsmalloc (in staging) could use this as well.  The "allocator" part
of the name was to indicate that any allocator could use it.

