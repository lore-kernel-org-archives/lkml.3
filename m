Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbaLDLxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:53:12 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37098 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbaLDLxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:53:10 -0500
Message-ID: <54804B1F.3020703@hitachi.com>
Date: Thu, 04 Dec 2014 20:53:03 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steve Capper <steve.capper@linaro.org>
Cc: David Long <dave.long@linaro.org>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        William Cohen <wcohen@redhat.com>, David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/5] ARM64: Add kernel probes(Kprobes) support
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org> <20141120135851.GA32528@linaro.org> <54759041.9080105@hitachi.com> <20141126100325.GA9157@linaro.org> <5476120D.9030703@linaro.org> <CAPvkgC3eVOZEn79C9PC9c7TqC_-yCtDhw5LL6ZWUJxr+oQFaow@mail.gmail.com> <5476BFB4.2020705@hitachi.com> <CAPvkgC0ELPPWfa-8kQ4H_e_O5G1ER4KEKuSWLxh_u-VZgh7W6A@mail.gmail.com> <547C36DB.7060903@hitachi.com> <547F242D.1060705@redhat.com> <547F94B0.1000902@linaro.org> <547FB5DD.901@redhat.com> <547FCB73.1010707@linaro.org> <CAPvkgC3=KKKMa1hWdOYOcV7D7kQSLtnNnXLBB64_P-V+_qUwTw@mail.gmail.com> <54803ADD.2090201@hitachi.com> <CAPvkgC26-CprjLVH55=7z73JtxTumFFZ4W7itevXxMwReVqQ1g@mail.gmail.com>
In-Reply-To: <CAPvkgC26-CprjLVH55=7z73JtxTumFFZ4W7itevXxMwReVqQ1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/04 20:29), Steve Capper wrote:

>> I'd like to ask you to try my fix on your machine, with my reproducing
>> methods. (do not use sytemtap nor perf, those can have other issues)
>>
> 
> Thank you Masami,
> 
> I tried the following commands:
> 
> echo "p:trace_event_buffer_lock_reserve
> trace_event_buffer_lock_reserve" >
> /sys/kernel/debug/tracing/kprobe_events
> echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable
> echo 1 > /sys/kernel/debug/tracing/events/sched/sched_process_exec/enable
> 
> The system appeared okay, I then cat'ed out:
> # cat /sys/kernel/debug/tracing/kprobe_profile
>    trace_event_buffer_lock_reserve                           25              25
> 
> I got similar output (i.e. no crashes) both with and without the
> interrupt fix you recommended.
> 
> I'm not sure how to interpret this, please let me know if you would
> like me to run any other tests?
> 
> (I did also try your proposed fix with perf + memcpy and that crashed
> in a similar way as before).

Hmm, then the bug is still there, and the bug may not be in the recursive
call path... We need to find another suspicious code in the patch.


Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


