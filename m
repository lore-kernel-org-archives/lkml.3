Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3HFQ6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 12:58:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:43055 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686Ab3HFQ6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 12:58:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,827,1367996400"; 
   d="scan'208";a="358475849"
Message-ID: <52012B35.90801@intel.com>
Date: Tue, 06 Aug 2013 09:58:29 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC PATCH 3/4] mm: add zbud flag to page flags
References: <1375771361-8388-1-git-send-email-k.kozlowski@samsung.com> <1375771361-8388-4-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1375771361-8388-4-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 11:42 PM, Krzysztof Kozlowski wrote:
> +#ifdef CONFIG_ZBUD
> +	/* Allocated by zbud. Flag is necessary to find zbud pages to unuse
> +	 * during migration/compaction.
> +	 */
> +	PG_zbud,
> +#endif

Do you _really_ need an absolutely new, unshared page flag?
The zbud code doesn't really look like it uses any of the space in
'struct page'.

I think you could pretty easily alias PG_zbud=PG_slab, then use the
page->{private,slab_cache} (or some other unused field) in 'struct page'
to store a cookie to differentiate slab and zbud pages.
