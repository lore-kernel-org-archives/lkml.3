Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaJCGXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 02:23:12 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:58593 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaJCGXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 02:23:10 -0400
Message-ID: <1412317384.5149.19.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] sched,idle: teach select_idle_sibling about idle
 states
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Date: Fri, 03 Oct 2014 08:23:04 +0200
In-Reply-To: <20141002131548.6cd377d5@cuia.bos.redhat.com>
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org>
	 <1409844730-12273-3-git-send-email-nicolas.pitre@linaro.org>
	 <542B277D.7050103@redhat.com>
	 <alpine.LFD.2.11.1409301904150.5311@knanqh.ubzr>
	 <20141002131548.6cd377d5@cuia.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 13:15 -0400, Rik van Riel wrote:

> Subject: sched,idle: teach select_idle_sibling about idle states
> 
> Change select_idle_sibling to take cpu idle exit latency into
> account.  First preference is to select the cpu with the lowest
> exit latency from a completely idle sched_group inside the CPU;
> if that is not available, we pick the CPU with the lowest exit
> latency in any sched_group.
> 
> This increases the total search time of select_idle_sibling,
> we may want to look into propagating load info up the sched_group
> tree in some way. That information would also be useful to prevent
> the wake_affine logic from causing a load imbalance between
> sched_groups.

A generic boo hiss aimed in the general direction of all of this let's
go look at every possibility on every wakeup stuff.  Less is more.

-Mike

