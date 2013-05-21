Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab3EUJt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 05:49:27 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34093 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3EUJt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 05:49:26 -0400
Message-ID: <519B4322.4030701@hitachi.com>
Date: Tue, 21 May 2013 18:49:22 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Irina Tirdea <irina.tirdea@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Tom Zanussi <tom.zanussi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@suse.de>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Re: [PATCH 2/5] perf: Reorder parameters of strglobmatch
References: <20130516114839.13508.92844.stgit@mhiramat-M0-7522> <20130516114852.13508.72995.stgit@mhiramat-M0-7522> <1368716142.6828.98.camel@gandalf.local.home> <51959417.7070403@hitachi.com> <20130521091947.GD10541@ghostprotocols.net>
In-Reply-To: <20130521091947.GD10541@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/05/21 18:19), Arnaldo Carvalho de Melo wrote:
> Em Fri, May 17, 2013 at 11:21:11AM +0900, Masami Hiramatsu escreveu:
>> (2013/05/16 23:55), Steven Rostedt wrote:
>>> I'm a bit confused to the rational here. Can you explain in more detail
>>> to why this patch is actually needed?
>  
>> Yes, actually, this patch is not needed from the viewpoint of execution,
>> but less misuse for future use of the strglobmatch, I think.
>  
>> For example, glob(3) has the pattern parameter as the first one,
>>
>>        int glob(const char *pattern, int flags,
>>                 int (*errfunc) (const char *epath, int eerrno),
>>                 glob_t *pglob);
>  
>> regexec(3) also has the compiled regexp at the first parameter,
>  
>>        int regexec(const regex_t *preg, const char *string, size_t nmatch,
>>                    regmatch_t pmatch[], int eflags);
>  
>> Thus, I think a new user of strglobmatch() may guess that the first
>> parameter should be the glob pattern.
>  
>> So, this patch is not technically needed, but from the viewpoint of coding
>> naturally, it should be changed, IMHO.
> 
> So I suggest you state this in the changeset comment :-)

Agreed, I must update it ...

Thank you,
-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


