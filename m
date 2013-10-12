Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3JLRV3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 13:21:29 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:56347 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab3JLRV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 13:21:27 -0400
Date: Sat, 12 Oct 2013 19:21:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131012172124.GA18241@gmail.com>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Neil Horman <nhorman@tuxdriver.com> wrote:

> Sébastien Dugué reported to me that devices implementing ipoib (which 
> don't have checksum offload hardware were spending a significant amount 
> of time computing checksums.  We found that by splitting the checksum 
> computation into two separate streams, each skipping successive elements 
> of the buffer being summed, we could parallelize the checksum operation 
> accros multiple alus.  Since neither chain is dependent on the result of 
> the other, we get a speedup in execution (on hardware that has multiple 
> alu's available, which is almost ubiquitous on x86), and only a 
> negligible decrease on hardware that has only a single alu (an extra 
> addition is introduced).  Since addition in commutative, the result is 
> the same, only faster

This patch should really come with measurement numbers: what performance 
increase (and drop) did you get on what CPUs.

Thanks,

	Ingo
