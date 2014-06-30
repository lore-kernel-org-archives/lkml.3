Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaF3MUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:20:31 -0400
Received: from mta-out1.inet.fi ([62.71.2.199]:45852 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbaF3MU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:20:28 -0400
Date: Mon, 30 Jun 2014 15:20:16 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v3 09/13] memcg: apply walk_page_vma()
Message-ID: <20140630122016.GY19833@node.dhcp.inet.fi>
References: <1403295099-6407-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1403295099-6407-10-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403295099-6407-10-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 04:11:35PM -0400, Naoya Horiguchi wrote:
> pagewalk.c can handle vma in itself, so we don't have to pass vma via
> walk->private. And both of mem_cgroup_count_precharge() and
> mem_cgroup_move_charge() walk over all vmas (not interested in outside vma,)
> so using walk_page_vma() is preferable.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

My first thought was to suggest walk_page_range(0, -1, &walk) instead
since we walk over all vmas. But walk_page_range() uses find_vma() on each
iteration, which is expensive.
Is there a reason why we cannot use vma->vm_next in walk_page_range()?

-- 
 Kirill A. Shutemov
