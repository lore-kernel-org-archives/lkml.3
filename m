Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3LSPSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:18:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab3LSPSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:18:41 -0500
Message-ID: <52B30E48.9070505@redhat.com>
Date: Thu, 19 Dec 2013 10:18:32 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Chao Yang <chayang@redhat.com>,
        linux-mm@kvack.org, aarcange@redhat.com, mgorman@suse.de,
        Veaceslav Falico <vfalico@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        David Rientjes <rientjes@google.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH] mm,numa,THP: initialize hstate for THP page size
References: <20131218170314.1e57bea7@cuia.bos.redhat.com> <20131218140830.924fa0a3bab0d497db5e256c@linux-foundation.org> <52B21FC7.7070905@redhat.com> <20131219102231.GE10855@dhcp22.suse.cz>
In-Reply-To: <20131219102231.GE10855@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 05:22 AM, Michal Hocko wrote:
> [Adding Dave and Mel]

> copy_huge_page as hugetlb specific thing. It relies on hstate which is
> obviously not existing for THP pages. So why do we use it for thp pages
> in the first place?
> 
> Mel, your "mm: numa: Add THP migration for the NUMA working set scanning
> fault case." has added check for PageTransHuge in migrate_page_copy so
> it uses the shared copy_huge_page now. Dave has already tried to fix it
> by https://lkml.org/lkml/2013/10/28/592 but this one has been dropped
> later with "to-be-updated".
> 
> Dave do you have an alternative for your patch?

Gah, never mind me.  This oops happened on a slightly older tree,
that did not have Dave's patch yet...

Andrew, you can drop the patch. Sorry for the noise.

-- 
All rights reversed
