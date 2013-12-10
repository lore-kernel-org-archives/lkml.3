Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3LJQIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:08:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53715 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab3LJQIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:08:21 -0500
Date: Tue, 10 Dec 2013 17:08:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dvhart@linux.intel.com,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, scott.norton@hp.com,
        tom.vaden@hp.com, aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Subject: Re: [PATCH v2 4/4] futex: Avoid taking hb lock if nothing to wakeup
Message-ID: <20131210160801.GL12849@twins.programming.kicks-ass.net>
References: <1386063927-6545-1-git-send-email-davidlohr@hp.com>
 <1386063927-6545-5-git-send-email-davidlohr@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386063927-6545-5-git-send-email-davidlohr@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 01:45:27AM -0800, Davidlohr Bueso wrote:
> With the new atomic counter we only enlarge the futex_hash_bucket struct
> by 4 bytes on 32bit systems, and it is left the same size for 64bit
> ones, at 24 bytes.

patch 2 grew the structure to be an entire cacheline, this now seems a
rather pointless comment ;-)
