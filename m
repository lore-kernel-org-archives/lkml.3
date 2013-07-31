Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752Ab3GaOHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:07:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4344 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3GaOG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:06:59 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=p_wSJkOgJdAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=vMlpsT2et3MA:10 a=lmjoxpBp869WeTqsC5oA:9 a=QEXdDO2ut3YA:10 a=QJZ2i771jr8A:10 a=hiVlc5aPH8EA:10 a=t3eNqxsjbZ8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375279617.19999.1.camel@gandalf.local.home>
Subject: Re: [for-next-3.11][PATCH 0/8] ftrace/tracing: Event file fixes and
 ftrace function hash fixes
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Wed, 31 Jul 2013 10:06:57 -0400
In-Reply-To: <20130731114722.GA4416@redhat.com>
References: <20130730112718.273490378@goodmis.org>
	 <20130731114722.GA4416@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-31 at 13:47 +0200, Oleg Nesterov wrote:
> On 07/30, Steven Rostedt wrote:
> >
> > Using the i_private and event_mutex
> > to verify that the event still exists to solve the race.
> 
> To remind, we also need the "debugfs: debugfs_remove_recursive() must
> not rely on list_empty(d_subdirs)" patch, otherwise we still have the
> problems with the opened files.

Do these patches depend on that patch? Should I rebase to have that
patch first?

-- Steve

> 
> Just in case, we need this fix even if .open() does trace_array_get()
> or tracing_open_generic_file() (removed by recent changes), rmdir can
> be called before we increment the counter and the deleted dentry breaks
> debugfs_remove_recursive().
> 
> But after the recent changes this fix becomes more important. An opened
> file confuses debugfs_remove_recursive() and after that you can't create
> another probe.


