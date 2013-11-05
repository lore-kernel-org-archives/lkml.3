Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab3KEQee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 11:34:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab3KEQed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 11:34:33 -0500
Date: Tue, 5 Nov 2013 17:33:41 +0100
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
Message-ID: <20131105163341.GB2460@redhat.com>
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org> <20131102155458.GA6981@redhat.com> <87ob60366m.fsf@sejong.aot.lge.com> <87fvrc35kj.fsf@sejong.aot.lge.com> <20131104155131.GD4440@redhat.com> <20131104162229.GA8921@redhat.com> <87mwlj1tm7.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwlj1tm7.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05, Namhyung Kim wrote:
>
> On Mon, 4 Nov 2013 17:22:29 +0100, Oleg Nesterov wrote:
> >
> > So probably I was wrong and this all needs more thinking. Damn.
>
> :)

Don't laugh at me ;)

> > Perhaps we really need to pass @file/offset, but it is not clear what
> > we can do with bss/anon-mapping.
>
> The @file/offset should work with bss since data in bss is accessed via
> an offset in the program,

Yes, yes, but it is still not clear to me how we can identify the "right"
vma which doesn't cover the .bss address but can be used to calculate the
offset.

Oleg.

