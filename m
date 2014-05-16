Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaEPHQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 03:16:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894AbaEPHQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 03:16:10 -0400
Date: Fri, 16 May 2014 09:15:57 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Javi Merino <javi.merino@arm.com>
Subject: Re: [PATCH] tools lib traceevent: Added support for __get_bitmask()
 macro
Message-ID: <20140516071557.GB3609@krava.brq.redhat.com>
References: <20140515181852.11fffcda@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140515181852.11fffcda@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 06:18:52PM -0400, Steven Rostedt wrote:
> 
> Coming in v3.16, trace events will be able to save bitmasks in raw
> format in the ring buffer and output it with the __get_bitmask() macro.
> 
> In order for userspace tools to parse this, it must be able to handle
> the __get_bitmask() call and be able to convert the data that's in
> the ring buffer into a nice bitmask format. The output is similar to
> what the kernel uses to print bitmasks, with a comma separator every
> 4 bytes (8 characters).
> 
> This allows for cpumasks to also be saved efficiently.
> 
> The first user is the thermal:thermal_power_limit event which has the
> following output:
> 
>  thermal_power_limit:  cpus=0000000f freq=1900000 cdev_state=0 power=5252

needs also an update in python and perf code:

[jolsa@krava perf]$ make
SNIP

...                       libnuma: [ on  ]
...                       libperl: [ on  ]

SNIP

  CC       scripts/perl/Perf-Trace-Util/Context.o
  CC       util/scripting-engines/trace-event-python.o
  CC       scripts/python/Perf-Trace-Util/Context.o
util/scripting-engines/trace-event-python.c: In function ‘define_event_symbols’:
util/scripting-engines/trace-event-python.c:155:2: error: enumeration value ‘PRINT_BITMASK’ not handled in switc
  switch (args->type) {
  ^
cc1: all warnings being treated as errors
make[1]: *** [util/scripting-engines/trace-event-python.o] Error 1
make[1]: *** Waiting for unfinished jobs....
util/scripting-engines/trace-event-perl.c: In function ‘define_event_symbols’:
util/scripting-engines/trace-event-perl.c:188:2: error: enumeration value ‘PRINT_BITMASK’ not handled in switch 
  switch (args->type) {
  ^
cc1: all warnings being treated as errors
make[1]: *** [util/scripting-engines/trace-event-perl.o] Error 1
make: *** [all] Error 2

jirka
