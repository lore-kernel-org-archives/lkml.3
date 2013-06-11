Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab3FKQEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:04:13 -0400
Received: from www.sr71.net ([198.145.64.142]:43589 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab3FKQEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:04:11 -0400
Message-ID: <51B74A7A.1040707@sr71.net>
Date: Tue, 11 Jun 2013 09:04:10 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] thp, mm: avoid PageUnevictable on active/inactive
 lru lists
References: <1370964919-16187-1-git-send-email-kirill.shutemov@linux.intel.com> <1370964919-16187-3-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1370964919-16187-3-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 08:35 AM, Kirill A. Shutemov wrote:
> active/inactive lru lists can contain unevicable pages (i.e. ramfs pages
> that have been placed on the LRU lists when first allocated), but these
> pages must not have PageUnevictable set - otherwise shrink_[in]active_list
> goes crazy:

I think it's also important here to note if this is a bug that can be
hit _currently_, or if this really is just a preparatory patch for
transparent huge page cache.

>From what I can see, this is _needed_ preparatory work, but it can also
stand on its own because it simplifies things.  It should go in sooner
rather than later.
