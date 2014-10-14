Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbaJNVuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:50:19 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:42796 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaJNVuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:50:17 -0400
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <140db6c7deacc618794ea956931ff028>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <543D9A8F.3040304@rock-chips.com>
Date: Tue, 14 Oct 2014 14:50:07 -0700
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?windows-1252?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Doug Anderson <dianders@chromium.org>
CC: Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 4/6] ARM: rockchip: add basic smp support for rk3288
References: <1413231122-1770-1-git-send-email-kever.yang@rock-chips.com> <1413231122-1770-5-git-send-email-kever.yang@rock-chips.com> <CAD=FV=WGnE3fBfzLGN_x8dFqq4RV=OnVAyUgRQheMiyG4U7TkQ@mail.gmail.com> <1453932.GC4UXrUPRz@phil>
In-Reply-To: <1453932.GC4UXrUPRz@phil>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

On 10/14/2014 02:23 PM, Heiko Stübner wrote:
> Am Dienstag, 14. Oktober 2014, 13:24:03 schrieb Doug Anderson:
>> Kever,
>>
>> On Mon, Oct 13, 2014 at 1:12 PM, Kever Yang <kever.yang@rock-chips.com>
> wrote:
>>> +       /*
>>> +        * We need to soft reset the cpu when we turn off the cpu power
>>> domain, +        * or else the active processors might be stalled when
>>> the individual +        * processor is powered down.
>>> +        */
>>> +       if (read_cpuid_part_number() != ARM_CPU_PART_CORTEX_A9) {
>> I haven't done a full review of this patch, but it seems unlikely that
>> your uses of read_cpuid_part_number() and read_cpuid_part() in this
>> patch are correct.  You use both functions and in both cases compare
>> the results to ARM_CPU_PART_CORTEX_A9.
> I think read_cpuid_part() would be the correct one, as it does
You are right, read_cpuid_part() is correct one on kernel next,
I mix up 3.14 kernel and next tree, only read_cpuid_part_number() is 
available
in 3.14 kernel.

I will correct it in my next version, any other changes needed for new 
version?

- Kever.
