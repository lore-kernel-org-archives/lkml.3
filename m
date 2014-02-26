Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaBZWfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:35:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34778 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaBZWfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:35:13 -0500
Date: Wed, 26 Feb 2014 23:35:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Regression with wait_event_timeout in next-20140226
Message-ID: <20140226223500.GW9987@twins.programming.kicks-ass.net>
References: <530E17C7.1030504@free-electrons.com>
 <20140226165043.GA22802@laptop.programming.kicks-ass.net>
 <20140226142534.3b8c6eb1652d000206948ae0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226142534.3b8c6eb1652d000206948ae0@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 02:25:34PM -0800, Andrew Morton wrote:
> Is there anything we can do to make all this clearer?  Simply using a
> distinctive variable name ("__wait_var__"?) in place of __ret (and
> documenting it) would help a lot.

% s/\<__ret\>/__wait_var__/g should get you mostly there I suppose :-)

Although I'm not entirely sure __wait_var__ is a better name.

> Some __ret's are long and some are int.  Maybe that's a glitch, 

No that's on purpose.

The longs are needed to hold the timeout values, we truncate to an int
where we only need to return errors.

> maybe
> it's because some __ret's are used for inter-macro communications and
> some are not, which just makes things worse.

The timeout related ones are the worst. The others aren't nearly as bad.

> I started to do a patch, got all confused and gave up.  We've made
> quite a tangly mess in there, alas.

Hehe, yes, made a lot of duplicated code go away though. Maybe we
compressed too much, dunno.
