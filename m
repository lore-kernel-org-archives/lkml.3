Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbaCLJAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:00:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50538 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaCLJAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:00:41 -0400
Date: Wed, 12 Mar 2014 10:00:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: fix: remove double calculation in
 fix_small_imbalance
Message-ID: <20140312090035.GM30956@twins.programming.kicks-ass.net>
References: <1394555166-22894-1-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394555166-22894-1-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 05:26:06PM +0100, Vincent Guittot wrote:
> The tmp value has been already calculated in:
> scaled_busy_load_per_task =
> 		(busiest->load_per_task * SCHED_POWER_SCALE) /
> 		busiest->group_power;

You created a little confusion in my brain by saying it was a fix; while
in fact it is an optimization removing duplicate computation.

I've changed the Subject to read:

  sched: Remove double calculation in fix_small_imbalance

