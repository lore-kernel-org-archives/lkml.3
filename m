Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaAOOLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:11:53 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:16211 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752061AbaAOOLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:11:52 -0500
Date: Wed, 15 Jan 2014 09:11:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Petr Mladek <pmladek@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v6 3/8] x86: add generic function to modify more calls
 using int3 framework
Message-ID: <20140115091149.7525db07@gandalf.local.home>
In-Reply-To: <52D64439.5040800@hitachi.com>
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
	<1386690140-19941-4-git-send-email-pmladek@suse.cz>
	<20140114193338.4375f205@gandalf.local.home>
	<52D64439.5040800@hitachi.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 17:18:01 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

  
> >> +static char bp_int3;
> > 
> > bp_int3 is not going to be anything but 0xcc. Let's change that to:
> > 
> > static char bp_int3 = 0xcc;
> > 
> > And remove the other initializations.
> 
> just a comment.
> If it is always 0xcc, it should be a const variable.
> 

Yeah, I was thinking that too. As long as sizeof(bp_int3) still works,
which it should for just adding a "const", and not make it a macro.

static const bp_int3 = 0xcc;

Thanks!

-- Steve
