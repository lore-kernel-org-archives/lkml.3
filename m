Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab3HGGSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:18:12 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:57372 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121Ab3HGGSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:18:09 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-df-5201e69ebba7
From: Namhyung Kim <namhyung@kernel.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: <linux-kernel@vger.kernel.org>, acme@ghostprotocols.net,
        a.p.zijlstra@chello.nl, jolsa@redhat.com
Subject: Re: [PATCH v2 1/2] perf tools: Add support for pinned modifier
References: <1375795686-4226-1-git-send-email-michael@ellerman.id.au>
Date: Wed, 07 Aug 2013 15:18:06 +0900
In-Reply-To: <1375795686-4226-1-git-send-email-michael@ellerman.id.au>
	(Michael Ellerman's message of "Tue, 6 Aug 2013 23:28:05 +1000")
Message-ID: <87bo5ayqg1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Tue,  6 Aug 2013 23:28:05 +1000, Michael Ellerman wrote:
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

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
