Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab3EJBkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 21:40:18 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:46429 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab3EJBkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 21:40:16 -0400
Message-ID: <518C4FFD.1090404@hitachi.com>
Date: Fri, 10 May 2013 10:40:13 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Subject: Re: [PATCH 02/11] [BUGFIX] ftrace, kprobes: Fix a deadlock on ftrace_regex_lock
References: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>  <20130509054417.30398.84254.stgit@mhiramat-M0-7522>  <1368116860.7373.118.camel@gandalf.local.home>  <1368117277.7373.119.camel@gandalf.local.home> <1368119312.7373.123.camel@gandalf.local.home>
In-Reply-To: <1368119312.7373.123.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/05/10 2:08), Steven Rostedt wrote:
> On Thu, 2013-05-09 at 12:34 -0400, Steven Rostedt wrote:
>> On Thu, 2013-05-09 at 12:27 -0400, Steven Rostedt wrote:
>>
>>> We probably should have a better way to initialize this. As there are 26
>>> ftrace_ops currently in the kernel (and this patch doesn't cover all of
>>> them). Maybe have the first time its registered to initialize it.

Oh, I missed many of them :(

>> Crap, but it can be used before that. Hmm, I guess all ftrace functions
>> will need to check that flag first. We do something similar for rt_mutex
>> in -rt.
> 
> I added this on top of your patch. I kept the INIT_REGEX_LOCK as it's
> only local to ftrace.c and wont spread further. Also, the
> ftrace_list_end ftrace_ops is just a place holder (needed for race
> conditions that can have function tracers call its stub), so it does not
> need to be initialized. If anything tries to grab its mutex, that's a
> bug anyway.
> 
> What do you think?

Hmm, would we really need to have the additional flag?
I mean, do we better force ftrace user to use ftrace_ops_init before
calling such functions as mutex itself does?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


