Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3KLOMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:12:00 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51524 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3KLOLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:11:55 -0500
Message-ID: <52823728.1070003@hitachi.com>
Date: Tue, 12 Nov 2013 23:11:52 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "srikar@linux.vnet.ibm.com" <srikar@linux.vnet.ibm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>,
        Jiang Liu <liuj97@gmail.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: Re: Re: Re: Re: [PATCH RFC 2/6] arm64: Kprobes with single
 stepping support
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org> <1382008671-4515-3-git-send-email-sandeepa.prabhu@linaro.org> <20131108165639.GD15074@mudshark.cambridge.arm.com> <527DFC1C.1020107@hitachi.com> <CA+b37P3U=cAbUvs=2B9wA4F7S9o49vh7d-KamjPsHcz-b9ZYLA@mail.gmail.com> <52808D53.7080904@hitachi.com> <5280B6C8.7050807@hitachi.com> <20131111105812.GC28302@mudshark.cambridge.arm.com> <528114C4.5000506@hitachi.com> <CA+b37P08cLAvBYAXSkozLPzrpuXn=N0SUetwL6N8JL+10AtYjQ@mail.gmail.com> <5281D848.7000502@hitachi.com> <CA+b37P2EgB0toYwhLny8k-cbrziBVXURST5kHNXcY7AF-CNVLg@mail.gmail.com> <52820043.6090107@hitachi.com> <CA+b37P1xLYWA-a0PwgxT7S7dNr5TdGFscLYFeQhAQUyO_E=Mzw@mail.gmail.com>
In-Reply-To: <CA+b37P1xLYWA-a0PwgxT7S7dNr5TdGFscLYFeQhAQUyO_E=Mzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/12 19:55), Sandeepa Prabhu wrote:
>>>>> Thanks for steps, ARM64 ftrace patches are under review on arm mailing
>>>>> list, I can contact the (linaro) developer implementing ftrace on
>>>>> what's supported and then figure-out a way to test this concurrency of
>>>>> kprobes breakpoint and hardware breakpoint.
>>>>
>>>> Would you mean this? :)
>>>> http://www.spinics.net/lists/arm-kernel/msg278477.html
>>>>
>>>> Wow, it seems that this also has some works around instruction
>>>> manipulation (and confusable filenames...)
>>> I referred to: http://lwn.net/Articles/572323/  which is another
>>> implementation and on LAKML
>>
>> OK, I'll check that (and looks good at a glance).
>> By the way, I concern about Linaro guys who looks working a bit far
>> from the LKML and original feature maintainers. Please contact them,
>> I'm sure they don't bite your hand :)
> Hmm sure, will convey to our developers/leads :-)

Nice :)

>> BTW, I'm currently trying a general housecleaning of __kprobes
>> annotations. It may also have impact on your patch.
>> https://lkml.org/lkml/2013/11/8/187
> Hmm, we can help testing your patchset on arm64 platforms. Also have
> many doubts on the changes you are working [blacklisting probes etc]
> 
> Basically I had tried placing kprobe on memcpy() and the model hung
> (insmod never returned back!). Fast-model I have does not have option
> of any debug so no clue what happened!.

On x86, I can probe memcpy() safely. It depends on the kprobes (and
breakpoint handling) implementation, and it could be found.

> memcpy() is low-level call being used internally within kprobes, so
> probably we cannot handle probe on that routine, but then how to make
> sure all such API are rejected by kprobe sub-system ?

I see, the blacklist still needs to be maintained. I periodically
run a test for probing each function on my kernel, and if I found
such problem, I added it on the blacklist.
Currently I run the test only on x86, so perhaps, other arch does
not have well tested yet.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


