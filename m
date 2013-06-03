Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab3FCNzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:55:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab3FCNzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:55:02 -0400
Date: Mon, 3 Jun 2013 15:54:22 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Robert Richter <rric@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH 3/4] perf tools: Add attr<num> syntax to event parser
Message-ID: <20130603135421.GB8758@krava.brq.redhat.com>
References: <1369991785-10499-1-git-send-email-rric@kernel.org>
 <1369991785-10499-4-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369991785-10499-4-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 11:16:24AM +0200, Robert Richter wrote:
> From: Robert Richter <robert.richter@calxeda.com>
> 
> The event parser is limited to update only a subset of all fields in
> struct perf_event_attr (config*, period, branch_type). We are not able
> to set other attr fields, esp. flags.
> 
> Introducing a new syntax to set any field of the event attribute by
> using an index to the u64 value to be used within struct
> perf_event_attr. The new syntax attr<num> is similar to config<num>,
> but <num> specifies the index to be used. E.g. attr5:23 sets bit 23 of
> the flag field of attr.
> 
> The persistent event implementation is a use case of the above. In
> this case sysfs provides:
> 
>  /sys/bus/event_source/devices/persistent/events/mce_record:persistent,config=106
>  /sys/bus/event_source/devices/persistent/format/persistent:attr5:23

good idea, you probably need to update:
Documentation/ABI/testing/sysfs-bus-event_source-devices-format

also.. there's so far only mce_record event AFAICS, and this seems
to be initialized at the time when sysfs's not ready so I dont get
the sysfs entries for it.. and since there's no other event yet,
the sysfs is not updated/populated later.. I think ;)

I'll probably tweak it somehow later, but if there was anything
simple I could do or I missed something please let me know, that
would speed up my testing

thanks,
jirka
