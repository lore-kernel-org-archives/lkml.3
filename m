Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbaFKOUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 10:20:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:37331 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755297AbaFKOUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 10:20:09 -0400
Date: Wed, 11 Jun 2014 10:20:06 -0400
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
Message-ID: <20140611102006.27cc145e@gandalf.local.home>
In-Reply-To: <9hhk38nedu1.fsf@arm.com>
References: <1402486305-4017-1-git-send-email-punit.agrawal@arm.com>
	<1402486305-4017-4-git-send-email-punit.agrawal@arm.com>
	<20140611084908.509a6950@gandalf.local.home>
	<9hhk38nedu1.fsf@arm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014 15:11:02 +0100
Punit Agrawal <punit.agrawal@arm.com> wrote:
 
> I do indeed see the value of trip_type and it matches what's being
> traced.
> 
> ~# trace-cmd report | grep thermal_zone_trip | tail -n 5
>      kworker/2:2-1014  [002]   125.623213: thermal_zone_trip:    thermal_zone=soc_thermal id=0 trip=0 trip_type=
>      kworker/2:2-1014  [002]   125.743174: thermal_zone_trip:    thermal_zone=soc_thermal id=0 trip=0 trip_type=
>      kworker/2:2-1014  [002]   125.863196: thermal_zone_trip:    thermal_zone=soc_thermal id=0 trip=0 trip_type=
>      kworker/2:2-1014  [002]   125.983175: thermal_zone_trip:    thermal_zone=soc_thermal id=0 trip=0 trip_type=
>      kworker/2:2-1014  [002]   126.103173: thermal_zone_trip:    thermal_zone=soc_thermal id=0 trip=0 trip_type=
> ~# trace-cmd report -R | grep thermal_zone_trip | tail -n 5
>      kworker/2:2-1014  [002]   125.623213: thermal_zone_trip:     thermal_zone=soc_thermal id=0 trip=0 trip_type=1
>      kworker/2:2-1014  [002]   125.743174: thermal_zone_trip:     thermal_zone=soc_thermal id=0 trip=0 trip_type=1
>      kworker/2:2-1014  [002]   125.863196: thermal_zone_trip:     thermal_zone=soc_thermal id=0 trip=0 trip_type=1
>      kworker/2:2-1014  [002]   125.983175: thermal_zone_trip:     thermal_zone=soc_thermal id=0 trip=0 trip_type=1
>      kworker/2:2-1014  [002]   126.103173: thermal_zone_trip:     thermal_zone=soc_thermal id=0 trip=0 trip_type=1
> 
> Is there something I should be doing to enable the translation to the
> string representation when reporting using trace-cmd?

Out of curiosity, what does the format file for it look like?

/sys/kernel/debug/thermal/thermal_zone_trip/format

-- Steve
