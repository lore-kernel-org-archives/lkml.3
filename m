Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab3EGJJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:09:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34055 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759160Ab3EGJJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:09:22 -0400
Date: Tue, 7 May 2013 10:08:49 +0100
From: Will Deacon <will.deacon@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] ARM: Remove any correlation between IPC and
 BogoMips value
Message-ID: <20130507090849.GC25387@mudshark.cambridge.arm.com>
References: <1367602547-19322-1-git-send-email-will.deacon@arm.com>
 <5187EFF3.6010005@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5187EFF3.6010005@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 07:01:23PM +0100, Christopher Covington wrote:
> Hi Will,
> 
> On 05/03/2013 01:35 PM, Will Deacon wrote:
> > Hi all,
> > 
> > This small patch set may look a little over a month late, but there is a
> > serious reason for posting it.
> > 
> > When I moved the ARM delay loop over to using the architected timers
> > rather than the CPU spinning loop (which has all the problems associated
> > with cpu frequency scaling and what-not) I thought I was doing something
> > useful for the port. However, it turns out that a surprising number of
> > people have complained, and continue to complain, about the drop in
> > their `BogoMIPs score'.
> 
> Have you considered adding the old code back in, but in a form that's not at
> all referenced by the delay loop code and just calculates CPU-based bogomips?

That seems like a lot of effort in order to preserve something that isn't
even meaningful. We might be better just zeroing the value, but then we'll
inevitably get bug reports of it being `wrong'.

Plus, the calibration during boot introduces a brief delay when onlining
each core whereas this can be skipped when using a constant timer.

Will
