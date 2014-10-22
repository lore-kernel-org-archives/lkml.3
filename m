Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745AbaJVKbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:31:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:57242 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaJVKbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:31:07 -0400
Date: Wed, 22 Oct 2014 12:31:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, pjt@google.com,
        bsegall@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [RESEND PATCH 3/3 v5] sched: Remove task and group entity
 load_avg when they are dead
Message-ID: <20141022103102.GI12706@worktop.programming.kicks-ass.net>
References: <1412907717-2871-1-git-send-email-yuyang.du@intel.com>
 <1412907717-2871-4-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412907717-2871-4-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 10:21:57AM +0800, Yuyang Du wrote:
> When task exits or group is destroyed, the entity's load_avg should be
> removed from its parent cfs_rq's load_avg. Otherwise, it will take time
> for the parent cfs_rq to decay the dead entity's load_avg to 0, which
> is not desired.

Right, this is something pjt wanted to do ever since we got that
callback in for dl. Nice.
