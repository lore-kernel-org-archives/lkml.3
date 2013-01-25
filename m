Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3AYBDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 20:03:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15646 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3AYBDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 20:03:31 -0500
X-Authority-Analysis: v=2.0 cv=QcjkT7nv c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=EdCCnysJoiIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=5Y64mutqEVMA:10 a=7qPsMVoVnAAGUWNiYWoA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359075809.21576.182.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] mutex: use spin_[un]lock instead of
 arch_spin_[un]lock
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 24 Jan 2013 20:03:29 -0500
In-Reply-To: <20130124165623.cba62f07.akpm@linux-foundation.org>
References: <1359019365-23646-1-git-send-email-yuanhan.liu@linux.intel.com>
	 <1359019365-23646-2-git-send-email-yuanhan.liu@linux.intel.com>
	 <20130124161413.a3903fa4.akpm@linux-foundation.org>
	 <1359075057.21576.181.camel@gandalf.local.home>
	 <20130124165623.cba62f07.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 16:56 -0800, Andrew Morton wrote:
>  
> > Actually this perhaps hurts lockdep. We want to keep the
> > arch_spin_(un)lock() versions because each spin_lock() and spin_unlock()
> > needs to be verified by lockdep. Lockdep also verifies mutex locks. But
> > with this change, for every mutex, it's going to also analyze a
> > spin_lock and spin_unlock twice each (one for mutex lock and one for
> > unlock). As this is just locking the mutex internals, it may not be
> > necessary to debug it via lockdep. Hence we probably want to keep the
> > arch_* version.
> 
> In what way is this actually a problem?  lockdep will have more work to
> do (and given the frequency of mutex_lock/unlock, that overhead may be
> significant).  Anything else?

Ingo probably can answer this better than I can. I'll let him do it when
he wakes up tomorrow.

-- Steve


