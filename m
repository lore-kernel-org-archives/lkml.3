Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab3JGJq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 05:46:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:50546 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab3JGJq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 05:46:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1049,1371106800"; 
   d="scan'208";a="406480394"
Date: Mon, 7 Oct 2013 17:46:53 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [x86] BUG: unable to handle kernel paging request at 08000060
Message-ID: <20131007094653.GA29497@localhost>
References: <20131005234430.GA22485@localhost>
 <20131005234728.GA22657@localhost>
 <20131007084957.GY3081@twins.programming.kicks-ass.net>
 <20131007091720.GA28025@localhost>
 <20131007093617.GB3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007093617.GB3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 11:36:17AM +0200, Peter Zijlstra wrote:
> On Mon, Oct 07, 2013 at 05:17:20PM +0800, Fengguang Wu wrote:
> > On Mon, Oct 07, 2013 at 10:49:57AM +0200, Peter Zijlstra wrote:
> > The numbers in the below two lines mean
> > 
> > > > git bisect good c31eeaced22ce8bd61268a3c595d542bb38c0a4f  # 21:59    450+  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
> > > > git bisect  bad a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 21:59      0-  Add linux-next specific files for 20130927
> > 
> > 21:59 => wall time
> > 
> > 450+  => this bisect test finishes after 450 good boots; suffix "+" means bisect test result is GOOD
> >          (collected large enough samples to claim it a GOOD kernel/commit)
> > 
> > 0-    => this bisect test finishes after   0 good boots; suffix "-" means bisect test result is BAD
> >          (it sees the message "BUG: unable to handle kernel ..." on the first boot)
> > 
> > Since all the BAD commits see only 0, 1, or 2 good boots (the lines
> > with "0-", "1-", "2-") before see the bug message, it means the
> > problem is pretty reproducible.
> 
> But the reported bad commit was: 0c44c2d0f459cd7e275242b72f500137c4fa834d
> which is not the same number as your last BAD line.

Ah yes, this is because the bisect script will in the end
double check whether the same bug exists in

- first bad commit's parent(s) (with increased boot count)
- first bad commit reverted (if could be reverted)
- branch HEAD (if the tree/branch could be figured out)
- upstream
- linux-next

Thanks,
Fengguang
