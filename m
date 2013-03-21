Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955Ab3CUQTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:19:50 -0400
Received: from www.sr71.net ([198.145.64.142]:50632 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab3CUQTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:19:48 -0400
Message-ID: <514B336C.6070404@sr71.net>
Date: Thu, 21 Mar 2013 09:21:00 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
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
Subject: Re: [PATCHv2, RFC 07/30] thp, mm: introduce mapping_can_have_hugepages()
 predicate
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <1363283435-7666-8-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1363283435-7666-8-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 10:50 AM, Kirill A. Shutemov wrote:
> +static inline bool mapping_can_have_hugepages(struct address_space *m)
> +{
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
> +		gfp_t gfp_mask = mapping_gfp_mask(m);
> +		return !!(gfp_mask & __GFP_COMP);
> +	}
> +
> +	return false;
> +}

I did a quick search in all your patches and don't see __GFP_COMP
getting _set_ anywhere.  Am I missing something?
