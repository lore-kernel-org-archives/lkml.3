Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaGNGk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:40:29 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:52448 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaGNGkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:40:22 -0400
Date: Mon, 14 Jul 2014 10:40:19 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH -mm v5 12/13] mm: /proc/pid/clear_refs: avoid
 split_huge_page()
Message-ID: <20140714064019.GF19702@moon>
References: <1405103749-23506-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1405103749-23506-13-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405103749-23506-13-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 02:35:48PM -0400, Naoya Horiguchi wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> Currently pagewalker splits all THP pages on any clear_refs request.  It's
> not necessary.  We can handle this on PMD level.
> 
> One side effect is that soft dirty will potentially see more dirty memory,
> since we will mark whole THP page dirty at once.
> 
> Sanity checked with CRIU test suite. More testing is required.
> 
> ChangeLog:
> - move code for thp to clear_refs_pte_range()
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
