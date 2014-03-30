Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaC3RT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 13:19:59 -0400
Received: from one.firstfloor.org ([193.170.194.197]:32899 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaC3RT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 13:19:58 -0400
Date: Sun, 30 Mar 2014 19:19:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2 10/29] ktap: add string handling
 code(kernel/trace/ktap/kp_[str|mempool].[c|h])
Message-ID: <20140330171957.GF22728@two.firstfloor.org>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
 <1396017924-7754-11-git-send-email-jovi.zhangwei@gmail.com>
 <20140330035009.GB22728@two.firstfloor.org>
 <CAGdX0WHK-EhGYHELxr-H_A+w1ZDWWhDpxsvB+=grMgFNpFsZ4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdX0WHK-EhGYHELxr-H_A+w1ZDWWhDpxsvB+=grMgFNpFsZ4g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> See test/benchmark/cmp_table.sh, that script compare

Is that a realistic tracing scenario?

> table operation between ktap with stap, the result is very
> inspiring, ktap table operation overhead is quite lower than
> stap, especially when use constant string key.

Ok fair enough.

> 
> But I agree with you partly, because in some cases we don't
> want/need to interning all string, for example:
>     trace xxx:yyy {
>         var str = cast("char *", arg1)
>         print(str)
>     }
> 
> In above case, arg1 is a long kernel string, and no table insert,
> so definitely no need to interned, so we need to add
> KTAP_TRAWSTR to represent these values.

Please don't make it more complicated. If there's a good rationale
for interning it' ok to use always.

It would be better to find ways to simplify things.

-Andi
