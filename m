Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab3DMCIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 22:08:18 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51303 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab3DMCIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 22:08:16 -0400
Subject: Re: [PATCH 5/6] tools lib traceevent: Add page_size field to pevent
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1365816410.9609.106.camel@gandalf.local.home>
References: <1365681898-19897-1-git-send-email-namhyung@kernel.org>
	 <1365681898-19897-5-git-send-email-namhyung@kernel.org>
	 <1365691175.9609.33.camel@gandalf.local.home>
	 <1365691255.9609.34.camel@gandalf.local.home>
	 <1365815846.1769.11.camel@leonhard>
	 <1365816410.9609.106.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Apr 2013 11:08:08 +0900
Message-ID: <1365818888.1769.49.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-04-12 (금), 21:26 -0400, Steven Rostedt:
> On Sat, 2013-04-13 at 10:17 +0900, Namhyung Kim wrote:
> 
> > > 
> > > I just want to know more about this patch before I ack it.
> > 
> > The page size of traced system can be different than current system's
> > because the recorded data file might be analyzed in a different machine.
> > In this case we should use original page size of traced system when
> > accessing the data file, so this information needs to be saved.
> 
> I understand that, it's just strange that it's not used anywhere in the
> library, or the patch series (that I can find).
> 
> It would make more sense if another patch used this new interface. I'm
> sure new code will, but the patch should be part of a patch series that
> needs it.

I know you knew that already. :)

I think it only affects trace-cmd as it's the only user that accesses
raw ring-buffer contents for now.  I found it during writing code also
accesses the ring buffer (with kbuffer code) - perf ftrace. :)

But the code is in a very early stage and needs to handle so many things
before posting to the list.  So I just wanted to post a part of the
preparation first.

Thanks,
Namhyung


