Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaAMPqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:46:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59215 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaAMPqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:46:15 -0500
Date: Mon, 13 Jan 2014 16:45:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86: Fix active_entry initialization
Message-ID: <20140113154555.GR31570@twins.programming.kicks-ass.net>
References: <1389176153-3128-2-git-send-email-eranian@google.com>
 <tip-f3ae75de98c4bac145a87d830c156c96f9414022@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-f3ae75de98c4bac145a87d830c156c96f9414022@git.kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 10:42:47AM -0800, tip-bot for Stephane Eranian wrote:
> -	union {
> -		struct hlist_node	hlist_entry;
> -		struct list_head	active_entry;
> -	};
> +	struct hlist_node		hlist_entry;
> +	struct list_head		active_entry;

Fwiw, we could probably stick both of those in hw_perf_event.

the software event's hrtimer isn't the biggest entry anymore, so we
could add the hlist_entry in there, and we can start a new entry for
RAPL events.
