Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaICLcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:32:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36254 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbaICLcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:32:47 -0400
Date: Wed, 3 Sep 2014 13:32:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>, Ben Segall <bsegall@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] sched: Reduce contention in update_cfs_rq_blocked_load
Message-ID: <20140903113242.GO4783@worktop.ger.corp.intel.com>
References: <1409094682.29189.23.camel@j-VirtualBox>
 <CAPM31RJcYakzwo9mByoadw6DGcg5SfYDOdX79NPo08hBP5PGjA@mail.gmail.com>
 <1409160893.31379.24.camel@j-VirtualBox>
 <1409182369.27939.9.camel@schen9-desk2.jf.intel.com>
 <1409255196.4945.7.camel@j-VirtualBox>
 <20140901125505.GK27892@worktop.ger.corp.intel.com>
 <1409643684.19197.15.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409643684.19197.15.camel@j-VirtualBox>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 12:41:24AM -0700, Jason Low wrote:
> On Mon, 2014-09-01 at 14:55 +0200, Peter Zijlstra wrote:
> > But yes, unbounded errors here are a problem, sure relaxing the updates
> > makes things go fast, they also make things go skew.
> 
> Okay. In that case, would you like to take our original patch which
> avoids unnecessary updates?

This seems a safe patch; yes I'll queue it while we think of smarter
things :-)
