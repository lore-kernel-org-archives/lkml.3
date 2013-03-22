Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab3CVKK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:10:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:24464 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932191Ab3CVKK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:10:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,891,1355126400"; 
   d="scan'208";a="217698331"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave@sr71.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <514B336C.6070404@sr71.net>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1363283435-7666-8-git-send-email-kirill.shutemov@linux.intel.com>
 <514B336C.6070404@sr71.net>
Subject: Re: [PATCHv2, RFC 07/30] thp, mm: introduce
 mapping_can_have_hugepages() predicate
Content-Transfer-Encoding: 7bit
Message-Id: <20130322101211.34A5EE0085@blue.fi.intel.com>
Date: Fri, 22 Mar 2013 12:12:11 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On 03/14/2013 10:50 AM, Kirill A. Shutemov wrote:
> > +static inline bool mapping_can_have_hugepages(struct address_space *m)
> > +{
> > +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
> > +		gfp_t gfp_mask = mapping_gfp_mask(m);
> > +		return !!(gfp_mask & __GFP_COMP);
> > +	}
> > +
> > +	return false;
> > +}
> 
> I did a quick search in all your patches and don't see __GFP_COMP
> getting _set_ anywhere.  Am I missing something?

__GFP_COMP is part of GFP_TRANSHUGE. We set it for ramfs in patch 20/30.

-- 
 Kirill A. Shutemov
