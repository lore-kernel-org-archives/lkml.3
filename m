Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaIPVdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:33:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:17533 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752512AbaIPVda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:33:30 -0400
Date: Tue, 16 Sep 2014 17:33:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kara <jack@suse.cz>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140916173328.6306a5c2@gandalf.local.home>
In-Reply-To: <20140916212250.GI1205@quack.suse.cz>
References: <20140914050905.GA296@x4>
	<20140914055450.GB296@x4>
	<CAMuHMdUmqvN3GZzfjjHc5W2Dxgx2b0gzVHFUR8P8yUs5iFt_tA@mail.gmail.com>
	<20140915163740.GA12408@x4>
	<20140916105547.GA1205@quack.suse.cz>
	<20140916144252.GB32118@x4>
	<20140916111331.14303381@gandalf.local.home>
	<20140916203510.GF1205@quack.suse.cz>
	<20140916170709.73ef2993@gandalf.local.home>
	<20140916212250.GI1205@quack.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014 23:22:50 +0200
Jan Kara <jack@suse.cz> wrote:

> > For the most part it's a blocking write. Yeah, if another CPU is
> > writing, it wont be a blocking write, but it usually is, I know I
> > depend on it (when I'm debugging, I usually don't have contention
> > between CPUs). The important part is that they are done in order. A
> > delayed print, wont be in order with other printks. That is still a
> > crucial difference.
>   printk_deffered() will be in order with other printks after your commit
> 458df9fd4815b47809875d57f42e16401674b621. Just printing to console itself
> will be delayed to the next timer interrupt. Or am I missing something?

Hehe, you're right. I blame the meds for forgetting this.

Yeah, my update will put the data in order. Thus I guess I agree with
your assessment. We probably don't need the "sched_delayed" anymore.

OK, you convinced me, but I still like to hear Peter's view on this
before we commit it.

For Markus's patch:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
