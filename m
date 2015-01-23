Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbbAWIqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:46:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbbAWIqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:46:04 -0500
Date: Fri, 23 Jan 2015 09:45:51 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Wang Nan <wangnan0@huawei.com>
Cc: jeremie.galarneau@efficios.com, rostedt@goodmis.org, bigeasy@linutronix.de,
        lizefan@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] perf: convert: fix duplicate field names and
 avoid reserved keywords.
Message-ID: <20150123084551.GB2709@krava.brq.redhat.com>
References: <1421904958-24106-1-git-send-email-wangnan0@huawei.com>
 <1421905003-24242-1-git-send-email-wangnan0@huawei.com>
 <20150122132734.GB2473@krava.brq.redhat.com>
 <54C1AAA1.4000300@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54C1AAA1.4000300@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 09:57:53AM +0800, Wang Nan wrote:
> On 2015/1/22 21:27, Jiri Olsa wrote:
> > On Thu, Jan 22, 2015 at 01:36:43PM +0800, Wang Nan wrote:
> >> (If Steven Rostedt accept the previous patch which introduce a priv
> >>  field to 'struct format_field', we can use a relative simple method
> >>  for name conversion. If not , perf must track name conversion by
> >>  itself.)
> >>
> >> Some parameters of syscall tracepoints named as 'nr', 'event', etc.
> >> When dealing with them, perf convert to ctf meets some problem:
> >>
> >>  1. If a parameter with name 'nr', it will duplicate syscall's
> >>     common field 'nr'. One such syscall is io_submit().
> >>
> >>  2. If a parameter with name 'event', it is denied to be inserted
> >>     because 'event' is a babeltrace keywork. One such syscall is
> >>     epoll_ctl.
> >>
> >> This patch appends '_dupl_X' suffix to avoid problem 1, prepend a '_'
> >> prefix to avoid problem 2.
> > 
> > I've got compilation error:
> > 
> > util/data-convert-bt.c: In function ‘event_class_add_field’:
> > util/data-convert-bt.c:629:2: error: suggest parentheses around assignment used as truth value [-Werror=parentheses]
> >   while (t = bt_ctf_event_class_get_field_by_name(event_class, name)) {
> > 
> > what's your gcc version? mine's caught that..
> > 
> 
> I also curious why you got so many Werror problems I'm not ever seen,
> until I found a '-w' in my gcc options, which is introduced by your commit
> 
> 47810c1d429bc690e1f5e9467697538921962171: perf data: Disable Werror convert object.
> 
> I'll revert that commit in my tree.

that one was to workaround the regression in babeltrace,
I'm now using sane babeltrace HEAD as advertized by Jeremie:

"In the meantime, testing against Babeltrace master 3baf0856 should be alright."

jirka
