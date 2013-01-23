Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab3AWOZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:25:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab3AWOZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:25:06 -0500
Date: Wed, 23 Jan 2013 14:25:07 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Simon Jeons <simon.jeons@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] mm: Fold page->_last_nid into page->flags where
 possible
Message-ID: <20130123142507.GI13304@suse.de>
References: <1358874762-19717-1-git-send-email-mgorman@suse.de>
 <1358874762-19717-6-git-send-email-mgorman@suse.de>
 <20130122144659.d512e05c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130122144659.d512e05c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 02:46:59PM -0800, Andrew Morton wrote:
> 
> reset_page_last_nid() is poorly named.  page_reset_last_nid() would be
> better, and consistent.
> 

Look at this closer, are you sure you want? Why is page_reset_last_nid()
better or more consistent?

The getter functions for page-related fields start with page (page_count,
page_mapcount etc.) but the setters begin with set (set_page_section,
set_page_zone, set_page_links etc.). For mapcount, we also have
reset_page_mapcount() so to me reset_page_last_nid() is already
consistent.

-- 
Mel Gorman
SUSE Labs
