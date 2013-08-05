Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3HEGb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:31:59 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36186 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752566Ab3HEGb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:31:58 -0400
Message-ID: <1375684317.3133.25.camel@joe-AO722>
Subject: Re: [PATCH 13/13] tracing/probes: Fix basic print type functions
From: Joe Perches <joe@perches.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Stev Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Sun, 04 Aug 2013 23:31:57 -0700
In-Reply-To: <51FF4492.8080100@hitachi.com>
References: <1375261410-11219-1-git-send-email-namhyung@kernel.org>
	 <1375261410-11219-14-git-send-email-namhyung@kernel.org>
	 <51FF4492.8080100@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 15:22 +0900, Masami Hiramatsu wrote:
> (2013/07/31 18:03), Namhyung Kim wrote:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > The print format of s32 type was "ld" and it's casted to "long".  So
> > it turned out to print 4294967295 for "-1" on 64-bit systems.  Not
> > sure whether it worked well on 32-bit systems.
[]
> > diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
[]
> > @@ -45,14 +45,19 @@ __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,		\
[]
> > +DEFINE_BASIC_PRINT_TYPE_FUNC(s8,  "%d", signed char)

If there's a need to identify signed char, why
not signed short, signed int and signd long too?


