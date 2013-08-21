Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab3HUWQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:16:56 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:44524 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab3HUWQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:16:55 -0400
Date: Wed, 21 Aug 2013 15:16:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: RE: [patch] mm, thp: count thp_fault_fallback anytime thp fault
 fails
In-Reply-To: <20130821142817.8EB4BE0090@blue.fi.intel.com>
Message-ID: <alpine.DEB.2.02.1308211516290.6225@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1308201716510.25665@chino.kir.corp.google.com> <20130821142817.8EB4BE0090@blue.fi.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013, Kirill A. Shutemov wrote:

> David Rientjes wrote:
> > Currently, thp_fault_fallback in vmstat only gets incremented if a
> > hugepage allocation fails.  If current's memcg hits its limit or the page
> > fault handler returns an error, it is incorrectly accounted as a
> > successful thp_fault_alloc.
> > 
> > Count thp_fault_fallback anytime the page fault handler falls back to
> > using regular pages and only count thp_fault_alloc when a hugepage has
> > actually been faulted.
> > 
> > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> It's probably a good idea, but please make the behaviour consistent in
> do_huge_pmd_wp_page() and collapse path, otherwise it doesn't make sense.
> 

The collapse path has no fallback, the allocation either succeeds or it 
fails.
