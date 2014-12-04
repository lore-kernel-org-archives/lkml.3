Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbaLDKnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:43:51 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58011 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbaLDKnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:43:49 -0500
Message-ID: <54803ADD.2090201@hitachi.com>
Date: Thu, 04 Dec 2014 19:43:41 +0900
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
Subject: Re: Re: [PATCH v3 0/5] ARM64: Add kernel probes(Kprobes) support
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org> <20141120135851.GA32528@linaro.org> <54759041.9080105@hitachi.com> <20141126100325.GA9157@linaro.org> <5476120D.9030703@linaro.org> <CAPvkgC3eVOZEn79C9PC9c7TqC_-yCtDhw5LL6ZWUJxr+oQFaow@mail.gmail.com> <5476BFB4.2020705@hitachi.com> <CAPvkgC0ELPPWfa-8kQ4H_e_O5G1ER4KEKuSWLxh_u-VZgh7W6A@mail.gmail.com> <547C36DB.7060903@hitachi.com> <547F242D.1060705@redhat.com> <547F94B0.1000902@linaro.org> <547FB5DD.901@redhat.com> <547FCB73.1010707@linaro.org> <CAPvkgC3=KKKMa1hWdOYOcV7D7kQSLtnNnXLBB64_P-V+_qUwTw@mail.gmail.com>
In-Reply-To: <CAPvkgC3=KKKMa1hWdOYOcV7D7kQSLtnNnXLBB64_P-V+_qUwTw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/04 19:21), Steve Capper wrote:
> On 4 December 2014 at 02:48, David Long <dave.long@linaro.org> wrote:
>> On 12/03/14 20:16, William Cohen wrote:
>>
>> [...]
>>
>>>
>>> The perf issue seems to be independent and can be reproduced without using
>>> any kprobe support.  I need to get a simple reproducer and mention it on the
>>> linux-perf-user list.
>>>
>>> -Will
>>>
>>
>>
>> OK, my confusion came from all the different things perf can use.  I have
>> not yet been able to reproduce the "perf stat" failure, but I do see the
>> failure with Steve's example using tracepoints.  I had thought that was
>> using kprobes, but apparently it just uses tracepoints.  These look like two
>> different failures to me:  One related to tracepoints, and one in the PMU
>> driver.
>>
>> Since this seems unrelated to kprobes I don't plan on pursuing these
>> particular problems.
>>
>> -dl
>>
> 
> Sorry for the late reply...
> 
> The example I had was:
> echo "p:memcpy memcpy %x2" > /sys/kernel/debug/tracing/kprobe_events
> perf record -e kprobes:memcpy -a sleep 5
> 
> [then crash due to IRQs being unexpectedly disabled in the ext4 code]
> 
> Isn't that a kprobe problem?
> 

It should be a kprobe problem. As I mentioned, if you set a probe on
trace_event_buffer_lock_reserve() instead of memcpy(), the same problem
may happen without using perf. (It is enough enabling the new event to
reproduce the problem, I guess)

The problem what Will reported was different one. He used "perf stat"
which never touch the kprobes itself, and solved in newer kernel (as
he reported)

I'd like to ask you to try my fix on your machine, with my reproducing
methods. (do not use sytemtap nor perf, those can have other issues)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


