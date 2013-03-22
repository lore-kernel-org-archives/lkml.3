Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422878Ab3CVSIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 14:08:51 -0400
Received: from www.sr71.net ([198.145.64.142]:34171 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422810Ab3CVSIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 14:08:50 -0400
Message-ID: <514CA05D.6030302@sr71.net>
Date: Fri, 22 Mar 2013 11:18:05 -0700
From: Dave <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
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
Subject: Re: [PATCHv2, RFC 16/30] thp: handle file pages in split_huge_page()
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <1363283435-7666-17-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1363283435-7666-17-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 10:50 AM, Kirill A. Shutemov wrote:
> +static int split_anon_huge_page(struct page *page)
>  {
>  	struct anon_vma *anon_vma;
>  	int ret = 1;
>  
> -	BUG_ON(is_huge_zero_pfn(page_to_pfn(page)));
> -	BUG_ON(!PageAnon(page));

Did you really mean to kill these BUG_ON()s?  They still look relevant
to me.


