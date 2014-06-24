Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaFXRix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:38:53 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53541 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaFXRiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:38:52 -0400
Message-ID: <53A9B7A4.9050805@gmail.com>
Date: Tue, 24 Jun 2014 11:38:44 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stanislav Fomichev <stfomichev@yandex-team.ru>,
        linux-kernel@vger.kernel.org
CC: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, namhyung@kernel.org, artagnon@gmail.com,
        rusty@rustcorp.com.au, bp@suse.de, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v4 0/4] perf timechart io mode
References: <1403260191-10079-1-git-send-email-stfomichev@yandex-team.ru> <20140624084113.GC31390@krava.redhat.com> <20140624091022.GE20225@stfomichev-desktop.yandex.net> <20140624165712.GA10114@stfomichev-desktop.yandex.net>
In-Reply-To: <20140624165712.GA10114@stfomichev-desktop.yandex.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/24/14, 10:57 AM, Stanislav Fomichev wrote:
> On Tue, Jun 24, 2014 at 01:10:22PM +0400, Stanislav Fomichev wrote:
>>> hum, got this when trying:
>>>
>>> [jolsa@krava perf]$ sudo ./perf timechart record -I
>>> ^C[ perf record: Woken up 2 times to write data ]
>>> [ perf record: Captured and wrote 1.071 MB perf.data (~46806 samples) ]
>>> [jolsa@krava perf]$ ./perf timechart
>>> Invalid previous event (non-zero)!
>>> 0x113f80 [0x8]: failed to process type: 68

I see this kind of message a lot, but typically in high event use cases 
(e.g., 100+MB files in a run of a few seconds). I usually increase the 
map size (-m 4096) and/or bump the priority of perf (-r1) and re-run the 
test.

>> Hm, I added a bunch of consistency checks which I couldn't actually hit
>> myself. Nice work :-) Can I get you perf.data?
>
> For some reason, in Jiri's trace we see exit from sys_read with 2,
> and then again exit from sys_read with -EAGAIN:
>              xterm 32028 [000] 43390.908909: syscalls:sys_enter_read: fd: 0x00000004, buf: 0x02076e8c, count: 0x0
>              xterm 32028 [000] 43390.908917: syscalls:sys_exit_read: 0x2
>              xterm 32028 [000] 43390.908982: syscalls:sys_exit_read: 0xfffffffffffffff5
>
> I'm not sure how it is possible (either we lost sys_enter, or timestamp
> of seconds -EAGAIN is wrong?). I think we might just convert this error
> to a warning (we couldn't reproduce it again).

Any lost events?

David
