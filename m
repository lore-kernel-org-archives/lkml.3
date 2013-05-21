Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab3EUW4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:56:45 -0400
Received: from www.sr71.net ([198.145.64.142]:46082 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182Ab3EUW4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:56:44 -0400
Message-ID: <519BFBA9.7040007@sr71.net>
Date: Tue, 21 May 2013 15:56:41 -0700
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
Subject: Re: [PATCHv4 27/39] x86-64, mm: proper alignment mappings with hugepages
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com> <1368321816-17719-28-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1368321816-17719-28-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2013 06:23 PM, Kirill A. Shutemov wrote:
> +static inline unsigned long mapping_align_mask(struct address_space *mapping)
> +{
> +	if (mapping_can_have_hugepages(mapping))
> +		return PAGE_MASK & ~HPAGE_MASK;
> +	return get_align_mask();
> +}

get_align_mask() appears to be a bit more complicated to me than just a
plain old mask.  Are you sure you don't need to pick up any of its
behavior for the mapping_can_have_hugepages() case?
