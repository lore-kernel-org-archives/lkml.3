Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab3EQCVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 22:21:14 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:53945 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab3EQCVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 22:21:13 -0400
Message-ID: <51959417.7070403@hitachi.com>
Date: Fri, 17 May 2013 11:21:11 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Irina Tirdea <irina.tirdea@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Tom Zanussi <tom.zanussi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@suse.de>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/5] perf: Reorder parameters of strglobmatch
References: <20130516114839.13508.92844.stgit@mhiramat-M0-7522>  <20130516114852.13508.72995.stgit@mhiramat-M0-7522> <1368716142.6828.98.camel@gandalf.local.home>
In-Reply-To: <1368716142.6828.98.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/05/16 23:55), Steven Rostedt wrote:
> On Thu, 2013-05-16 at 20:48 +0900, Masami Hiramatsu wrote:
>> Reorder parameters of strglobmatch() so that the first
>> parameter is the glob pattern as like as regexec(),
>> because the subjective parameter of strglobmatch() must
>> be the glob pattern, but not a sample string.
>> So, the new interface is:
> 
> I'm a bit confused to the rational here. Can you explain in more detail
> to why this patch is actually needed?

Yes, actually, this patch is not needed from the viewpoint of execution,
but less misuse for future use of the strglobmatch, I think.

For example, glob(3) has the pattern parameter as the first one,

       int glob(const char *pattern, int flags,
                int (*errfunc) (const char *epath, int eerrno),
                glob_t *pglob);

regexec(3) also has the compiled regexp at the first parameter,

       int regexec(const regex_t *preg, const char *string, size_t nmatch,
                   regmatch_t pmatch[], int eflags);

Thus, I think a new user of strglobmatch() may guess that the first
parameter should be the glob pattern.

So, this patch is not technically needed, but from the viewpoint of coding
naturally, it should be changed, IMHO.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


