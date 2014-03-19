Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaCSTeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:34:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43318 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaCSTeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:34:16 -0400
Date: Wed, 19 Mar 2014 20:34:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org,
        Steve French <sfrench@samba.org>, Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        uobergfe@redhat.com
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work queues
Message-ID: <20140319193407.GA11257@laptop.programming.kicks-ass.net>
References: <20140319151252.16ed3ac6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319151252.16ed3ac6@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 03:12:52PM -0400, Steven Rostedt wrote:
> My question to Tejun is, if we create another workqueue, to add the
> rdata->work to, would that prevent the above problem? Or what other
> fixes can we do?

The way I understand workqueues is that we cannot guarantee concurrency
like this. It tries, but there's no guarantee.

WQ_MAX_ACTIVE seems to be a hard upper limit of concurrent workers. So
given 511 other blocked works, the described problem will always happen.

Creating another workqueue doesn't actually create more threads.

There is the kthread_work stuff for if you want a guaranteed worker
thread.
