Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaIZGXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 02:23:07 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52761 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbaIZGXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 02:23:05 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] perf: Userspace event
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
	<1411491787-25938-3-git-send-email-pawel.moll@arm.com>
	<87oau5k0u9.fsf@sejong.aot.lge.com> <1411649105.4768.48.camel@hornet>
Date: Fri, 26 Sep 2014 15:23:02 +0900
In-Reply-To: <1411649105.4768.48.camel@hornet> (Pawel Moll's message of "Thu,
	25 Sep 2014 13:45:05 +0100")
Message-ID: <87tx3uj3y1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014 13:45:05 +0100, Pawel Moll wrote:
> On Wed, 2014-09-24 at 07:07 +0100, Namhyung Kim wrote:
>> On Tue, 23 Sep 2014 18:03:07 +0100, Pawel Moll wrote:
>> > This patch adds a new PERF_COUNT_SW_UEVENT software event
>> > and a related PERF_SAMPLE_UEVENT sample. User can now
>> > write to the the perf file descriptor, injecting such
>> > event in the perf buffer.
>> 
>> It seems the PERF_SAMPLE_UEVENT sample can be injected to any event.  So
>> why the PERF_COUNT_SW_UEVENT is needed?  At least one can use the
>> SW_DUMMY event for that purpose.
>
> You're right. I needed a different SW type in one of my early
> prototypes, but it's not the case any more. Consider it gone.

Okay.


>
>> Also I think it'd be better to be a record type (PERF_RECORD_XXX)
>> instead of a sample flag (PERF_SAMPLE_XXX).  In perf tools, we already
>> use perf_user_event_type for synthesized userspace events.  This way it
>> can avoid unnecessary sample processing for userspace events.
>
> Fine with me. If no one objects, I'm more than happy to use
> PERF_RECORD_UEVENT = 11 for it.
>
>> For contents, I prefer to give complete control to users - kernel
>> doesn't need to care about it other than its size.  If one just wants to
>> use strings only, she can write them directly.  If others want to mix
>> different types of data, they might need to define a data format for
>> their use.
>
> Are you saying to drop even the "type 0 means zero-terminated string"
> definition, even if everything else is up to the user? I quite like that
> idea, especially combined with write()ing to the perf_fd (it is very
> much like trace_marker then, which is beautiful in its simplicity), but
> the feelings are not that strong to fight a war over it.

:)


Thanks,
Namhyung
