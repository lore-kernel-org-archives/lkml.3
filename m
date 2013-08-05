Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3HEH1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:27:47 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:47216 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab3HEH1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:27:46 -0400
Message-ID: <51FF53EE.1060200@hitachi.com>
Date: Mon, 05 Aug 2013 16:27:42 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Stev Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: Re: [PATCH 13/13] tracing/probes: Fix basic print type functions
References: <1375261410-11219-1-git-send-email-namhyung@kernel.org>  <1375261410-11219-14-git-send-email-namhyung@kernel.org>  <51FF4492.8080100@hitachi.com> <1375684317.3133.25.camel@joe-AO722>
In-Reply-To: <1375684317.3133.25.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/05 15:31), Joe Perches wrote:
> On Mon, 2013-08-05 at 15:22 +0900, Masami Hiramatsu wrote:
>> (2013/07/31 18:03), Namhyung Kim wrote:
>>> From: Namhyung Kim <namhyung.kim@lge.com>
>>>
>>> The print format of s32 type was "ld" and it's casted to "long".  So
>>> it turned out to print 4294967295 for "-1" on 64-bit systems.  Not
>>> sure whether it worked well on 32-bit systems.
> []
>>> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> []
>>> @@ -45,14 +45,19 @@ __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,		\
> []
>>> +DEFINE_BASIC_PRINT_TYPE_FUNC(s8,  "%d", signed char)
> 
> If there's a need to identify signed char, why
> not signed short, signed int and signd long too?

Actually, since the types smaller than int are automatically up-casted
to (signed/unsigned) int, those do not require the cast.
However, u64/s64 requires those cast, because there are two different
definitions (see include/asm/int-l[l]64.h).

BTW, I think we should have a common definition of the printk format
for each integer types too.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


