Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab3LSHPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:15:44 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64592 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3LSHPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:15:42 -0500
X-AuditID: 9c930197-b7cefae000007949-37-52b29d1ceddb
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/18] perf tools: Introduce struct add_entry_iter
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
	<1387344086-12744-5-git-send-email-namhyung@kernel.org>
	<20131218155040.GI4146@krava.brq.redhat.com>
Date: Thu, 19 Dec 2013 16:15:40 +0900
In-Reply-To: <20131218155040.GI4146@krava.brq.redhat.com> (Jiri Olsa's message
	of "Wed, 18 Dec 2013 16:50:40 +0100")
Message-ID: <87ppotfh0j.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Wed, 18 Dec 2013 16:50:40 +0100, Jiri Olsa wrote:
> On Wed, Dec 18, 2013 at 02:21:12PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> There're some duplicate code when adding hist entries.  They are
>> different in that some have branch info or mem info but generally do
>> same thing.  So introduce new struct add_entry_iter and add callbacks
>> to customize each case in general way.
>> 
>> The new perf_evsel__add_entry() function will look like:
>> 
>>   iter->prepare_entry();
>>   iter->add_single_entry();
>> 
>>   while (iter->next_entry())
>>     iter->add_next_entry();
>> 
>>   iter->finish_entry();
>> 
>> This will help further work like the cumulative callchain patchset.
>
> cool, I was waiting for this one! I have another user
> for it, I'll test by rebasing my code ;-)

Great!  I'd look forward to your feedback! :)

Thanks,
Namhyung
