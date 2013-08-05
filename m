Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3HEHRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:17:54 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61198 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab3HEHRx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:17:53 -0400
X-AuditID: 9c930197-b7bfbae000000e88-69-51ff519f06c7
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCH 01/17] perf util: Save pid-cmdline mapping into tracing header
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
	<1375175954-798-2-git-send-email-namhyung@kernel.org>
	<20130730132839.GA2607@ghostprotocols.net> <51F85FAA.2090400@lge.com>
	<20130731140746.GA3614@ghostprotocols.net>
Date: Mon, 05 Aug 2013 16:17:51 +0900
In-Reply-To: <20130731140746.GA3614@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Wed, 31 Jul 2013 11:07:46 -0300")
Message-ID: <87r4e81u8w.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Wed, 31 Jul 2013 11:07:46 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jul 31, 2013 at 09:51:54AM +0900, Namhyung Kim escreveu:
>> 2013-07-30 오후 10:28, Arnaldo Carvalho de Melo 쓴 글:
>> >Em Tue, Jul 30, 2013 at 06:18:58PM +0900, Namhyung Kim escreveu:
>> >>Current trace info data lacks the saved cmdline mapping which is
>> >>needed for pevent to find out the comm of a task.  Add this and bump
>> >>up the version number so that perf can determine its presence when
>> >>reading.
>
>> >Can't we get this from the PERF_RECORD_COMM synthesized at the beginning
>> >of the session + the kernel generated ones for new threads?
>
>> >We would just call machine__find_thread() and use thread->comm, etc, no?
>
>> Yes, I think it's doable.  However it needs an additional perf event
>> only to generate the COMM events.  So I decided not to do it and
>
> I don't think this is a problem, its in line with Ingo's suggestion of a
> new perf ioctl to ask the kernel to generate PERF_RECORD_MMAP events for
> existing threads.

Hmm.. could you please give me a link of the thread?

And what kind of event should be used then?

Thanks,
Namhyung
