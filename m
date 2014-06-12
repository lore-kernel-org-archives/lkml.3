Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaFLQQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:16:54 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50852 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753027AbaFLQQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:16:52 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javi Merino <Javi.Merino@arm.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC PATCH 3/3] thermal: trace: Trace when temperature is above a trip point
References: <1402486305-4017-1-git-send-email-punit.agrawal@arm.com>
	<1402486305-4017-4-git-send-email-punit.agrawal@arm.com>
	<20140611084908.509a6950@gandalf.local.home> <9hhk38nedu1.fsf@arm.com>
	<20140611102006.27cc145e@gandalf.local.home> <9hhfvjbebux.fsf@arm.com>
	<20140611110824.7aa2adc2@gandalf.local.home>
Date: Thu, 12 Jun 2014 17:16:34 +0100
In-Reply-To: <20140611110824.7aa2adc2@gandalf.local.home> (Steven Rostedt's
	message of "Wed, 11 Jun 2014 11:08:24 -0400")
Message-ID: <9hh61k66r31.fsf@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

[...]

>> 
>> # pwd /sys/kernel/debug/tracing/events/thermal/thermal_zone_trip
>> # cat format
>> name: thermal_zone_trip
>> ID: 463
>> format:
>>         field:unsigned short common_type;       offset:0;       size:2; signed:0;
>>         field:unsigned char common_flags;       offset:2;       size:1; signed:0;
>>         field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
>>         field:int common_pid;   offset:4;       size:4; signed:1;
>> 
>>         field:__data_loc char[] thermal_zone;   offset:8;       size:4; signed:0;
>>         field:int id;   offset:12;      size:4; signed:1;
>>         field:int trip; offset:16;      size:4; signed:1;
>>         field:enum thermal_trip_type trip_type; offset:20;      size:4; signed:0;
>> 
>> print fmt: "thermal_zone=%s id=%d trip=%d trip_type=%s",
>> __get_str(thermal_zone), REC->id, REC->trip,
>> __print_symbolic(REC->trip_type, { THERMAL_TRIP_ACTIVE, "active" },
>> { THERMAL_TRIP_PASSIVE, "passive" }, { THERMAL_TRIP_HOT, "hot" }, {
>> THERMAL_TRIP_CRITICAL, "critical" })
>> 
>
> For it to work with trace-cmd (and perf) you'll need to add a plugin to
> define what those enums are. This is the file that trace-cmd uses to
> foramat. But it has no idea how to convert something like
> THERMAL_TRIP_PASSIVE into a number.
>

Hmm, right. I was working under the assumption that the enum values will
be converted to their numeric representation when compiled.

I think it's better to convert the enum to int in the trace event - the
changes are localised and the tool will work as well.

Rui, Eduardo what do you think?

Punit

> -- Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
