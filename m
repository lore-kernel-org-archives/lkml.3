Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbbAVBcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:32:33 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:56892 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbbAVBcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:32:24 -0500
MIME-Version: 1.0
In-Reply-To: <54C04A1B.8040408@gmail.com>
References: <1421168344-5363-1-git-send-email-victor.kamensky@linaro.org>
	<1421168344-5363-2-git-send-email-victor.kamensky@linaro.org>
	<CAA3XUr1BnS=8RTVyxtVOm4Ahb2DQXUuJJQC1w2SvT5fycjRcEQ@mail.gmail.com>
	<54C0216F.3080404@gmail.com>
	<CAA3XUr0uXykCTVuw-sYmkhsFZ-cimeuJkXTXNdJyhJh7976xEQ@mail.gmail.com>
	<54C04A1B.8040408@gmail.com>
Date: Wed, 21 Jan 2015 17:32:23 -0800
Message-ID: <CAA3XUr3RJ1RbYTOh2SczZdkGgrk6f=VfoDzu6SQXVu_XwC+FLg@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf symbols: debuglink should take symfs option into account
From: Victor Kamensky <victor.kamensky@linaro.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, Will Deacon <will.deacon@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jiri Olsa <jolsa@kernel.org>, Waiman Long <Waiman.Long@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 January 2015 at 16:53, David Ahern <dsahern@gmail.com> wrote:
> On 1/21/15 5:34 PM, Victor Kamensky wrote:
>>
>> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
>> index 45be944..ca8d8d5 100644
>> --- a/tools/perf/util/dso.c
>> +++ b/tools/perf/util/dso.c
>> @@ -45,13 +45,13 @@ int dso__read_binary_type_filename(const struct dso
>> *dso,
>>       case DSO_BINARY_TYPE__DEBUGLINK: {
>>           char *debuglink;
>>
>> -        strncpy(filename, dso->long_name, size);
>> -        debuglink = filename + dso->long_name_len;
>> +        len = __symbol__join_symfs(filename, size, dso->long_name);
>> +        debuglink = filename + len;
>>           while (debuglink != filename && *debuglink != '/')
>>               debuglink--;
>>           if (*debuglink == '/')
>>               debuglink++;
>> -        ret = filename__read_debuglink(dso->long_name, debuglink,
>> +        ret = filename__read_debuglink(filename, debuglink,
>>                              size - (debuglink - filename));
>>           }
>>           break;
>>
>
> I do not see any reason this will not work. Essentially after
> filename__read_debuglink filename contains symfs + dso path + debuglink read
> from .gnu_debuglink section which is what is wanted.

OK, I am good with this. Let me repost the whole
mini-series based on mailing list review comments.

May I use 'Acked-by' (maybe 'Tested-by' as well) with
your name for the shorter (no filename_copy) as above
version of the patch for .gnu_debuglink issue fix.

ARM/Aarch64 specific change also needs update based on
discussion with Will and Russell.

I'll post updated version 2 latter tonight.

Thanks,
Victor

> Thanks for the example. I used it with both a symfs and non-symfs example
> and both times this change worked properly -- the correct hang.debug file is
> read.
>
> Arnaldo?
>
> David
