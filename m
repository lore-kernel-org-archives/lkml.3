Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaJMSHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 14:07:10 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:52484 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbaJMSHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 14:07:08 -0400
Message-ID: <1413223622.5146.68.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] BLD-3.17 release.
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2014 20:07:02 +0200
In-Reply-To: <CADZ9YHiqyGGMRJFvghbkDO7iP=7niEnpOt_Cp8sMwLn+iA8ivA@mail.gmail.com>
References: <1413008458.5939.4.camel@localhost.localdomain>
	 <1413187299.5232.44.camel@marge.simpson.net>
	 <CADZ9YHiqyGGMRJFvghbkDO7iP=7niEnpOt_Cp8sMwLn+iA8ivA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 21:14 +0600, Rakib Mullick wrote:

> Okay. From the numbers above it's apparent that BLD isn't doing good,
> atleast for the
> kind of system that you have been using. I didn't had a chance to ran
> it on any kind of
> NUMA systems, for that reason on Kconfig, I've marked it as "Not
> suitable for NUMA", yet.

(yeah, a NUMA box would rip itself to shreds)

> Part of the reason is, I didn't manage to try it out myself and other
> reason is, it's easy to
> get things wrong if schedule domains are build improperly. I'm not
> sure what was the
> sched configuration in your case. BLD assumes (or kindof bliendly
> believes systems
> default sched domain topology) on wakeup tasks are cache hot and so
> don't put those
> task's on other sched domains, but if that isn't the case then perhaps
> it'll miss out on
> balancing oppourtunity, in that case CPU utilization will be improper.

Even when you have only one socket with a big L3, you don't really want
to bounce fast/light tasks around too frequently, L2 misses still hurt.

> Can you please share the perf stat of netperf runs? So, far I have
> seen reduced context
> switch numbers with -BLD with a drawback of huge increase of CPU
> migration numbers.

No need, it's L2 misses.  Q6600 has no L3 to mitigate the miss pain.

> But, the kind of systems I ran so far, it deemed too much CPU movement
> didn't cost much.
> But, it could be wrong for NUMA systems.

You can most definitely move even very fast/light tasks too much within
an L3, L2 misses can demolish throughput.  We had that problem.

-Mike

