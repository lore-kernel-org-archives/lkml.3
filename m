Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab3KVCfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 21:35:52 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37756 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab3KVCfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 21:35:48 -0500
Message-ID: <528EC2FF.30301@hitachi.com>
Date: Fri, 22 Nov 2013 11:35:43 +0900
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
        virtualization@lists.linux-foundation.org, systemtap@sourceware.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Re: [PATCH -tip v3 00/23] kprobes: introduce NOKPROBE_SYMBOL()
 and general cleaning of kprobe blacklist
References: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal> <y0mvbznxi6k.fsf@fche.csb> <20131120153801.GA9743@gmail.com> <20131120173600.GK8993@redhat.com> <528D6C9F.8050809@hitachi.com> <20131121072938.GA16912@gmail.com>
In-Reply-To: <20131121072938.GA16912@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/21 16:29), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2013/11/21 2:36), Frank Ch. Eigler wrote:
> 
> [ ... ]
>>> one needs to resort to something like:
>>>
>>> # cat /proc/kallsyms | grep ' [tT] ' | while read addr type symbol; do
>>>    perf probe $symbol
>>> done
>>>
>>> then wait for a few hours for that to finish. Then, or while the loop
>>> is still running, run
>>>
>>> # perf record -e 'probe:*' -aR sleep 1
>>>
>>> to take a kernel down.
>>
>> Um, indeed, current blacklist is not perfect. [...]
> 
> Then it needs to be fixed ASAP!

OK, I see. At least the two patches included this series
should be fixed. :)

And more, I need to test all symbols and drills down.

>> [...] As I reported in this series, I've found 2 more patterns. I 
>> guess there still have some others.
>>
>> But anyway, I don't think it is good to fix all such bugs in this 
>> series.
> 
> Fixing these bugs is far more important than any cleanup work.

I see. This cleanup started with the bugfixes :)

> We can apply the fixes together with your cleanup series to make it 
> all simpler, but the bug fixing absolutely needs to happen right now.

OK, I'll test it first and include the bugfixes in this series.
Or should I push the fixes separated?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


