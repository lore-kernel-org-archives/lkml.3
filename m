Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3HVQmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:42:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29510 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab3HVQmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:42:14 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=2pwTbst9ur4A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6iCyjPme-SgA:10 a=3nbZYyFuAAAA:8 a=57SyGIRnAAAA:8 a=wsL-10SuGl1287m0-QQA:9 a=CjuIK1q_8ugA:10 a=EvKJbDF4Ut8A:10 a=TIV7c6GJmisA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 22 Aug 2013 12:42:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 10/13] tracing/uprobes: Fetch args before reserving a
 ring buffer
Message-ID: <20130822124212.328c09c7@gandalf.local.home>
In-Reply-To: <5204BCE6.2070102@hitachi.com>
References: <1376037909-17797-1-git-send-email-namhyung@kernel.org>
	<1376037909-17797-11-git-send-email-namhyung@kernel.org>
	<5204BCE6.2070102@hitachi.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Aug 2013 18:56:54 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2013/08/09 17:45), Namhyung Kim wrote:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > Fetching from user space should be done in a non-atomic context.  So
> > use a temporary buffer and copy its content to the ring buffer
> > atomically.
> > 
> > While at it, use __get_data_size() and store_trace_args() to reduce
> > code duplication.
> 
> I just concern using kmalloc() in the event handler. For fetching user
> memory which can be swapped out, that is true. But most of the cases,
> we can presume that it exists on the physical memory.
> 


What about creating a per cpu buffer when uprobes are registered, and
delete them when they are finished? Basically what trace_printk() does
if it detects that there are users of trace_printk() in the kernel.
Note, it does not deallocate them when finished, as it is never
finished until reboot ;-)

-- Steve
