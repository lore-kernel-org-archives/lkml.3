Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab3KHQvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:51:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757794Ab3KHQvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:51:18 -0500
Date: Fri, 8 Nov 2013 17:52:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch
	methods (v6)
Message-ID: <20131108165233.GA28753@redhat.com>
References: <87ob60366m.fsf@sejong.aot.lge.com> <87fvrc35kj.fsf@sejong.aot.lge.com> <20131104155131.GD4440@redhat.com> <20131104162229.GA8921@redhat.com> <20131104184741.GA15945@redhat.com> <87sivbz65t.fsf@sejong.aot.lge.com> <20131105174535.GA6385@redhat.com> <87zjphx6dl.fsf@sejong.aot.lge.com> <20131106162806.GA7089@redhat.com> <87eh6swtra.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eh6swtra.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

sorry for delay.

On 11/07, Namhyung Kim wrote:
>
> >> > As for "-= tu->offset"... Can't we avoid it? User-space needs to calculate
> >> > the "@" argument anyway, why it can't also substruct this offset?
> >>
> >> Hmm.. it makes sense too. :)
> >
> > I am no longer sure ;)
> >
> > This way the "@" argument will look more confusing, it will depend on the
> > address/offset of the probed insn. But again, I do not know, this is up
> > to you.
>
> That said, I'd prefer the original "-= -tu->offset" approach.  It'll
> make debugging easier IMHO.

I do not really mind, and probably you are right. Actually it seems
that I was confused, if user-space does "-= -tu->offset" itself then
the "@" argument will look more consistent (contrary to what I said
above).

In any case we should make the calculation of "@" argument (in user
space) as simple/clear as possible, it is very easy to add the
additional hacks in kernel if necessary.

And this is very (if not most) important part, we can change the kernel
later, but it is not easy to change the already working semantics, so I'd
like to know what other reviewers think.

Oleg.

