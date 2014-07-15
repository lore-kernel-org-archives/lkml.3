Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081AbaGONEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:04:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:22989 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758827AbaGONEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:04:48 -0400
Date: Tue, 15 Jul 2014 09:04:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: fweisbec@gmail.com, mingo@redhat.com, jovi.zhangwei@huawei.com,
        namhyung.kim@lge.com, tom.zanussi@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] tracing: let user specify tracing_thresh after
 selecting function_graph
Message-ID: <20140715090436.1d660119@gandalf.local.home>
In-Reply-To: <20140715092719.GB5127@stfomichev-desktop.yandex.net>
References: <1401815569-10513-1-git-send-email-stfomichev@yandex-team.ru>
	<20140603185720.79552fb8@gandalf.local.home>
	<20140604133350.GC26511@stfomichev-desktop.yandex.net>
	<20140604154149.3c2857dc@gandalf.local.home>
	<20140605073839.GG26511@stfomichev-desktop.yandex.net>
	<20140715092719.GB5127@stfomichev-desktop.yandex.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014 13:27:19 +0400
Stanislav Fomichev <stfomichev@yandex-team.ru> wrote:

> Hi Steven,
> 
> Did you have some spare time to check why I'm getting triple fault with the
> jump labels inside function tracers? Or will you just pull my another
> patch without them?

No, I don't want the overhead of that check if it isn't needed. You
don't need to put a jump label in there either.

Just create another ftrace_ops function that we can update that does
the check when the function is needed. Look at what happens when
someone sets the set_ftrace_pid file.

-- Steve
