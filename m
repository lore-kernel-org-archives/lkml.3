Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964952AbaGAVwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:52:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756968AbaGAVwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:52:16 -0400
Date: Tue, 1 Jul 2014 17:51:56 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Jet Chen <jet.chen@intel.com>
Subject: Re: [PATCH v4 11/13] mempolicy: apply page table walker on
 queue_pages_range()
Message-ID: <20140701215156.GA21032@nhori.bos.redhat.com>
References: <1404234451-21695-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1404234451-21695-12-git-send-email-n-horiguchi@ah.jp.nec.com>
 <53B32170.1040707@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B32170.1040707@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 02:00:32PM -0700, Dave Hansen wrote:
> On 07/01/2014 10:07 AM, Naoya Horiguchi wrote:
> > queue_pages_range() does page table walking in its own way now, but there
> > is some code duplicate. This patch applies page table walker to reduce
> > lines of code.
> > 
> > queue_pages_range() has to do some precheck to determine whether we really
> > walk over the vma or just skip it. Now we have test_walk() callback in
> > mm_walk for this purpose, so we can do this replacement cleanly.
> > queue_pages_test_walk() depends on not only the current vma but also the
> > previous one, so queue_pages->prev is introduced to remember it.
> 
> Hi Naoya,
> 
> The previous version of this patch caused a performance regression which
> was reported to you:
> 
> 	http://marc.info/?l=linux-kernel&m=140375975525069&w=2
> 
> Has that been dealt with in this version somehow?

I believe so, in previous version we called ->pte_entry() callback
for each pte entries, but in this version I stop doing this and
most of works are done in ->pmd_entry() callback, so the number
of function calls are reduced by about 1/512. And rather than that,
I just cleaned up queue_pages_* without major behavioral changes, so
the visible regression should be solved.

Thanks,
Naoya Horiguchi
