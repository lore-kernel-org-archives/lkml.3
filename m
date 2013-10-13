Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab3JMMxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 08:53:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43528 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3JMMxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 08:53:15 -0400
Date: Sun, 13 Oct 2013 08:53:03 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131013125302.GB9286@neilslaptop.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <20131012172124.GA18241@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131012172124.GA18241@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 07:21:24PM +0200, Ingo Molnar wrote:
> 
> * Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > Sébastien Dugué reported to me that devices implementing ipoib (which 
> > don't have checksum offload hardware were spending a significant amount 
> > of time computing checksums.  We found that by splitting the checksum 
> > computation into two separate streams, each skipping successive elements 
> > of the buffer being summed, we could parallelize the checksum operation 
> > accros multiple alus.  Since neither chain is dependent on the result of 
> > the other, we get a speedup in execution (on hardware that has multiple 
> > alu's available, which is almost ubiquitous on x86), and only a 
> > negligible decrease on hardware that has only a single alu (an extra 
> > addition is introduced).  Since addition in commutative, the result is 
> > the same, only faster
> 
> This patch should really come with measurement numbers: what performance 
> increase (and drop) did you get on what CPUs.
> 
> Thanks,
> 
Sure, I can gather some stats for you.  I'll post them later this week
Neil

> 	Ingo
> 
