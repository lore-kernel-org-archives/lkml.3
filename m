Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaFCCrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 22:47:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:54652 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751549AbaFCCrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 22:47:47 -0400
Date: Mon, 2 Jun 2014 22:47:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Javi Merino <javi.merino@arm.com>
Subject: Re: [PATCH 4/4] tools lib traceevent: Added support for
 __get_bitmask() macro
Message-ID: <20140602224743.22c8cbb1@gandalf.local.home>
In-Reply-To: <87iooiemr5.fsf@sejong.aot.lge.com>
References: <20140516140215.149535442@goodmis.org>
	<20140516140502.628373326@goodmis.org>
	<87iooiemr5.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2014 11:43:26 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> Hi Steve,
> 
> On Fri, 16 May 2014 10:02:19 -0400, Steven Rostedt wrote:
> > @@ -3691,6 +3784,23 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
> >  	case PRINT_BSTRING:
> >  		print_str_to_seq(s, format, len_arg, arg->string.string);
> >  		break;
> > +	case PRINT_BITMASK: {
> > +		int bitmask_offset;
> > +		int bitmask_size;
> > +
> > +		if (arg->bitmask.offset == -1) {
> > +			struct format_field *f;
> > +
> > +			f = pevent_find_any_field(event, arg->bitmask.bitmask);
> > +			arg->bitmask.offset = f->offset;
> > +		}
> > +		bitmask_offset = data2host4(pevent, data + arg->string.offset);
> 
> s/string.offset/bitmask.offset/

Duh, thanks!

-- Steve

> 
> Thanks,
> Namhyung
> 
> 
> > +		bitmask_size = bitmask_offset >> 16;
> > +		bitmask_offset &= 0xffff;
> > +		print_bitmask_to_seq(pevent, s, format, len_arg,
> > +				     data + bitmask_offset, bitmask_size);
> > +		break;
> > +	}

