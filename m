Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab3LKWrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:47:46 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:34150 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab3LKWrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:47:45 -0500
Date: Wed, 11 Dec 2013 14:47:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@sr71.net>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cl@gentwo.org,
        kirill.shutemov@linux.intel.com, Andi Kleen <ak@linux.intel.com>,
        akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] mm: blk-mq: uses page->list incorrectly
In-Reply-To: <20131211223632.8B2DFD41@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.02.1312111447280.7354@chino.kir.corp.google.com>
References: <20131211223631.51094A3D@viggo.jf.intel.com> <20131211223632.8B2DFD41@viggo.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013, Dave Hansen wrote:

> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> 'struct page' has two list_head fields: 'lru' and 'list'.
> Conveniently, they are unioned together.  This means that code
> can use them interchangably, which gets horribly confusing.
> 
> The blk-mq made the logical decision to try to use page->list.
> But, that field was actually introduced just for the slub code.
> ->lru is the right field to use outside of slab/slub.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: David Rientjes <rientjes@google.com>
