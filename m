Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbaKCVHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:07:17 -0500
Received: from mta-out1.inet.fi ([62.71.2.234]:56354 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbaKCVHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:07:15 -0500
Date: Mon, 3 Nov 2014 23:06:07 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Vladimir Davydov <vdavydov@parallels.com>, Tejun Heo <tj@kernel.org>,
        David Miller <davem@davemloft.net>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct page
Message-ID: <20141103210607.GA24091@node.dhcp.inet.fi>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 11:15:54PM -0400, Johannes Weiner wrote:
> Memory cgroups used to have 5 per-page pointers.  To allow users to
> disable that amount of overhead during runtime, those pointers were
> allocated in a separate array, with a translation layer between them
> and struct page.
> 
> There is now only one page pointer remaining: the memcg pointer, that
> indicates which cgroup the page is associated with when charged.  The
> complexity of runtime allocation and the runtime translation overhead
> is no longer justified to save that *potential* 0.19% of memory.

How much do you win by the change?

-- 
 Kirill A. Shutemov
