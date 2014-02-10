Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbaBJR7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:59:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55767 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbaBJR67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:58:59 -0500
Date: Mon, 10 Feb 2014 18:58:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org, will.deacon@arm.com, dave.martin@arm.com,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 4/7] perf: be less pessimistic when scheduling events
Message-ID: <20140210175854.GB27965@twins.programming.kicks-ass.net>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
 <1392054264-23570-5-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392054264-23570-5-git-send-email-mark.rutland@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 05:44:21PM +0000, Mark Rutland wrote:
> This patch makes ctx_flexible_sched_in attempt to schedule every group
> in the flexible_groups list even when earlier groups failed to schedule,
> enabling more groups to be scheduled simultaneously.

Since you're basically free to create as many events as you want, you can
(as an unprivilidged user) make the context switch to and from your task
arbitrarily expensive.

So no, that's not going to fly.
