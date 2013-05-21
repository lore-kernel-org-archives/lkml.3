Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab3EUTcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 15:32:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:3379 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723Ab3EUTcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 15:32:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,715,1363158000"; 
   d="scan'208";a="305854405"
Message-ID: <519BCBDE.2050504@intel.com>
Date: Tue, 21 May 2013 12:32:46 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 10/39] thp: account anon transparent huge pages into
 NR_ANON_PAGES
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com> <1368321816-17719-11-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1368321816-17719-11-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2013 06:23 PM, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> We use NR_ANON_PAGES as base for reporting AnonPages to user.
> There's not much sense in not accounting transparent huge pages there, but
> add them on printing to user.
> 
> Let's account transparent huge pages in NR_ANON_PAGES in the first place.

This is another one that needs to be pretty carefully considered
_independently_ of the rest of this set.  It also has potential
user-visible changes, so it would be nice to have a blurb in the patch
description if you've thought about this, any why you think it's OK.

But, it still makes solid sense to me, and simplifies the code.

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
