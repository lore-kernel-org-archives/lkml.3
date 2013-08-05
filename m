Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab3HEIzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:55:08 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45994 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab3HEIzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:55:06 -0400
X-AuditID: 9c930179-b7c53ae000000457-cf-51ff6868cca2
From: Namhyung Kim <namhyung@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Stev Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 13/13] tracing/probes: Fix basic print type functions
References: <1375261410-11219-1-git-send-email-namhyung@kernel.org>
	<1375261410-11219-14-git-send-email-namhyung@kernel.org>
	<51FF4492.8080100@hitachi.com> <1375684317.3133.25.camel@joe-AO722>
Date: Mon, 05 Aug 2013 17:55:04 +0900
In-Reply-To: <1375684317.3133.25.camel@joe-AO722> (Joe Perches's message of
	"Sun, 04 Aug 2013 23:31:57 -0700")
Message-ID: <87ob9czfdj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Sun, 04 Aug 2013 23:31:57 -0700, Joe Perches wrote:
> On Mon, 2013-08-05 at 15:22 +0900, Masami Hiramatsu wrote:
>> (2013/07/31 18:03), Namhyung Kim wrote:
>> > From: Namhyung Kim <namhyung.kim@lge.com>
>> > 
>> > The print format of s32 type was "ld" and it's casted to "long".  So
>> > it turned out to print 4294967295 for "-1" on 64-bit systems.  Not
>> > sure whether it worked well on 32-bit systems.
> []
>> > diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> []
>> > @@ -45,14 +45,19 @@ __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,		\
> []
>> > +DEFINE_BASIC_PRINT_TYPE_FUNC(s8,  "%d", signed char)
>
> If there's a need to identify signed char, why
> not signed short, signed int and signd long too?

Thanks for taking your time.

AFAIK the plain 'char' in C can be either signed or unsigned depending
on systems.  Other types don't have this issue - they always are
signed types.

Thanks,
Namhyung
