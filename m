Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaBJOJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:09:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:38071 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751449AbaBJOJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:09:54 -0500
Date: Mon, 10 Feb 2014 09:09:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, raistlin@linux.it, juri.lelli@gmail.com,
        clark.williams@gmail.com, mingo@redhat.com
Subject: Re: [PATCH 1/3] sched: Move the priority specific bits into a new
 header file.
Message-ID: <20140210090948.02266f38@gandalf.local.home>
In-Reply-To: <52F83FE2.90004@cn.fujitsu.com>
References: <cover.1390859827.git.yangds.fnst@cn.fujitsu.com>
	<f7549508a1588da2c613d601748ca9de30fa5dcf.1390859827.git.yangds.fnst@cn.fujitsu.com>
	<87fvo75pci.fsf@sejong.aot.lge.com>
	<52F83FE2.90004@cn.fujitsu.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014 10:56:34 +0800
Dongsheng Yang <yangds.fnst@cn.fujitsu.com> wrote:

> >> diff --git a/include/linux/sched.h b/include/linux/sched.h
> >> index 68a0e84..ba1b732 100644
> >> --- a/include/linux/sched.h
> >> +++ b/include/linux/sched.h
> >> @@ -3,6 +3,10 @@
> >>   
> >>   #include <uapi/linux/sched.h>
> >>   
> >> +#ifndef _SCHED_PRIO_H
> >> +#include <linux/sched/prio.h>
> >> +#endif /* #ifndef _SCHED_PRIO_H */
> > It seems you don't need to use #ifndef-#endif pair to include a header
> > file?
> 
> Sorry for the late reply, coming back from vacation for Chinese Spring 
> Festival.
> 
> The reason I use #ifndef-#endif here is that there are lots of files,
>   such as kernel/sched/sched.h, are including <linux/sched.h> and
> <linux/sched/rt.h>. And both of them are including prio.h.
> 
> I am not sure should we avoid reincluding a file and how.
> 
> Could you help to give me some suggestion of it. Thanx :)


That's why you have:

+++ b/include/linux/sched/prio.h
@@ -0,0 +1,23 @@
+#ifndef _SCHED_PRIO_H
+#define _SCHED_PRIO_H

The first time a header gets included, it checks if _SCHED_PRIO_H is
defined, if not, it defines it and continues. Otherwise it skips the
content of the file.

This is so standard practice that CPP (C Pre-Processor) optimizes this
by checking if this exists and caches it. It wont even open the file
the second time it sees it included.

-- Steve
