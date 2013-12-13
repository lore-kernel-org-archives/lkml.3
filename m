Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3LMGGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:06:14 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:35508 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3LMGGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:06:12 -0500
Message-ID: <52AAA3CE.9010301@hitachi.com>
Date: Fri, 13 Dec 2013 15:06:06 +0900
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
Subject: Re: Re: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL()
 and fixes crash bugs
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal> <20131204084551.GA31772@gmail.com> <529FBA71.6070107@hitachi.com> <20131205102127.GA19923@gmail.com> <52A137B6.6030307@hitachi.com> <20131210152811.GA1195@gmail.com> <52A7CA0A.9060009@hitachi.com> <20131211133423.GB3101@gmail.com> <52A9515E.5050505@hitachi.com> <20131212140347.GA17059@gmail.com> <52AA9C55.1000103@hitachi.com>
In-Reply-To: <52AA9C55.1000103@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/13 14:34), Masami Hiramatsu wrote:
>> Lets assume we allow a probe to be inserted in the single-step path. 
>> Such a probe will be an INT3 instruction and if it hits we get a 
>> recursive INT3 invocation. In that case the INT3 handler should simply
>> restore the original instruction and _leave it so_. There's no 
>> single-stepping needed - the probe is confused and must be discarded.
> 
> But how can we restore the protected kernel text?
> If we use text_poke, we also need to prohibit probing on the text_poke
> and functions called in the text_poke too. That just shifts the annotated
> area to the text_poke. :(

BTW, currently we mark the text_poke as nokprobe_symbol, but it should be
removed. We don't call it from kprobes int3/debug handlers.

The patches which removes __kprobes in this series are only for kprobe
related files (arch/x86/kernel/kprobes/* or kernel/kprobes.c.) I think
we should do it for other parts.
Is it better to do that on this series?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


