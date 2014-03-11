Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaCKOqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:46:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:16764 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750967AbaCKOqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:46:07 -0400
Date: Tue, 11 Mar 2014 10:46:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
Message-ID: <20140311104602.151bfdb3@gandalf.local.home>
In-Reply-To: <288254692.35226.1394510907402.JavaMail.zimbra@efficios.com>
References: <20140307150920.881849073@goodmis.org>
	<20140307151202.210588176@goodmis.org>
	<241011797.35066.1394481694124.JavaMail.zimbra@efficios.com>
	<y0mr469e9t0.fsf@fche.csb>
	<20140310225820.0f02025d@gandalf.local.home>
	<288254692.35226.1394510907402.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014 04:08:27 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

 
> > That's my argument.
> 
> So basically, all we'd have to do in LTTng is to add a hash table tracking the
> tracepoint probes which are registered, but for which there are no
> tracepoint call sites. Whenever registration of a probe would fail due to
> -ENODEV (assuming we unregister the probe within tracepoint.c when we return
> -ENODEV, as you initially proposed), we would put this probe in the hash table.
> Upon module coming, we would iterate on the module's tracepoints and check
> if any of those match the content of the hash table, and then register the
> probe.
> 
> I guess I'd prefer that to the weird successful failure return value in
> tracepoint.c.
> 

OK, then I'll add back in the removal of the tracepoint on this error.
Then your LTTng module can handle the tracepoints that don't exist yet.

-- Steve
