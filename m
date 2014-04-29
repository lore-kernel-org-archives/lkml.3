Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbaD2RMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:12:24 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:4167 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756660AbaD2RMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:12:23 -0400
Date: Tue, 29 Apr 2014 13:12:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@elte.hu>,
        Michal Hocko <mhocko@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Vojtech Pavlik <vojtech@suse.cz>, Petr Tesarik <ptesarik@suse.cz>,
        Petr Mladek <pmladek@suse.cz>
Subject: Re: 64bit x86: NMI nesting still buggy?
Message-ID: <20140429131220.63069221@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1404291835560.16783@pobox.suse.cz>
References: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz>
	<20140429100345.3f76a5bd@gandalf.local.home>
	<alpine.LNX.2.00.1404291720440.16783@pobox.suse.cz>
	<20140429120908.61ee947f@gandalf.local.home>
	<alpine.LNX.2.00.1404291835560.16783@pobox.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 18:51:13 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:


> Just to be clear here -- I don't have a box that can reproduce this; I 
> whole-heartedly believe that even if there are boxes with this behavior 
> (and I assume there are, otherwise Intel wouldn't be mentioning it in the 
> docs), it'd be hard to trigger on those.

I see your point. But it is documented for those that control both NMIs
and SMMs. As it says in the document: "If the SMI handler requires the
use of NMI interrupts". That to me sounds like a system that has
control over both SMIs *and* NMIs. The BIOS should not have any control
over NMIs, as the OS requires that. And the OS has no control over
SMIs.

That paragraph sounds irrelevant to normal BIOS and OS systems as
neither "owns" both SMIs and NMIs.

I've fought BIOS engineers before, where they would say something like
"Oh! You want to use the second PIT? I'll fix my code. Sorry".

> We were hunting something completely different, and came through this 
> paragraph in the Intel manual, and found it rather scary.

But this is all irrelevant anyway as this is all hypothetical and
there's been no real world bug with this.

-- Steve
