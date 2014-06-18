Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966472AbaFRMU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:20:28 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:55995 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966122AbaFRMU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:20:26 -0400
Date: Wed, 18 Jun 2014 15:17:31 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v2 2/2] mm, thp: replace smp_mb after atomic_add by
 smp_mb__after_atomic
Message-ID: <20140618121731.GA5957@node.dhcp.inet.fi>
References: <1403044679-9993-1-git-send-email-Waiman.Long@hp.com>
 <1403044679-9993-3-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403044679-9993-3-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 06:37:59PM -0400, Waiman Long wrote:
> In some architectures like x86, atomic_add() is a full memory
> barrier. In that case, an additional smp_mb() is just a waste of time.
> This patch replaces that smp_mb() by smp_mb__after_atomic() which
> will avoid the redundant memory barrier in some architectures.
> 
> With a 3.16-rc1 based kernel, this patch reduced the execution time
> of breaking 1000 transparent huge pages from 38,245us to 30,964us. A
> reduction of 19% which is quite sizeable. It also reduces the %cpu
> time of the __split_huge_page_refcount function in the perf profile
> from 2.18% to 1.15%.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
