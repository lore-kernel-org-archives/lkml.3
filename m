Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaGAVAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:00:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:7357 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaGAVAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:00:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,584,1400050800"; 
   d="scan'208";a="537386066"
Message-ID: <53B32170.1040707@intel.com>
Date: Tue, 01 Jul 2014 14:00:32 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Jet Chen <jet.chen@intel.com>
Subject: Re: [PATCH v4 11/13] mempolicy: apply page table walker on queue_pages_range()
References: <1404234451-21695-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1404234451-21695-12-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1404234451-21695-12-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 10:07 AM, Naoya Horiguchi wrote:
> queue_pages_range() does page table walking in its own way now, but there
> is some code duplicate. This patch applies page table walker to reduce
> lines of code.
> 
> queue_pages_range() has to do some precheck to determine whether we really
> walk over the vma or just skip it. Now we have test_walk() callback in
> mm_walk for this purpose, so we can do this replacement cleanly.
> queue_pages_test_walk() depends on not only the current vma but also the
> previous one, so queue_pages->prev is introduced to remember it.

Hi Naoya,

The previous version of this patch caused a performance regression which
was reported to you:

	http://marc.info/?l=linux-kernel&m=140375975525069&w=2

Has that been dealt with in this version somehow?
