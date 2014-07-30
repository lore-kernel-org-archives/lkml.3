Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaG3VWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:22:43 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:33723 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaG3VWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:22:42 -0400
Message-ID: <1406755359.2529.4.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [patch] Documentation: SubmittingPatches: overhaul changelog
 howto
From: Davidlohr Bueso <davidlohr@hp.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Date: Wed, 30 Jul 2014 14:22:39 -0700
In-Reply-To: <1406754661-15897-1-git-send-email-hannes@cmpxchg.org>
References: <1406754661-15897-1-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-30 at 17:11 -0400, Johannes Weiner wrote:
> Maintainers often repeat the same feedback on poorly written
> changelogs - describe the problem, justify your changes, quantify
> optimizations, describe user-visible changes - but our documentation
> on writing changelogs doesn't include these things.  Fix that.

Agreed. Maybe other software projects can use this as well...


> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  Documentation/SubmittingPatches | 38 +++++++++++++++++++++++++++++++-------
>  1 file changed, 31 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index dcadffcab2dc..0a523c9a5ff4 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -84,18 +84,42 @@ is another popular alternative.
>  
>  2) Describe your changes.
>  
> -Describe the technical detail of the change(s) your patch includes.
> -
> -Be as specific as possible.  The WORST descriptions possible include
> -things like "update driver X", "bug fix for driver X", or "this patch
> -includes updates for subsystem X.  Please apply."
> +Describe your problem.  Whether your patch is a one-line bug fix or
> +5000 lines of a new feature, there must be an underlying problem that
> +motivated you to do this work.  Convince the reviewer that there is a
> +problem worth fixing and that it makes sense for them to read past the
> +first paragraph.
> +
> +Describe user-visible impact.  Straight up crashes and lockups are
> +pretty convincing, but not all bugs are that blatant.  Even if the
> +problem was spotted during code review, describe the impact you think
> +it can have on users.  Keep in mind that the majority of Linux
> +installations run kernels from secondary stable trees or
> +vendor/product-specific trees that cherry-pick only specific patches
> +from upstream, so include anything that could help route your change
> +downstream: provoking circumstances, excerpts from dmesg, crash
> +descriptions, performance regressions, latency spikes, lockups, etc.
> +
> +Quantify optimizations and trade-offs.  If you claim improvements in
> +performance, memory consumption, stack footprint, or binary size,
> +include numbers that back them up.  But also describe non-obvious
> +costs.  Optimizations usually aren't free but trade-offs between CPU,
> +memory, and readability; or, when it comes to heuristics, between
> +different workloads.  Describe the expected downsides of your
> +optimization so that the reviewer can weigh costs against benefits.
> +
> +Once the problem is established, describe what you are actually doing
> +about it in technical detail.  It's important to describe the change
> +in plain English for the reviewer to verify that the code is behaving
> +as you intend it to.

Very nicely put. I would also add that past patches or attempts to solve
a related (or even the same) issue. What's different in my approach?
What are the past issues that cause original approaches not to get
merged? etc.

