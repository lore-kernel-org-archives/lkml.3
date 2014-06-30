Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbaF3Stw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:49:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbaF3Stv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:49:51 -0400
Date: Mon, 30 Jun 2014 20:48:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] tracing/uprobes: Revert "Support mix of ftrace and
	perf"
Message-ID: <20140630184828.GA24594@redhat.com>
References: <20140627170116.GA18298@redhat.com> <20140627170136.GA18319@redhat.com> <87k37z54lu.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k37z54lu.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

On 06/30, Namhyung Kim wrote:
>
> On Fri, 27 Jun 2014 19:01:36 +0200, Oleg Nesterov wrote:
> >
> > This would be easy to fix, but there are other reasons why it is not
> > simple to mix ftrace and perf. If nothing else, they can't share the
> > same ->consumer.filter. This is fixable too, but probably we need to
> > fix the poorly designed uprobe_register() interface first. At least
> > "register" and "apply" should be clearly separated.
>
> Hmm.. right.  It seems the current filter logic only cares about the
> perf.  If ftrace comes after perf, it might not see some events due to
> the filter, right?

Yes. Or vice versa, ftrace can miss the events because perf can return
UPROBE_HANDLER_REMOVE. Or ftrace can come after perf, but in this case
it should call uprobe_apply() or it won't add the new breakpoints.

Actually, I'll probably try to make the patch tomorrow. It looks simple
enough, the main complication is CONFIG_PERF. And, to keep this patch
simple, I won't try to optimize (say) the TP_FLAG_TRACE-comes-first
case which could avoid uprobe_apply().

Yes, I still think it would be better to change the register/unregister
API first, but I do not know when I do this ;)

> > Cc: stable@vger.kernel.org # v3.14
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks!

Oleg.

