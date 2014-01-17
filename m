Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaAQJzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:55:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58618 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaAQJzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:55:07 -0500
Date: Fri, 17 Jan 2014 10:54:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org, mingo@redhat.com,
        chegu_vinod@hp.com, mgorman@suse.de, Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH 6/6] numa,sched: normalize faults_from stats and weigh by
 CPU use
Message-ID: <20140117095459.GF11314@laptop.programming.kicks-ass.net>
References: <1389939456-9541-1-git-send-email-riel@redhat.com>
 <1389939456-9541-7-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389939456-9541-7-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 01:17:36AM -0500, riel@redhat.com wrote:
> +			/*
> +			 * Normalize the faults_from, so all tasks in a group
> +			 * count according to CPU use, instead of by the raw
> +			 * number of faults. This prevents the situation where
> +			 * the garbage collector totally dominates the stats,
> +			 * and the access patterns of the worker threads are
> +			 * ignored.
> +			 */

Instead of focusing on the one example (GC) here, I would suggest
saying something along the lines of: Tasks with little runtime have
little over-all impact on throughput and thus their faults are less
important.
