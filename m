Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab3J1NQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:16:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50308 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab3J1NQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:16:02 -0400
Date: Mon, 28 Oct 2013 14:15:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: RFC: paravirtualizing perf_clock
Message-ID: <20131028131556.GN19466@laptop.lan>
References: <526DBD7F.1010807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526DBD7F.1010807@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 07:27:27PM -0600, David Ahern wrote:
> Often when debugging performance problems in a virtualized environment you
> need to correlate what is happening in the guest with what is happening in
> the host. To correlate events you need a common time basis (or the ability
> to directly correlate the two).
> 
> The attached patch paravirtualizes perf_clock, pulling the timestamps in VMs
> from the host using an MSR read if the option is available (exposed via KVM
> feature flag). I realize this is not the correct end code but it illustrates
> what I would like to see -- host and guests using the same perf_clock so
> timestamps directly correlate.
> 
> Any suggestions on how to do this and without impacting performance. I
> noticed the MSR path seems to take about twice as long as the current
> implementation (which I believe results in rdtsc in the VM for x86 with
> stable TSC).

So assuming all the TSCs are in fact stable; you could implement this by
syncing up the guest TSC to the host TSC on guest boot. I don't think
anything _should_ rely on the absolute TSC value.

Of course you then also need to make sure the host and guest tsc
multipliers (cyc2ns) are identical, you can play games with
cyc2ns_offset if you're brave.
