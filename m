Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaFJOMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:12:06 -0400
Received: from skprod2.natinst.com ([130.164.80.23]:43178 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751058AbaFJOME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:12:04 -0400
From: "Brad Mouring" <bmouring@ni.com>
Date: Tue, 10 Jun 2014 09:10:47 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>,
        Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 4/7] rtmutex: Siplify remove_waiter()
Message-ID: <20140610141047.GC28502@linuxgetsreal>
References: <20140609201118.387571774@linutronix.de>
 <20140609202336.248536613@linutronix.de>
MIME-Version: 1.0
In-Reply-To: <20140609202336.248536613@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP5|July 31, 2013) at
 06/10/2014 09:10:48 AM,
	Serialize by Router on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP5|July 31, 2013) at
 06/10/2014 09:10:48 AM,
	Serialize complete at 06/10/2014 09:10:48 AM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-10_05:2014-06-10,2014-06-10,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 08:28:08PM -0000, Thomas Gleixner wrote:
> Exit right away, when the removed waiter was not the top prioriy
> waiter on the lock. Get rid of the extra indent level.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/locking/rtmutex.c |   26 ++++++++++----------------
>  1 file changed, 10 insertions(+), 16 deletions(-)
> 
> Index: tip/kernel/locking/rtmutex.c
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex.c
> +++ tip/kernel/locking/rtmutex.c
> @@ -780,7 +780,7 @@ static void remove_waiter(struct rt_mute
>  {
>  	int first = (waiter == rt_mutex_top_waiter(lock));

I agree that @first is ambiguous and would prefer something like
@is_top_waiter

Reviewed-by: Brad Mouring <brad.mouring@ni.com>
