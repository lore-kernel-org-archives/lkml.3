Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbaDKMXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 08:23:50 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:49154 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbaDKMXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 08:23:48 -0400
MIME-Version: 1.0
In-Reply-To: <53475B74.30504@hitachi.com>
References: <20140406201628.GA507@redhat.com> <1396995963.5056.46.camel@oc7886638347.ibm.com.usor.ibm.com>
 <20140409154346.GB18486@redhat.com> <53469F95.1030709@redhat.com>
 <5346A362.9010802@hitachi.com> <5346A8BE.5060401@redhat.com> <53475B74.30504@hitachi.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 11 Apr 2014 14:23:27 +0200
Message-ID: <CAK1hOcMO7HUUihGwxYW8PkkLtA2mAZSc9J2JMuehHEWoX15rUQ@mail.gmail.com>
Subject: Re: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative call's
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 5:03 AM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> At least, if we can trust Intel SDM, it says that depends
> on the operand-size (insn->opnd_bytes) and stack segment
> descriptor. Please check the SDM vol.1 6.2.2 Stack Alignment
> and vol.2a, 3.2 Instructions (A-M), CALL--Call Procedure.
> But we'd better check it on x86-32.

I am past trusting CPU manuals on this one:

By now I verified on the real hardware that AMD and Intel CPUs
handle this insn differently in 64-bit mode: Intel ignores 0x66 prefix.
AMD treats this insn the same as in 32-bit mode: as 16-bit insn.

(Should I submit a patch adding comment about it
in x86-opcode-map.txt?)

So there is no universally "correct" way to emulate it.

We, theoretically, can decode it differently *depending
on actual CPU(s) on the system*... do we really want
to go *that* far? I guess not.

-- 
vda
