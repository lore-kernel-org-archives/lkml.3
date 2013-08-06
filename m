Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab3HFOCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 10:02:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab3HFOCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 10:02:30 -0400
Date: Tue, 6 Aug 2013 16:02:21 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH v2 1/2] perf tools: Add support for pinned modifier
Message-ID: <20130806140221.GD1068@krava.brq.redhat.com>
References: <1375795686-4226-1-git-send-email-michael@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375795686-4226-1-git-send-email-michael@ellerman.id.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 11:28:05PM +1000, Michael Ellerman wrote:
> This commit adds support for a new modifier "D", which requests that the
> event, or group of events, be pinned to the PMU.
> 
> The "p" modifier is already taken for precise, and "P" may be used in
> future to mean "fully precise".
> 
> So we use "D", which stands for pinneD - and looks like a padlock, or if
> you're using the ":D" syntax perf smiles at you.
> 
> This is an oft-requested feature from our HW folks, who want to be able
> to run a large number of events, but also want 100% accurate results for
> instructions per cycle.
> 
> Comparison of results with and without pinning:
> 
> $ perf stat -e '{cycles,instructions}:D' -e cycles,instructions,...
> 
>   79,590,480,683 cycles         #  0.000 GHz
>  166,123,716,524 instructions   #  2.09  insns per cycle
>                                 #  0.11  stalled cycles per insn
> 
>   79,352,134,463 cycles         #  0.000 GHz                     [11.11%]
>  165,178,301,818 instructions   #  2.08  insns per cycle
>                                 #  0.11  stalled cycles per insn [11.13%]
> 
> As you can see although perf does a very good job of scaling the values
> in the non-pinned case, there is some small discrepancy.
> 
> The patch is fairly straight forward, the one detail is that we need to
> make sure we only request pinning for the group leader when we have a
> group.
> 
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

Tested-by/Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
