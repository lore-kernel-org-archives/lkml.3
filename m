Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaILPXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:23:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbaILPXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:23:03 -0400
Date: Fri, 12 Sep 2014 17:22:23 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Avi Kivity <avi@cloudius-systems.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Jan Stancek <jstancek@redhat.com>
Subject: Re: [BUG] perf tools: Demangle kernel and kernel module symbols too
Message-ID: <20140912152223.GB3894@krava.brq.redhat.com>
References: <20140906184631.GA6059@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140906184631.GA6059@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping

On Sat, Sep 06, 2014 at 08:46:31PM +0200, Jiri Olsa wrote:
> hi,
> Jan Stancek found test 1 breakage, probably caused by following patch:
>   950b8354716e perf tools: Demangle kernel and kernel module symbols too
> 
> it seems to break test 1:
> ---
> [jolsa@krava perf]$ ./perf test -v 1
>  1: vmlinux symtab matches kallsyms                        :
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
> thanks,
> jirka
