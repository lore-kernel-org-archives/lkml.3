Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab3FNFyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:54:13 -0400
Received: from 1wt.eu ([62.212.114.60]:36327 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab3FNFyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:54:11 -0400
Date: Fri, 14 Jun 2013 07:54:06 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Linux 2.6.32.61
Message-ID: <20130614055406.GA880@1wt.eu>
References: <20130610101557.GA3235@1wt.eu> <1371183115.10688.78.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371183115.10688.78.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Fri, Jun 14, 2013 at 05:11:55AM +0100, Ben Hutchings wrote:
> On Mon, 2013-06-10 at 12:15 +0200, Willy Tarreau wrote:
> [...]
> > Eric Dumazet (8):
> [...]
> >       softirq: reduce latencies
> [...]
> 
> This one apparently introduces a regression, fixed in mainline by commit
> 34376a50fb1f 'Fix lockup related to stop_machine being stuck in
> __do_softirq.'
> 
> I'm a bit surprised that you picked it for 2.6.32 as it wasn't applied
> to any other branch older than 3.9.

Interesting. It was discussed on stable@ in March between Eric and Paul
about the pertinence of merging it into 2.6.32 and 2.6.34 (both CCed).
The thread was '[PATCH] net: reduce net_rx_action() latency to 2 HZ'.
It is supposed to fix a but introduced in 2.6.29 by commit 24f8b2385
(net: increase receive packet quantum).

I didn't notice that it was not in more recent versions.

Eric, do you suggest that I revert this patch or that I also include the
mainline fix above to fix the regression ? If the latter, should Paul and
Greg also take the two patches ?

Thanks,
Willy

