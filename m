Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaDRPSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 11:18:04 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:49393 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaDRPSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 11:18:01 -0400
MIME-Version: 1.0
In-Reply-To: <534BEF2E.9050502@hitachi.com>
References: <20140406201628.GA507@redhat.com> <1396995963.5056.46.camel@oc7886638347.ibm.com.usor.ibm.com>
 <20140409154346.GB18486@redhat.com> <53469F95.1030709@redhat.com>
 <5346A362.9010802@hitachi.com> <5346A8BE.5060401@redhat.com>
 <53475B74.30504@hitachi.com> <CAK1hOcMO7HUUihGwxYW8PkkLtA2mAZSc9J2JMuehHEWoX15rUQ@mail.gmail.com>
 <534BEF2E.9050502@hitachi.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 18 Apr 2014 17:17:40 +0200
Message-ID: <CAK1hOcOOfr=DyLd-gZccZzvCuxGJiehi6NTe88QMQd0qRg2TJw@mail.gmail.com>
Subject: Re: Re: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative call's
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 4:22 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> (2014/04/11 21:23), Denys Vlasenko wrote:
>> On Fri, Apr 11, 2014 at 5:03 AM, Masami Hiramatsu
>> <masami.hiramatsu.pt@hitachi.com> wrote:
>>> At least, if we can trust Intel SDM, it says that depends
>>> on the operand-size (insn->opnd_bytes) and stack segment
>>> descriptor. Please check the SDM vol.1 6.2.2 Stack Alignment
>>> and vol.2a, 3.2 Instructions (A-M), CALL--Call Procedure.
>>> But we'd better check it on x86-32.
>>
>> I am past trusting CPU manuals on this one:
>>
>> By now I verified on the real hardware that AMD and Intel CPUs
>> handle this insn differently in 64-bit mode: Intel ignores 0x66 prefix.
>> AMD treats this insn the same as in 32-bit mode: as 16-bit insn.
>>
>> (Should I submit a patch adding comment about it
>> in x86-opcode-map.txt?)
>
> Yeah, feel free to do so :)

I sent a patch (in another email), please apply.
