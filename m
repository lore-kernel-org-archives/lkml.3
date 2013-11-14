Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab3KNCCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 21:02:31 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:60322 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3KNCCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 21:02:23 -0500
Message-ID: <52842F2C.1030701@hitachi.com>
Date: Thu, 14 Nov 2013 11:02:20 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: David Long <dave.long@linaro.org>, linux-arm-kernel@lists.infradead.org,
        Rabin Vincent <rabin@rab.in>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Re: [PATCH v2 10/13] kprobes: Remove uneeded kernel dependency
 on struct arch_specific_insn
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>  <1381871068-27660-11-git-send-email-dave.long@linaro.org> <1384362833.3392.42.camel@linaro1.home>
In-Reply-To: <1384362833.3392.42.camel@linaro1.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/14 2:13), Jon Medhurst (Tixy) wrote:
> On Tue, 2013-10-15 at 17:04 -0400, David Long wrote:
>> From: "David A. Long" <dave.long@linaro.org>
>>
>> Instead of depending on include/asm/kprobes.h to provide a dummy definition
>> for struct arch_specific_insn, do so in include/linux/kprobes.h.
> 
> That change description doesn't quite seem to quite make sense to me.
> 
> Anyway, what we're trying to do with this patch is to allow us to use
> arch_specific_insn for purposes additional to implementing kprobes. This
> patch enables that but I'm wary that the kprobes code assumes that ainsn
> is a struct arch_specific_insn, e.g. in linux/kernel/kprobes.c we have:
> 
> 	memcpy(&p->ainsn, &ap->ainsn, sizeof(struct arch_specific_insn));
> 
> Now, that code isn't compiled when kprobes isn't configured, but it
> seams to me to be safer if that was also changed to 
> 
> 	memcpy(&p->ainsn, &ap->ainsn, sizeof(p->ainsn));

This kind of cleanup looks good for me, but I don't agree to change
the type of the member (removing is OK) by Kconfig. If you want to
change the framework of kprobes and uprobes itself (unification),
I'm appreciate to discuss with you and uprobes people, because it
will involve all arch dependent code change, *NOT ONLY* the ARM issue.

> However, I also wonder if we should instead leave arch_specific_insn as
> a kprobes specific structure and on ARM define it in terms of a new more
> generic 'struct probe_insn'? The drawback with that is that we'd
> probably end up with a struct just containing a single member which
> seems a bit redundant:
>
> struct arch_specific_insn {
> 	struct probe_insn pinsn;
> };

I also disagree it. If you have a plan to integrate uprobes and kprobes
arch specific code, please share it with us. I'm happy to work with you.
There are already many maintainers on each feature who is responsible for
it (even it is a piece of code), and scripts/get_maintainers.pl gives you
who are.

Srikar, Oleg, I think it's a good time to merge such arch_specific mechanism
of uprobes and kprobes. Would you think we can do similar thing on x86 too?

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


