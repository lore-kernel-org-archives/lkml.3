Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbaFKPIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:08:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:55073 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751810AbaFKPIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:08:30 -0400
Date: Wed, 11 Jun 2014 11:08:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javi Merino <Javi.Merino@arm.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC PATCH 3/3] thermal: trace: Trace when temperature is above
 a trip point
Message-ID: <20140611110824.7aa2adc2@gandalf.local.home>
In-Reply-To: <9hhfvjbebux.fsf@arm.com>
References: <1402486305-4017-1-git-send-email-punit.agrawal@arm.com>
	<1402486305-4017-4-git-send-email-punit.agrawal@arm.com>
	<20140611084908.509a6950@gandalf.local.home>
	<9hhk38nedu1.fsf@arm.com>
	<20140611102006.27cc145e@gandalf.local.home>
	<9hhfvjbebux.fsf@arm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014 15:53:42 +0100
Punit Agrawal <punit.agrawal@arm.com> wrote:


> >
> > /sys/kernel/debug/thermal/thermal_zone_trip/format
> 
> I don't have this file but found the following which seems to contain
> the format.

Yeah, that was typed manually, forgot "tracing". I mount the debugfs
system at /debug for easier typing. I hate the /sys/kernel/debug path.
Too much typing.

> 
> # pwd /sys/kernel/debug/tracing/events/thermal/thermal_zone_trip
> # cat format
> name: thermal_zone_trip
> ID: 463
> format:
>         field:unsigned short common_type;       offset:0;       size:2; signed:0;
>         field:unsigned char common_flags;       offset:2;       size:1; signed:0;
>         field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
>         field:int common_pid;   offset:4;       size:4; signed:1;
> 
>         field:__data_loc char[] thermal_zone;   offset:8;       size:4; signed:0;
>         field:int id;   offset:12;      size:4; signed:1;
>         field:int trip; offset:16;      size:4; signed:1;
>         field:enum thermal_trip_type trip_type; offset:20;      size:4; signed:0;
> 
> print fmt: "thermal_zone=%s id=%d trip=%d trip_type=%s", __get_str(thermal_zone), REC->id, REC->trip, __print_symbolic(REC->trip_type, { THERMAL_TRIP_ACTIVE, "active" }, { THERMAL_TRIP_PASSIVE, "passive" }, { THERMAL_TRIP_HOT, "hot" }, { THERMAL_TRIP_CRITICAL, "critical" })
> 

For it to work with trace-cmd (and perf) you'll need to add a plugin to
define what those enums are. This is the file that trace-cmd uses to
foramat. But it has no idea how to convert something like
THERMAL_TRIP_PASSIVE into a number.

-- Steve
