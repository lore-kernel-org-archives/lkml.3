Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaCKCln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 22:41:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955AbaCKCll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 22:41:41 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not set via debugfs
References: <20140307150920.881849073@goodmis.org>
	<20140307151202.210588176@goodmis.org>
	<241011797.35066.1394481694124.JavaMail.zimbra@efficios.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Mon, 10 Mar 2014 22:41:31 -0400
In-Reply-To: <241011797.35066.1394481694124.JavaMail.zimbra@efficios.com> (Mathieu Desnoyers's message of "Mon, 10 Mar 2014 20:01:34 +0000 (UTC)")
Message-ID: <y0mr469e9t0.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi -


>> From: Steven Rostedt <rostedt@goodmis.org>
>> 
>> Tracepoints were made to allow enabling a tracepoint in a module before that
>> module was loaded. When a tracepoint is enabled and it does not exist, the
>> name is stored and will be enabled when the tracepoint is created.
>> 
>> The problem with this approach is that when a tracepoint is enabled when
>> it expects to be there, it gives no warning that it does not exist.

So it is a deferred-activation kind of call, with no way of knowing
when or if the tracepoints will start coming in.  Why is that
supported at all, considering that clients could monitor modules
coming & going via the module_notifier chain, and update registration
at that time?


>> +	entry = get_tracepoint(name);
>> +	/* Make sure the entry was enabled */
>> +	if (!entry || !entry->enabled)
>> +		ret = -ENODEV;

For what it's worth, I agree with Mathieu that this sort of successful
failure result code is a problem for tracking what needs cleanup and
what doesn't.  (In systemtap's case, if this change gets merged, we'll
have to treat -ENODEV as if it were 0.)


- FChE
