Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaDNOWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:22:51 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41970 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaDNOWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:22:47 -0400
Message-ID: <534BEF2E.9050502@hitachi.com>
Date: Mon, 14 Apr 2014 23:22:38 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Re: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative
 call's
References: <20140406201628.GA507@redhat.com> <1396995963.5056.46.camel@oc7886638347.ibm.com.usor.ibm.com> <20140409154346.GB18486@redhat.com> <53469F95.1030709@redhat.com> <5346A362.9010802@hitachi.com> <5346A8BE.5060401@redhat.com> <53475B74.30504@hitachi.com> <CAK1hOcMO7HUUihGwxYW8PkkLtA2mAZSc9J2JMuehHEWoX15rUQ@mail.gmail.com>
In-Reply-To: <CAK1hOcMO7HUUihGwxYW8PkkLtA2mAZSc9J2JMuehHEWoX15rUQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/11 21:23), Denys Vlasenko wrote:
> On Fri, Apr 11, 2014 at 5:03 AM, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
>> At least, if we can trust Intel SDM, it says that depends
>> on the operand-size (insn->opnd_bytes) and stack segment
>> descriptor. Please check the SDM vol.1 6.2.2 Stack Alignment
>> and vol.2a, 3.2 Instructions (A-M), CALL--Call Procedure.
>> But we'd better check it on x86-32.
> 
> I am past trusting CPU manuals on this one:
> 
> By now I verified on the real hardware that AMD and Intel CPUs
> handle this insn differently in 64-bit mode: Intel ignores 0x66 prefix.
> AMD treats this insn the same as in 32-bit mode: as 16-bit insn.
> 
> (Should I submit a patch adding comment about it
> in x86-opcode-map.txt?)

Yeah, feel free to do so :)

> So there is no universally "correct" way to emulate it.
> 
> We, theoretically, can decode it differently *depending
> on actual CPU(s) on the system*... do we really want
> to go *that* far? I guess not.

No I guess not too. If we start such thing, we need to cover
other x86 variants too... And actually jump/callw is not a
normal instructions.

BTW, I can see that difference on AMD64 architecture programmers
manual vol.3 appendix A. It seems that the difference is by
design...

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


