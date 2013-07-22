Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab3GVRKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:10:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757501Ab3GVRKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:10:08 -0400
Date: Mon, 22 Jul 2013 19:04:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>, jovi.zhangwei@huawei.com,
        Jiri Olsa <jolsa@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH V2] tracing: Check f_dentry before accessing
	event_file/call in inode->i_private
Message-ID: <20130722170442.GA27002@redhat.com>
References: <20130705003223.GA4981@redhat.com> <20130709075519.2583.96462.stgit@mhiramat-M0-7522> <20130715181659.GA18505@redhat.com> <51E5FD33.4040604@hitachi.com> <20130717145148.GB7358@redhat.com> <51E750F4.5070200@hitachi.com> <20130718145137.GA6014@redhat.com> <51E8CCC0.7030404@hitachi.com> <20130719133327.GA21278@redhat.com> <51ED0227.6020204@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ED0227.6020204@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Masami Hiramatsu wrote:
>
> (2013/07/19 22:33), Oleg Nesterov wrote:
> > My only point, imho this is more complex than necessary.
>
> I see, so I'd like to see the fix. However, I'm not sure
> we have enough time to fix that cleanly.

I promise, tomorrow I'll re-send the RFC patches, so if you don't
like them we can switch back to refcounting.

Sorry for delay. Today I was busy with other bugs I "found" in
subsystem_open/etc code, but when I tried to fix them I realized
that I have misread this code.

> Note that except
> for the timing bug, we still leave a kernel bug which can
> easily be reproduced as Jovi reported.

Could you please remind ?

> >> OK, let me confirm that, would you mean we still need 2/4 - 4/4?
> >
> > Yes, yes.
>
> And those are depends on 1/4...

Not at all or I missed something (quite possible). Just 2/4 should
not check ->flags, of course. 3/4 looks "obviously fine", 4/4 was
already merged.

Oleg.

