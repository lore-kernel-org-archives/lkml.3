Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3KWJZh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 04:25:37 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:15756 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751070Ab3KWJZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 04:25:31 -0500
Date: Sat, 23 Nov 2013 04:25:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 12/22] tools lib traceevent: Add scsi plugin
Message-ID: <20131123042529.2d9351b4@gandalf.local.home>
In-Reply-To: <1385133890.1747.101.camel@leonhard>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	<1385031680-9014-13-git-send-email-jolsa@redhat.com>
	<1385133890.1747.101.camel@leonhard>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Nov 2013 00:24:50 +0900
Namhyung Kim <namhyung@kernel.org> wrote:


> [SNIP]
> > +static const char *
> > +scsi_trace_rw6(struct trace_seq *p, unsigned char *cdb, int len)
> > +{
> > +	const char *ret = p->buffer + p->len;
> > +	sector_t lba = 0, txlen = 0;
> > +
> > +	lba |= ((cdb[1] & 0x1F) << 16);
> > +	lba |=  (cdb[2] << 8);
> > +	lba |=   cdb[3];
> > +	txlen = cdb[4];
> > +
> > +	trace_seq_printf(p, "lba=%llu txlen=%llu",
> > +			 (unsigned long long)lba, (unsigned long long)txlen);
> > +	trace_seq_putc(p, 0);
> 
> Why is this _putc(0) needed?  It seems you added it to all other
> functions too.

This is because these are copied directly from the kernel, and the
kernel versions use the putc(0) too. But there, it is needed, as its up
to the helper function to terminate the trace_seq.

I need to add trace_seq_terminate() in the kernel (it's in
libtraceevent), so that we can replace the putc(0) with terminate, and
not truncate the seq early.

-- Steve


> 
> 
> > +	return ret;
> > +}
> > +
> 
> 

