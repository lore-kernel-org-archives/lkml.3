Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab3EIPlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 11:41:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28576 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab3EIPlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 11:41:06 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=DN1rENdJRV0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=CpQRuSp1N3wA:10 a=SBW2huxlqvgepa1BxiMA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368114064.7373.109.camel@gandalf.local.home>
Subject: Re: [PATCH 02/11] [BUGFIX] ftrace, kprobes: Fix a deadlock on
 ftrace_regex_lock
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 09 May 2013 11:41:04 -0400
In-Reply-To: <1368110829.7373.103.camel@gandalf.local.home>
References: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
	 <20130509054417.30398.84254.stgit@mhiramat-M0-7522>
	 <1368110829.7373.103.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-09 at 10:47 -0400, Steven Rostedt wrote:

> > sh-2.05b# echo p vfs_symlink > kprobe_events
> > sh-2.05b# echo vfs_symlink:enable_event:kprobes:p_vfs_symlink_0 > set_ftrace_filter
> > 

> Ouch! I'm surprised I didn't trigger this in my tests. I have lockdep
> enabled, and I did run kprobe testing. I'll have to look at how this was
> missed :-/

OK, now I know why I missed this. My tests never enabled a kprobe event.
I'll have to update them to do so.

Thanks,

-- Steve


