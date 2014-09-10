Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaIJSWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:22:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36454 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044AbaIJSWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:22:11 -0400
Date: Wed, 10 Sep 2014 19:21:37 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH] ARM: perf: Don't sleep while atomic when enabling
 per-cpu interrupts
Message-ID: <20140910182137.GL1710@arm.com>
References: <1410200814-25878-1-git-send-email-sboyd@codeaurora.org>
 <20140909113943.GG1754@arm.com>
 <540F3EE5.90500@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540F3EE5.90500@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 06:54:45PM +0100, Stephen Boyd wrote:
> On 09/09/14 04:39, Will Deacon wrote:
> > It's interesting that arm64 isn't affected by this problem, since we don't
> > update the active_irqs mask for PPIs there and consequently just pass the
> > irq instead of the cpu_pmu. I can't see why we actually need to update the
> > active_irqs mask for arch/arm/, so could we remove that and follow arm64's
> > lead instead? That would remove the need for a new struct definition too.
> >
> 
> I guess you're saying that we don't need the active_irqs mask in the
> percpu irq case? It looks like we still use it to determine when the
> last CPU PMU has been disabled in the non-percpu case.

Correct.

> Here's the interdiff. Is there a reason arm64 casts data to an unsigned
> int pointer when what's passed is an int pointer?

There has to be a cast to something because data is a void *.
enable_percpu_irq takes an unsigned int, so I guess that's why it was
chosen. I'm not fussed either way.

Feel free to submit the full patch with my ack:

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
