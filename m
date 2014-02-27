Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaB0W4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 17:56:12 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:37327 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbaB0W4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 17:56:10 -0500
Date: Fri, 28 Feb 2014 00:56:00 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: call vma_adjust_trans_huge() only for
 thp-enabled vma
Message-ID: <20140227225600.GA8034@node.dhcp.inet.fi>
References: <1393475977-3381-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1393475977-3381-4-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393475977-3381-4-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 11:39:37PM -0500, Naoya Horiguchi wrote:
> vma_adjust() is called also for vma(VM_HUGETLB) and it could happen that
> we happen to try to split hugetlbfs hugepage. So exclude the possibility.

NAK.

It can't happen: vma_adjust_trans_huge checks for vma->vm_ops and hugetlb
VMA always have it set unlike THP.

-- 
 Kirill A. Shutemov
