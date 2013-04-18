Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966668Ab3DRJUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:20:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33590 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966504Ab3DRJUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:20:41 -0400
Date: Thu, 18 Apr 2013 10:20:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: sched_clock: Add more notrace to prevent recursion
Message-ID: <20130418092031.GH14496@n2100.arm.linux.org.uk>
References: <1363306086-23501-1-git-send-email-sboyd@codeaurora.org> <514B483F.7000304@codeaurora.org> <5151DC75.7030606@codeaurora.org> <516F3FA5.8070307@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516F3FA5.8070307@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 05:34:45PM -0700, Stephen Boyd wrote:
> On 03/26/13 10:35, Stephen Boyd wrote:
> > On 03/21/13 10:49, Stephen Boyd wrote:
> >> On 03/14/13 17:08, Stephen Boyd wrote:
> >>> cyc_to_sched_clock() is called by sched_clock() and cyc_to_ns()
> >>> is called by cyc_to_sched_clock(). I suspect that some compilers
> >>> inline both of these functions into sched_clock() and so we've
> >>> been getting away without having a notrace marking. It seems that
> >>> my compiler isn't inlining cyc_to_sched_clock() though, so I'm
> >>> hitting a recursion bug when I enable the function graph tracer,
> >>> causing my system to crash. Marking these functions notrace fixes
> >>> it. Technically cyc_to_ns() doesn't need the notrace because it's
> >>> already marked inline, but let's just add it so that if we ever
> >>> remove inline from that function it doesn't blow up.
> >> Anyone else seeing this problem?
> > Russell, should I put this into the patch tracker?
> 
> I'll throw this into the patch tracker tomorrow if nobody complains.

Or you could do so today.
