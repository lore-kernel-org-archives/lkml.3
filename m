Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3LFCeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 21:34:44 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47200 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab3LFCen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 21:34:43 -0500
Message-ID: <52A137B6.6030307@hitachi.com>
Date: Fri, 06 Dec 2013 11:34:30 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL() and
 fixes crash bugs
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal> <20131204084551.GA31772@gmail.com> <529FBA71.6070107@hitachi.com> <20131205102127.GA19923@gmail.com>
In-Reply-To: <20131205102127.GA19923@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/05 19:21), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>>> So we need both a maintainable and a sane/safe solution, and I'd 
>>> like to apply the whole thing at once and be at ease that the 
>>> solution is round. We should have done this years ago.
>>
>> For the safeness of kprobes, I have an idea; introduce a whitelist 
>> for dynamic events. AFAICS, the biggest unstable issue of kprobes 
>> comes from putting *many* probes on the functions called from 
>> tracers.
> 
> If the number of 'noprobe' annotations is expected to explode then 
> maybe another approach should be considered.

No, since this is a "quantitative" issue, the annotation helps us.

> For example in perf we detect recursion. Could kprobes do that and 
> detect hitting a probe while running kprobes code, and ignore it [do 
> an early return]?

Yes, the kprobe itself already has recursion detector and it rejects
calling handler.

> 
> That way most of the annotations could be removed and kprobes would 
> become inherently safe. Is there any complication I'm missing?

That is actually what I'm doing with cleanup patches. :)


Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


