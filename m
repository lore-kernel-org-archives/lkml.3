Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaABSF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:05:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:47336 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbaABSF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:05:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,592,1384329600"; 
   d="scan'208";a="433097583"
Message-ID: <52C5AA61.8060701@intel.com>
Date: Thu, 02 Jan 2014 10:05:21 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
References: <20140101002935.GA15683@localhost.localdomain>
In-Reply-To: <20140101002935.GA15683@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2013 04:29 PM, Han Pingtian wrote:
> min_free_kbytes may be updated during thp's initialization. Sometimes,
> this will change the value being set by user. Showing message will
> clarify this confusion.
...
> -	if (recommended_min > min_free_kbytes)
> +	if (recommended_min > min_free_kbytes) {
>  		min_free_kbytes = recommended_min;
> +		pr_info("min_free_kbytes is updated to %d by enabling transparent hugepage.\n",
> +			min_free_kbytes);
> +	}

"updated" doesn't tell us much.  It's also kinda nasty that if we enable
then disable THP, we end up with an elevated min_free_kbytes.  Maybe we
should at least put something in that tells the user how to get back
where they were if they care:

"raising min_free_kbytes from %d to %d to help transparent hugepage
allocations"


