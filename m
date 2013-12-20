Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab3LTJfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:35:55 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:55449 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab3LTJbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:31:43 -0500
Message-ID: <52B40E79.8040701@hitachi.com>
Date: Fri, 20 Dec 2013 18:31:37 +0900
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
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal> <y0m38loefhx.fsf@fche.csb> <52B3C5E6.2040802@hitachi.com> <20131220082056.GA15934@gmail.com>
In-Reply-To: <20131220082056.GA15934@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/20 17:20), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>>>  But a closer look indicates that the insertion of kprobes is 
>>> taking about three (!!) orders of magnitude longer than before, as 
>>> judged by the rate of increase of 'wc -l 
>>> /sys/kernel/debug/kprobes/list'.
>>
>> Right, because kprobes are not designed for thousands of probes.
> 
> Then this needs to be fixed, because right now this bug is making it 
> near impossible to properly test kprobes robustness.
> 
> For example a hash table (hashed by probe address) could be used in 
> addition to the list, to speed up basic operations.

kprobe itself is already using hlist (6bits hash table).
Maybe we'd better expand the table bits. However, the iteration
of the list on debugfs is just doing seq_printf()s. I'm not exactly
sure what Frank complaints about...
I recommend Frank to use perf record and perf annotation to clarify
which part caused that slow down.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


