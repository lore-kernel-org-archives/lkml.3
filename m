Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762078Ab3JPSlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:41:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34255 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761398Ab3JPSlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:41:47 -0400
Date: Wed, 16 Oct 2013 20:41:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ben Segall <bsegall@google.com>
Cc: mingo@redhat.com, pjt@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] sched: Fix cfs_bandwidth misuse of
 hrtimer_expires_remaining
Message-ID: <20131016184144.GH2675@laptop.programming.kicks-ass.net>
References: <20131016181548.22647.17161.stgit@sword-of-the-dawn.mtv.corp.google.com>
 <20131016181617.22647.73829.stgit@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016181617.22647.73829.stgit@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 11:16:17AM -0700, Ben Segall wrote:
> + * Requires cfs_b->lock for hrtimer_expires_remaining to be safe against the
> + * hrtimer base being cleared by __hrtimer_start_range_ns. This is possibly
> + * incorrect if we ever built with CPU_HOTPLUG.

Do clarify; most people build with hotplug enabled; due to wanting
suspend/resume stuff etc..
