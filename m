Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab3DPPLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:11:30 -0400
Received: from www.sr71.net ([198.145.64.142]:60381 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629Ab3DPPL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:11:29 -0400
Message-ID: <516D6A1E.4060201@sr71.net>
Date: Tue, 16 Apr 2013 08:11:26 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
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
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3, RFC 09/34] thp: represent file thp pages in meminfo
 and friends
References: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com> <1365163198-29726-10-git-send-email-kirill.shutemov@linux.intel.com> <51631CC0.5010908@sr71.net> <20130416144917.8FEAEE0085@blue.fi.intel.com>
In-Reply-To: <20130416144917.8FEAEE0085@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 07:49 AM, Kirill A. Shutemov wrote:
> Dave Hansen wrote:
>> On 04/05/2013 04:59 AM, Kirill A. Shutemov wrote:
>>> The patch adds new zone stat to count file transparent huge pages and
>>> adjust related places.
>>>
>>> For now we don't count mapped or dirty file thp pages separately.
>>
>> I can understand tracking NR_FILE_TRANSPARENT_HUGEPAGES itself.  But,
>> why not also account for them in NR_FILE_PAGES?  That way, you don't
>> have to special-case each of the cases below:
> 
> Good point.
> To be consistent I'll also convert NR_ANON_TRANSPARENT_HUGEPAGES to be
> accounted in NR_ANON_PAGES.

Hmm...  I didn't realize we did that for the anonymous version.  But,
looking at the meminfo code:

> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>                 K(global_page_state(NR_ANON_PAGES)
>                   + global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
>                   HPAGE_PMD_NR),
> #else
>                 K(global_page_state(NR_ANON_PAGES)),
> #endif

That #ifdef and a couple others like it would just go away if we did
this.  It would be a nice cleanup.
