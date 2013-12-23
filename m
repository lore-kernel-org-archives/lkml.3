Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab3LWKqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 05:46:25 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:54953 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab3LWKqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 05:46:24 -0500
Message-ID: <52B81479.7070607@hitachi.com>
Date: Mon, 23 Dec 2013 19:46:17 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip 1/3] [CLEANUP] perf-probe: Expand given path to absolute
 path
References: <20131220100255.7169.19384.stgit@kbuild-fedora.novalocal> <20131220100257.7169.60537.stgit@kbuild-fedora.novalocal> <871u14drbf.fsf@sejong.aot.lge.com>
In-Reply-To: <871u14drbf.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/23 15:17), Namhyung Kim wrote:
> Hi Masami,
> 
> On Fri, 20 Dec 2013 10:02:57 +0000, Masami Hiramatsu wrote:
>> Expand given path to absolute path in option parser,
>> except for a module name. Instead of expanding it later,
>> this get the absolute path in early stage.
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> ---
>>  tools/perf/builtin-probe.c    |    9 +++++++++
>>  tools/perf/util/probe-event.c |   11 ++---------
>>  2 files changed, 11 insertions(+), 9 deletions(-)
>>
>> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
>> index 6ea9e85..b40d064 100644
>> --- a/tools/perf/builtin-probe.c
>> +++ b/tools/perf/builtin-probe.c
>> @@ -180,6 +180,15 @@ static int opt_set_target(const struct option *opt, const char *str,
>>  		else
>>  			return ret;
>>  
>> +		/* Expand given path to absolute path, except for modulename */
>> +		if (params.uprobes || strchr(str, '/')) {
>> +			str = realpath(str, NULL);
>> +			if (!str) {
>> +				pr_warning("Failed to find the path of %s.\n",
>> +					   str);
> 
> It won't print the path since the str already was overwritten to NULL.

Oops ...

>> +				return ret;
>> +			}
>> +		}
>>  		params.target = str;
> 
> It now points either a dynamically allocated string or not..

Ah, right. OK, I'll use strdup for such case.

Thank you!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


