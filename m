Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835Ab3LHRmy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 12:42:54 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:35642 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab3LHRmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 12:42:53 -0500
Message-ID: <52A4AF98.8040001@gmail.com>
Date: Sun, 08 Dec 2013 10:42:48 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Pekka Enberg <penberg@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 0/2] perf tool: Carve out fs.* stuff
References: <20131205174725.GF10333@ghostprotocols.net>
In-Reply-To: <20131205174725.GF10333@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/5/13, 10:47 AM, Arnaldo Carvalho de Melo wrote:
> Sorry, some editing problem happened here... Now with proper subject
> line.
>
> - Arnaldo
>
> Em Thu, Dec 05, 2013 at 05:25:50PM +0100, Borislav Petkov escreveu:
>> From: Borislav Petkov <bp@suse.de>
>>
>> Ok,
>>
>> step one: carve out fs-related stuff into a libapikfs.a library.
>
> Adding some more people to the CC list, but from a quick look, this
> is in line with what we discussed so far, so I'm ok with it.
>
> For those people in the CC list, Acked-by would be really, really
> appreciated.

Something is missing. From tools/perf:

$ make O=/tmp/perf

Assembler messages:
Fatal error: can't create /tmp/perf/fs/fs.o: No such file or directory
make[2]: *** [/tmp/perf/fs/fs.o] Error 1
make[2]: *** Waiting for unfinished jobs....
   CC       /tmp/perf/bench/mem-memcpy.o
Assembler messages:
Fatal error: can't create /tmp/perf/fs/debugfs.o: No such file or directory
make[2]: *** [/tmp/perf/fs/debugfs.o] Error 1
make[1]: *** [/tmp/perf/libapikfs.a] Error 2
make[1]: *** Waiting for unfinished jobs....

David
