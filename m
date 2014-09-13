Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaIMDeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 23:34:44 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:59186 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaIMDem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 23:34:42 -0400
Message-ID: <5413BB4D.10606@cloudius-systems.com>
Date: Sat, 13 Sep 2014 06:34:37 +0300
From: Avi Kivity <avi@cloudius-systems.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Jan Stancek <jstancek@redhat.com>
Subject: Re: [BUG] perf tools: Demangle kernel and kernel module symbols too
References: <20140906184631.GA6059@krava.brq.redhat.com>
In-Reply-To: <20140906184631.GA6059@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2014 09:46 PM, Jiri Olsa wrote:
> hi,
> Jan Stancek found test 1 breakage, probably caused by following patch:
>    950b8354716e perf tools: Demangle kernel and kernel module symbols too
>
> it seems to break test 1:
> ---
> [jolsa@krava perf]$ ./perf test -v 1
>   1: vmlinux symtab matches kallsyms                        :
> --- start ---
> test child forked, pid 6288
> Looking at the vmlinux_path (6 entries long)
>
> SNIP
>
> 0xffffffff8142dba0: diff name v: event_queue virtual table k: __vt_event_queue
> 0xffffffff8142dc00: diff name v: event_dequeue virtual table k: __vt_event_dequeue
> 0xffffffff8142dd90: diff name v: event_wait::isra::::part:: virtual table k: __vt_event_wait.isra.0.part.1
> ---
>
> Avi,
> could you please update the tests/vmlinux-kallsyms.c to reflect
> the demangle change?
>
>

It's not a simple matter of updating the test: the demangler interprets 
name beginning with __vt as C++ mangles names, which of course they aren't.

The only way I see to proceed is to make the demangling optional, 
default off.
