Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaGVG6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 02:58:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:35806 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbaGVG6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 02:58:23 -0400
Message-ID: <53CE0B89.7030400@linutronix.de>
Date: Tue, 22 Jul 2014 08:58:17 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, acme@kernel.org,
        namhyung.kim@lge.com, tzanussi@gmail.com
Subject: Re: [RFC] perf to ctf converter
References: <20140603163640.GA16279@linutronix.de> <20140714141533.GD17761@krava.redhat.com> <20140721171151.GA12969@linutronix.de> <20140721183530.GA28673@krava.redhat.com>
In-Reply-To: <20140721183530.GA28673@krava.redhat.com>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 08:35 PM, Jiri Olsa wrote:
> On Mon, Jul 21, 2014 at 07:11:51PM +0200, Sebastian Andrzej Siewior wrote:
>
> heya,
> I've  got following build error:
> 
>   CC       util/data-bt.o
> util/data-bt.c: In function ‘add_event_tracepoint_value’:
> util/data-bt.c:293:3: error: implicit declaration of function ‘bt_ctf_event_class_get_field_by_name’ [-Werror=implicit-function-declaration]
>    type = bt_ctf_event_class_get_field_by_name(
>    ^
> util/data-bt.c:293:3: error: nested extern declaration of ‘bt_ctf_event_class_get_field_by_name’ [-Werror=nested-externs]
> util/data-bt.c:293:8: error: assignment makes pointer from integer without a cast [-Werror]
>    type = bt_ctf_event_class_get_field_by_name(
>         ^
> cc1: all warnings being treated as errors
> make[1]: *** [util/data-bt.o] Error 1
> make: *** [all] Error 2
> 
> 
> but I might be missing some of the babeltrace changes, my branch:
>   5805251d8079 Fix: mmap trace read the stream_id from the first packet

Hmm. This function should be there as of commit 2f100782231 in the
master branch. However since my first post and now the babeltrace
source got moved around a little and as a result you have some more
header files.
The function in question is defined in "babeltrace/ctf-ir/event.h" and
included by "babeltrace/ctf-writer/event.h".

> feel free to use/change my commits as you wish ;-)

Thank you.

> 
> I think the best would be to merge your changes with mine
> into some meaningful patchset, before it goes to review

Yeah. I merged some of the fixups back and for the data-bt.c changes,
dunno. Either all my changes as a single patch or merge it back into
yours as it doesn't make sense to post each incremental change.

> I'll check your changes
> 
> thanks,
> jirka
> 
Sebastian
