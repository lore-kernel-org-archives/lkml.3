Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaJOGtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 02:49:18 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:47513 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaJOGtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 02:49:17 -0400
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: linux-arm-kernel@lists.infradead.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <39732319571a34ef279421183576820c>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <543E18E3.3080502@rock-chips.com>
Date: Tue, 14 Oct 2014 23:49:07 -0700
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: =?windows-1252?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Doug Anderson <dianders@chromium.org>,
        Tao Huang <huangtao@rock-chips.com>, Addy Ke <addy.ke@rock-chips.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rockchip@lists.infradead.org, Jianqun Xu <xjq@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, han jiang <hj@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 4/6] ARM: rockchip: add basic smp support for rk3288
References: <1413231122-1770-1-git-send-email-kever.yang@rock-chips.com> <1413231122-1770-5-git-send-email-kever.yang@rock-chips.com> <CAD=FV=WGnE3fBfzLGN_x8dFqq4RV=OnVAyUgRQheMiyG4U7TkQ@mail.gmail.com> <1453932.GC4UXrUPRz@phil> <543D9A8F.3040304@rock-chips.com> <20141014233756.GH27405@n2100.arm.linux.org.uk>
In-Reply-To: <20141014233756.GH27405@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On 10/14/2014 04:37 PM, Russell King - ARM Linux wrote:
> On Tue, Oct 14, 2014 at 02:50:07PM -0700, Kever Yang wrote:
>> Heiko,
>>
>> On 10/14/2014 02:23 PM, Heiko Stübner wrote:
>>> Am Dienstag, 14. Oktober 2014, 13:24:03 schrieb Doug Anderson:
>>>> Kever,
>>>>
>>>> On Mon, Oct 13, 2014 at 1:12 PM, Kever Yang <kever.yang@rock-chips.com>
>>> wrote:
>>>>> +       /*
>>>>> +        * We need to soft reset the cpu when we turn off the cpu power
>>>>> domain, +        * or else the active processors might be stalled when
>>>>> the individual +        * processor is powered down.
>>>>> +        */
>>>>> +       if (read_cpuid_part_number() != ARM_CPU_PART_CORTEX_A9) {
>>>> I haven't done a full review of this patch, but it seems unlikely that
>>>> your uses of read_cpuid_part_number() and read_cpuid_part() in this
>>>> patch are correct.  You use both functions and in both cases compare
>>>> the results to ARM_CPU_PART_CORTEX_A9.
>>> I think read_cpuid_part() would be the correct one, as it does
>> You are right, read_cpuid_part() is correct one on kernel next,
>> I mix up 3.14 kernel and next tree, only read_cpuid_part_number() is
>> available
>> in 3.14 kernel.
>>
>> I will correct it in my next version, any other changes needed for new
>> version?
> You need to at the _very_ _minimum_ build test your code against a
> recent kernel, and preferably test it to make sure that it works as
> you intend.
Thanks for you advice, I'll be more careful next time.

I'm sorry for not test this patch with rk3188(A9 based) board,
I do have test it on top of kernel next with my rk3288 evb(not A9 based),
and I didn't get any warning for read_cpuid_part_number()
during building the image.

- Kever
>
> Developing on such an old kernel version, and hoping that the code is
> going to be correct for later kernels isn't a nice idea.
>

