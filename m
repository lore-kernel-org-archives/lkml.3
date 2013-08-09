Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030517Ab3HIHfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 03:35:12 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:63891 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030482Ab3HIHfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 03:35:10 -0400
X-AuditID: 9c930197-b7b44ae00000347f-56-52049bab26c2
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 03/13] tracing/kprobes: Make stack and memory fetch functions static
References: <1375261410-11219-1-git-send-email-namhyung@kernel.org>
	<1375261410-11219-4-git-send-email-namhyung@kernel.org>
	<51FF6A89.9020404@hitachi.com>
Date: Fri, 09 Aug 2013 16:35:07 +0900
In-Reply-To: <51FF6A89.9020404@hitachi.com> (Masami Hiramatsu's message of
	"Mon, 05 Aug 2013 18:04:09 +0900")
Message-ID: <87y58bwc44.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami-san,

On Mon, 05 Aug 2013 18:04:09 +0900, Masami Hiramatsu wrote:
> (2013/07/31 18:03), Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Those fetch functions need to be implemented differently for kprobes
>> and uprobes.  Since the symbol and deref fetch functions don't call
>> those directly anymore, we can make them static and implement them
>> separately.
>
> Hmm, I think this should be done in 1/13, since this is partially
> reverted it in the same series. If you concern about tweaking other
> one's patch, you can add you singed-off-by to it. :)

The problem is that it should be marked static after converting to
->fetch() member.  Otherwise the symbol and deref fetch method won't see
memory fetch functions like:

/home/namhyung/project/linux/kernel/trace/trace_probe.c: In function ‘fetch_deref_u8’:
/home/namhyung/project/linux/kernel/trace/trace_probe.c:115:1: error: implicit declaration of function ‘fetch_memory_u8’ [-Werror=implicit-function-declaration]
/home/namhyung/project/linux/kernel/trace/trace_probe.c: In function ‘fetch_deref_u16’:
/home/namhyung/project/linux/kernel/trace/trace_probe.c:115:1: error: implicit declaration of function ‘fetch_memory_u16’ [-Werror=implicit-function-declaration]
/home/namhyung/project/linux/kernel/trace/trace_probe.c: In function ‘fetch_deref_u32’:
/home/namhyung/project/linux/kernel/trace/trace_probe.c:115:1: error: implicit declaration of function ‘fetch_memory_u32’ [-Werror=implicit-function-declaration]
/home/namhyung/project/linux/kernel/trace/trace_probe.c: In function ‘fetch_deref_u64’:
/home/namhyung/project/linux/kernel/trace/trace_probe.c:115:1: error: implicit declaration of function ‘fetch_memory_u64’ [-Werror=implicit-function-declaration]
/home/namhyung/project/linux/kernel/trace/trace_probe.c: In function ‘fetch_deref_string’:
/home/namhyung/project/linux/kernel/trace/trace_probe.c:116:1: error: implicit declaration of function ‘fetch_memory_string’ [-Werror=implicit-function-declaration]
/home/namhyung/project/linux/kernel/trace/trace_probe.c: In function ‘fetch_deref_string_size’:
/home/namhyung/project/linux/kernel/trace/trace_probe.c:117:1: error: implicit declaration of function ‘fetch_memory_string_size’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors


Thanks,
Namhyung
