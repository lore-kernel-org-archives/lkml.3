Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbaGNO1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:27:33 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:41146 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbaGNO1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:27:10 -0400
Date: Mon, 14 Jul 2014 10:27:07 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1 V2] workqueue: remove the del_timer_sync()s in
 maybe_create_worker()
Message-ID: <20140714142707.GB31610@htj.dyndns.org>
References: <1405265479-827-1-git-send-email-laijs@cn.fujitsu.com>
 <1405325601-12437-1-git-send-email-laijs@cn.fujitsu.com>
 <1405325601-12437-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405325601-12437-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jul 14, 2014 at 04:13:21PM +0800, Lai Jiangshan wrote:
> It is said in the document that the timer which is being
> deleted by del_timer_sync() should not be restarted:
>   Synchronization rules: Callers must prevent restarting of
>   the timer, otherwise this function is meaningless.
> 
> Repeating timer may cause the del_timer_sync() spin longer,
> or even spin forever in very very very very extreme condition.

I'm fairly sure del_timer_sync() can delete self-requeueing timers.
The implementation busy-waits if the queued timer is the currently
executing one and dequeues only while the timer isn't running which
should be able to handle self-requeueing ones just fine.  Thomas,
del_timer_sync() can reliably delete self-requeueing ones, right?

Thanks.

-- 
tejun
