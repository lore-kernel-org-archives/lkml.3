Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab3EVOzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:55:48 -0400
Received: from www.sr71.net ([198.145.64.142]:52469 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389Ab3EVOzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:55:47 -0400
Message-ID: <519CDC70.7010308@sr71.net>
Date: Wed, 22 May 2013 07:55:44 -0700
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
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 26/39] ramfs: enable transparent huge page cache
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com> <1368321816-17719-27-git-send-email-kirill.shutemov@linux.intel.com> <519BF8A0.5000103@sr71.net> <20130522142236.315C7E0090@blue.fi.intel.com>
In-Reply-To: <20130522142236.315C7E0090@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 07:22 AM, Kirill A. Shutemov wrote:
> Dave Hansen wrote:
>>> +		/*
>>> +		 * TODO: make ramfs pages movable
>>> +		 */
>>> +		mapping_set_gfp_mask(inode->i_mapping,
>>> +				GFP_TRANSHUGE & ~__GFP_MOVABLE);
>>
>> So, before these patches, ramfs was movable.  Now, even on architectures
>> or configurations that have no chance of using THP-pagecache, ramfs
>> pages are no longer movable.  Right?
> 
> No, it wasn't movable. GFP_HIGHUSER is not GFP_HIGHUSER_MOVABLE (yeah,
> names of gfp constants could be more consistent).
> 
> ramfs should be fixed to use movable pages, but it's outside the scope of the
> patchset.
> 
> See more details: http://lkml.org/lkml/2013/4/2/720

Please make sure this is clear from the patch description.

Personally, I wouldn't be adding TODO's to the code that I'm not
planning to go fix, lest I would get tagged with _doing_ it. :)

