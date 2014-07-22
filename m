Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbaGVLcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:32:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:37254 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbaGVLcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:32:07 -0400
Message-ID: <53CE4BAF.2010906@linutronix.de>
Date: Tue, 22 Jul 2014 13:31:59 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, acme@kernel.org,
        namhyung.kim@lge.com, tzanussi@gmail.com
Subject: Re: [RFC] perf to ctf converter
References: <20140603163640.GA16279@linutronix.de> <20140714141533.GD17761@krava.redhat.com> <20140721171151.GA12969@linutronix.de> <20140721183530.GA28673@krava.redhat.com> <53CE0B89.7030400@linutronix.de> <20140722112535.GA29750@krava.redhat.com>
In-Reply-To: <20140722112535.GA29750@krava.redhat.com>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 01:25 PM, Jiri Olsa wrote:

> I've got it running... make LIBBABELTRACE_DIR=/opt/libbabeltrace/ ugh ;-)
> 
> [jolsa@krava perf]$ LD_LIBRARY_PATH=/opt/libbabeltrace/lib /opt/libbabeltrace/bin/babeltrace ./ctf-data/
> 
> [04:41:11.445378840] (+?.?????????) sched:sched_switch: { }, { pid = 5782, comm = "ls", prev_comm = [ [0] = "ls", [1] = "s", [2] = "", [3] = "f", [4] = "", [5] = "", [6] = "-x86_64-l", [7] = "x86_64-l", [8] = "86_64-l", [9] = "6_64-l", [10] = "_64-l", [11] = "64-l", [12] = "4-l", [13] = "-l", [14] = "l", [15] = "" ], prev_pid = 5782, prev_prio = 120, prev_state = 0x1, next_comm = [ [0] = "kworker/0:0", [1] = "worker/0:0", [2] = "orker/0:0", [3] = "rker/0:0", [4] = "ker/0:0", [5] = "er/0:0", [6] = "r/0:0", [7] = "/0:0", [8] = "0:0", [9] = ":0", [10] = "0", [11] = "", [12] = "", [13] = "", [14] = "", [15] = "" ], next_pid = 2376, next_prio = 120 }
> [04:41:11.445390175] (+0.000011335) sched:sched_switch: { }, { pid = 5782, comm = "ls", prev_comm = [ [0] = "ls", [1] = "s", [2] = "", [3] = "f", [4] = "", [5] = "", [6] = "-x86_64-l", [7] = "x86_64-l", [8] = "86_64-l", [9] = "6_64-l", [10] = "_64-l", [11] = "64-l", [12] = "4-l", [13] = "-l", [14] = "l", [15] = "" ], prev_pid = 5782, prev_prio = 120, prev_state = 0x1, next_comm = [ [0] = "kworker/0:0", [1] = "worker/0:0", [2] = "orker/0:0", [3] = "rker/0:0", [4] = "ker/0:0", [5] = "er/0:0", [6] = "r/0:0", [7] = "/0:0", [8] = "0:0", [9] = ":0", [10] = "0", [11] = "", [12] = "", [13] = "", [14] = "", [15] = "" ], next_pid = 2376, next_prio = 120 }
> 
> ...
> 
> looks like we need some better string arg handling,
> but we'll get there soon or later

I'm looking at how python gets it nicer…

> we'd like to have single/compact change commits.. so far I think 
> we can go with following commits:
> 
>   perf tools: VF=2 code
>   perf tools: Feature check for libbabeltrace
>   perf tools: Add new data command
> 
> and merge your changes/fixies into:
>   perf tools: Add perf data to CTF convertion support
> 
> if we could break the last one into more logical changes
> it'd be nicer.. but if not, let's got from here
> 
> I'll prepare those 1st 3 patches.. and review your code while
> getting familiar with ctf again ;-)

Okay. I rebased and re-pushed perf_ctf_3. It is down to 3 + 2
patches. Can merge the last two patches into one.

> thanks,
> jirka

Sebastian
