Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaLDKVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:21:38 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:51068 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbaLDKVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:21:34 -0500
MIME-Version: 1.0
In-Reply-To: <547FCB73.1010707@linaro.org>
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org>
	<20141120135851.GA32528@linaro.org>
	<54759041.9080105@hitachi.com>
	<20141126100325.GA9157@linaro.org>
	<5476120D.9030703@linaro.org>
	<CAPvkgC3eVOZEn79C9PC9c7TqC_-yCtDhw5LL6ZWUJxr+oQFaow@mail.gmail.com>
	<5476BFB4.2020705@hitachi.com>
	<CAPvkgC0ELPPWfa-8kQ4H_e_O5G1ER4KEKuSWLxh_u-VZgh7W6A@mail.gmail.com>
	<547C36DB.7060903@hitachi.com>
	<547F242D.1060705@redhat.com>
	<547F94B0.1000902@linaro.org>
	<547FB5DD.901@redhat.com>
	<547FCB73.1010707@linaro.org>
Date: Thu, 4 Dec 2014 10:21:33 +0000
Message-ID: <CAPvkgC3=KKKMa1hWdOYOcV7D7kQSLtnNnXLBB64_P-V+_qUwTw@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] ARM64: Add kernel probes(Kprobes) support
From: Steve Capper <steve.capper@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: William Cohen <wcohen@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 December 2014 at 02:48, David Long <dave.long@linaro.org> wrote:
> On 12/03/14 20:16, William Cohen wrote:
>
> [...]
>
>>
>> The perf issue seems to be independent and can be reproduced without using
>> any kprobe support.  I need to get a simple reproducer and mention it on the
>> linux-perf-user list.
>>
>> -Will
>>
>
>
> OK, my confusion came from all the different things perf can use.  I have
> not yet been able to reproduce the "perf stat" failure, but I do see the
> failure with Steve's example using tracepoints.  I had thought that was
> using kprobes, but apparently it just uses tracepoints.  These look like two
> different failures to me:  One related to tracepoints, and one in the PMU
> driver.
>
> Since this seems unrelated to kprobes I don't plan on pursuing these
> particular problems.
>
> -dl
>

Sorry for the late reply...

The example I had was:
echo "p:memcpy memcpy %x2" > /sys/kernel/debug/tracing/kprobe_events
perf record -e kprobes:memcpy -a sleep 5

[then crash due to IRQs being unexpectedly disabled in the ext4 code]

Isn't that a kprobe problem?

Cheers,
--
Steve
