Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbaFRAcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 20:32:09 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:39828 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248AbaFRAcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 20:32:08 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf timechart: implement IO mode
References: <1402412694-5996-1-git-send-email-stfomichev@yandex-team.ru>
	<1402412694-5996-2-git-send-email-stfomichev@yandex-team.ru>
	<87ppif9c3y.fsf@sejong.aot.lge.com>
	<20140616060804.GA9394@stfomichev-desktop.yandex.net>
Date: Wed, 18 Jun 2014 09:31:59 +0900
In-Reply-To: <20140616060804.GA9394@stfomichev-desktop.yandex.net> (Stanislav
	Fomichev's message of "Mon, 16 Jun 2014 10:08:04 +0400")
Message-ID: <87sin383cw.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislav,

On Mon, 16 Jun 2014 10:08:04 +0400, Stanislav Fomichev wrote:
>> It was because, as I said, my system doesn't have pread64 syscall.. you
>> missed to decrease rec_argc when skipping invalid events. :)
> Thanks, missed that!
>
>> After fixing the problem, I could run timechart and generate an
>> output.svg file.  But it doesn't show any IO activity.. process info was
>> there in grey boxes (rect.process3) but no color boxes.  I also tried
>> recording with ping and dd, but the result was same.  I suspect it's
>> because of some mis-calculation of position or size of the boxes.
> Did you try it with all patches applied? Because if you have really fast
> IO you can miss it (unless you applied perf timechart: add more options
> to IO mode).

I applied all your three patches.

  $ git log --oneline -3
  ddba809264f7 perf timechart: add more options to IO mode
  81cc94085210 perf timechart: conditionally update start_time on fork
  6aea1951c072 perf timechart: implement IO mode

  $ perf --version
  perf version 3.15.rc4.gddba809

  $ perf timechart record -I dd if=/dev/zero of=xxx bs=4k count=10k
  10240+0 records in
  10240+0 records out
  41943040 bytes (42 MB) copied, 0.0533579 s, 786 MB/s
  [ perf record: Woken up 16 times to write data ]
  [ perf record: Captured and wrote 4.209 MB perf.data (~183881 samples) ]

  $ perf timechart
  Written 0.1 seconds of trace to output.svg


> Can you somehow share your perf.data with me? I'll check what's going
> on.

https://git.kernel.org/cgit/linux/kernel/git/namhyung/linux-perf.git/plain/tools/perf/perf.timechart.data?h=perf/tmp

Thanks,
Namhyung
