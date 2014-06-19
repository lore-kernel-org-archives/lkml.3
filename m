Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966502AbaFSXgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:36:39 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:42975 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965603AbaFSXgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:36:38 -0400
Date: Thu, 19 Jun 2014 19:36:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC][PATCH 0/3] x86/nmi: Print all cpu stacks from NMI safely
Message-ID: <20140619193635.1949b469@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1406200123220.15014@pobox.suse.cz>
References: <20140619213329.478113470@goodmis.org>
	<alpine.LNX.2.00.1406192349400.15014@pobox.suse.cz>
	<20140619185810.4137e14b@gandalf.local.home>
	<alpine.LNX.2.00.1406200100520.15014@pobox.suse.cz>
	<20140619191923.1365850a@gandalf.local.home>
	<alpine.LNX.2.00.1406200123220.15014@pobox.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014 01:27:26 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> 
> I don't think there is a need for a global stop_machine()-like 
> synchronization here. The printing CPU will be sending IPI to the CPU N+1 
> only after it has finished printing CPU N stacktrace.

So you plan on sending an IPI to a CPU then wait for it to acknowledge
that it is spinning, and then print out the data and then tell the CPU
it can stop spinning?

-- Steve
