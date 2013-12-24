Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab3LXBTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 20:19:14 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:39912 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab3LXBTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 20:19:12 -0500
Message-ID: <52B8E105.90908@hitachi.com>
Date: Tue, 24 Dec 2013 10:19:01 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v6 00/22] kprobes: introduce NOKPROBE_SYMBOL(), cleanup
 and fixes crash bugs
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal> <y0m38loefhx.fsf@fche.csb> <52B3C5E6.2040802@hitachi.com> <20131220082056.GA15934@gmail.com> <52B40E79.8040701@hitachi.com> <20131220104615.GA22609@gmail.com> <52B75542.7040600@hitachi.com> <20131223130438.GA5076@gmail.com>
In-Reply-To: <20131223130438.GA5076@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/23 22:04), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>>> I can reproduce one weirdness, with just 13 probes added, 'perf probe 
>>> -l' [which should really be 'perf probe list'!] executes very slowly:
>>>
>>>  # perf stat --null --repeat 3 perf probe -l
>>>
>>>  Performance counter stats for 'perf probe -l' (3 runs):
>>>
>>>        0.763640098 seconds time elapsed                                          ( +-  1.61% )
>>>
>>> 0.7 seconds is ridiculously long.
>>
>> This comes from the perf-probe's internal issue. It tries to get 
>> actual lines and files by using debuginfo. I guess most of the time 
>> consumed when processing huge kernel debuginfo.
> 
> No, I don't have any debuginfo, I never use it.

Then it should be a performance bug. I need to take a look.

BTW, this is just a bug of perf probe, for example,

 # wc -l /sys/kernel/debug/tracing/kprobe_events
 3204 /sys/kernel/debug/tracing/kprobe_events

 # ./perf stat --null --repeat 3 cat /sys/kernel/debug/tracing/kprobe_events

  Performance counter stats for 'cat /sys/kernel/debug/tracing/kprobe_events' (3 runs):

       0.032075943 seconds time elapsed                                          ( +- 38.72% )

So even with 3204 probes, listing the kprobe events only takes 0.03 sec.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


