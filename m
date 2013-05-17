Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab3EQNlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:41:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:26384 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab3EQNlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:41:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,692,1363158000"; 
   d="scan'208";a="335751732"
Date: Fri, 17 May 2013 09:41:28 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [patch -resend] NVMe: check for integer overflow in
 nvme_map_user_pages()
Message-ID: <20130517134128.GT6057@linux.intel.com>
References: <100D68C7BA14664A8938383216E40DE027F80EAB@fmsmsx111.amr.corp.intel.com>
 <20130513145950.GA21239@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130513145950.GA21239@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 05:59:50PM +0300, Dan Carpenter wrote:
> You need to have CAP_SYS_ADMIN to trigger this overflow but it makes the
> static checkers complain so we should fix it.  The worry is that
> "length" comes from copy_from_user() so we need to check that "length +
> offset" can't overflow.
> 
> I also changed the min_t() cast to be unsigned instead of signed.  Now
> that we cap "length" to INT_MAX it doesn't make a difference, but it's a
> little easier for reviewers to know that large values aren't cast to
> negative.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied
