Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3A3MaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:30:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2054 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3A3MaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:30:21 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=hV91bRJZgd0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=n8Thy2yv7PIA:10 a=Y5M_ef3otnAt5KaXRJ0A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359549018.17639.90.camel@gandalf.local.home>
Subject: Re: [PATCH v2] Add 4 tracepoint events for vfs
From: Steven Rostedt <rostedt@goodmis.org>
To: chenggang <chenggang.qin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@alibaba-inc.com>
Date: Wed, 30 Jan 2013 07:30:18 -0500
In-Reply-To: <1359527706-3459-1-git-send-email-chenggang.qin@gmail.com>
References: <1359527706-3459-1-git-send-email-chenggang.qin@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-30 at 14:35 +0800, chenggang wrote:
> +#include <asm/ptrace.h>
> +
> +DECLARE_EVENT_CLASS(vfs_filerw_template,
> +
> +	TP_PROTO(long long pos, unsigned long bytes, unsigned char *fname),

One last nit. Might want to make fname "const".

-- Steve

> +
> +	TP_ARGS(pos, bytes, fname),
> +
> +	TP_STRUCT__entry(
> +		__field(        long long,      pos             )
> +		__field(        unsigned long,  bytes           )
> +		__string(       fname,          fname           )
> +	),
> +
> +	TP_fast_assign(
> +		__entry->pos    = pos;
> +		__entry->bytes  = bytes;
> +		__assign_str(fname, fname);
> +	),
> +
> +	TP_printk("Filename: %s Pos: %lld Bytes: %lu",
> +		  __get_str(fname), __entry->pos, __entry->bytes)
> +);
> +


