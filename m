Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab3IYS0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:26:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:38720 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750814Ab3IYS0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:26:47 -0400
Date: Wed, 25 Sep 2013 14:26:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Zoltan Kiss <zoltan.kiss@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCHv2] tracing/events: Add bounce tracing to swiotbl
Message-ID: <20130925142640.6c2f1ee0@gandalf.local.home>
In-Reply-To: <20130925175649.GC7253@phenom.dumpdata.com>
References: <1378325465-10384-1-git-send-email-zoltan.kiss@citrix.com>
	<5239CF01.1010001@citrix.com>
	<20130925175649.GC7253@phenom.dumpdata.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013 13:56:49 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> .. snip..
> > >+	TP_printk("dev_name: %s dma_mask=%llx dev_addr=%llx "
> > >+		"size=%zu swiotlb_force=%x",
> > >+		__get_str(dev_name),
> > >+		__entry->dma_mask,
> > >+		(unsigned long long)__entry->dev_addr,
> > >+		__entry->size,
> > >+		__entry->swiotlb_force)
> 
> Would it make sense to do something like this:
> 
> 		__entry->swiotlb_force ? "swiotlb_force" : "")

I think that's fine. I do believe that the libtraceevents can parse the
"?:" syntax.

-- Steve
