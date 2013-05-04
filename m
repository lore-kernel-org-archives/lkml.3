Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab3EDGhl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 02:37:41 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:50275 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3EDGhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 02:37:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130503165844.GG3780@linux.vnet.ibm.com>
References: <1367599676-2049-1-git-send-email-fweisbec@gmail.com>
	<1367599676-2049-2-git-send-email-fweisbec@gmail.com>
	<20130503165844.GG3780@linux.vnet.ibm.com>
Date: Sat, 4 May 2013 08:37:38 +0200
Message-ID: <CAFTL4hxcmoNV54NG2=xswgvjStYLdOBwi=FP7q_=s0vmp4uTrQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] rcu: Fix full dynticks' dependency on wide RCU nocb mode
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/3 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Fri, May 03, 2013 at 06:47:55PM +0200, Frederic Weisbecker wrote:
>> Commit 0637e029392386e6996f5d6574aadccee8315efa
>> ("nohz: Select wide RCU nocb for full dynticks") intended
>> to force CONFIG_RCU_NOCB_CPU_ALL=y when full dynticks is
>> enabled.
>>
>> However this option is part of a choice menu and Kconfig's
>> "select" instruction has no effect on such targets.
>>
>> Fix this by using reverse dependencies on the targets we
>> don't want instead.
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: Hakan Akkan <hakanakkan@gmail.com>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Kevin Hilman <khilman@linaro.org>
>> Cc: Li Zhong <zhong@linux.vnet.ibm.com>
>> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Nice!

Ingo, if you haven't yet pulled, please rather pick the
"timers/nohz-hz1-v2" branch that has the Reviewed-by: tag from Paul.

Thanks.
