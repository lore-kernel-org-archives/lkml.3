Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967611Ab3DRQRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:17:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:56790 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967469Ab3DRQRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:17:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,502,1363158000"; 
   d="scan'208";a="320378887"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave@sr71.net>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20130418160920.4A00DE0085@blue.fi.intel.com>
References: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1365163198-29726-32-git-send-email-kirill.shutemov@linux.intel.com>
 <51631206.3060605@sr71.net>
 <20130417143842.1A76CE0085@blue.fi.intel.com>
 <516F1D3C.1060804@sr71.net>
 <20130418160920.4A00DE0085@blue.fi.intel.com>
Subject: Re: [PATCHv3, RFC 31/34] thp: initial implementation of
 do_huge_linear_fault()
Content-Transfer-Encoding: 7bit
Message-Id: <20130418161906.2818DE0085@blue.fi.intel.com>
Date: Thu, 18 Apr 2013 19:19:06 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote:
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index c8a8626..4669c19 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -165,6 +165,11 @@ extern pgprot_t protection_map[16];
>  #define FAULT_FLAG_RETRY_NOWAIT	0x10	/* Don't drop mmap_sem and wait when retrying */
>  #define FAULT_FLAG_KILLABLE	0x20	/* The fault task is in SIGKILL killable region */
>  #define FAULT_FLAG_TRIED	0x40	/* second try */
> +#ifdef CONFIG_CONFIG_TRANSPARENT_HUGEPAGE

Oops, s/CONFIG_CONFIG/CONFIG/.

-- 
 Kirill A. Shutemov
