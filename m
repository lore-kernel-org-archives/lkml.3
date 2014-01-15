Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaAOCpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:45:45 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:56171 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaAOCpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:45:42 -0500
Date: Tue, 14 Jan 2014 18:45:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@sr71.net>
cc: Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        penberg@kernel.org
Subject: Re: [RFC][PATCH 3/9] mm: page->pfmemalloc only used by slab/skb
In-Reply-To: <52D5B762.3090209@sr71.net>
Message-ID: <alpine.DEB.2.02.1401141842220.32645@chino.kir.corp.google.com>
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180051.0181E467@viggo.jf.intel.com> <alpine.DEB.2.10.1401141348130.19618@nuc> <52D5B762.3090209@sr71.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014, Dave Hansen wrote:

> >> page->pfmemalloc does not deserve a spot in 'struct page'.  It is
> >> only used transiently _just_ after a page leaves the buddy
> >> allocator.
> > 
> > Why would we need to do this if we are removing the cmpxchg_double?
> 
> Why do we need the patch?
> 
> 'struct page' is a mess.  It's really hard to follow, and the space in
> the definition is a limited resource.  We should not waste that space on
> such a transient and unimportant value as pfmemalloc.
> 

I don't have any strong opinions on whether this patch is merged or not, 
but I'm not sure it's cleaner to do it with an accessor function that 
overloads page->index when its placement within the union inside 
struct page makes that obvious, nor is it good that the patch adds more 
code than it removes solely because it introduces those accessor 
functions.
