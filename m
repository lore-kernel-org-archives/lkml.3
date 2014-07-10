Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaGJJCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:02:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51689 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaGJJCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:02:12 -0400
Date: Thu, 10 Jul 2014 11:02:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH V4 1/2] perf ignore LBR and extra_regs.
Message-ID: <20140710090204.GU3935@laptop>
References: <1404838181-3911-1-git-send-email-kan.liang@intel.com>
 <20140709141631.GE9918@twins.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F077014D2005@SHSMSX103.ccr.corp.intel.com>
 <20140709145809.GG9918@twins.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F077014D2729@SHSMSX103.ccr.corp.intel.com>
 <20140709164146.GH9918@twins.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F077014D361B@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F077014D361B@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/me reminds you of 78 char text wrap.

On Wed, Jul 09, 2014 at 07:32:09PM +0000, Liang, Kan wrote:
> > Sure; but what I meant was, check_msr() is broken when ran on such a
> > kernel. You need to fix check_msr() to return failure on these 'ignored'
> > MSRs, after all they don't function as expected, they're effectively broken.
> 
> The function is designed to check if the MSRs can be safely accessed
> (no #GP). It cannot guarantee the correctness of the MSRs.  If KVM
> applied patch 2 and guest applied patch 1, from the guest's
> perspective, the MSRs can be accessed (no #GP triggered). So return
> true is expected. It should not be a broken. 

You're not understanding. I know you wrote that function to do that. I'm
saying that's wrong.

Look at check_hw_exists() it explicitly checks for fake MSRs and reports
them broken.

These fake MSRs _ARE_ broken, they do not behave as expected. Not
crashing is not the right consideration here, we're interested in higher
order correct behaviour.

> The only unexpected
> thing for guest is that the counting/sampling result for LBR/extra reg
> is always 0. But the patch is a short term fix to stop things from
> crashing. I think it should be acceptable.

Patch 2 is fine, patch 1, in particular your check_msr() routine is not.
