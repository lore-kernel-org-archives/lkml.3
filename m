Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaH2Afc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 20:35:32 -0400
Received: from regular1.263xmail.com ([211.150.99.133]:40157 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaH2Af2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 20:35:28 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: lorenzo.pieralisi@arm.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <d86b13987a64f09b2ab7c16cbff1a424>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <53FFCAC4.7030702@rock-chips.com>
Date: Fri, 29 Aug 2014 08:35:16 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "heiko@sntech.de" <heiko@sntech.de>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "wulf@rock-chips.com" <wulf@rock-chips.com>,
        "lyz@rock-chips.com" <lyz@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lorenzo.pieralisi@arm.com
Subject: Re: [RESEND PATCH] ARM: dts: make arch-timer always on in rk3288
 soc
References: <1409190017-12656-1-git-send-email-kever.yang@rock-chips.com> <20140828091758.GB14650@leverpostej> <20140828151121.GM14650@leverpostej>
In-Reply-To: <20140828151121.GM14650@leverpostej>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

     Thanks for your reply and advice.

On 08/28/2014 11:11 PM, Mark Rutland wrote:
> On Thu, Aug 28, 2014 at 10:17:58AM +0100, Mark Rutland wrote:
>> Hi Kever,
>>
>> On Thu, Aug 28, 2014 at 02:40:17AM +0100, Kever Yang wrote:
>>> We need use the hrtimer, which need the arch-timer to be 'always-on'
>> I asked a question on the last posting [1]. Can you please confirm
>> either way?
>>
>> Thanks,
>> Mark.
>>
>> [1] lists.infradead.org/pipermail/linux-arm-kernel/2014-August/282327.html
> To clarify: if there are low power states that the CPU can enter where
> we lose state, then this patch isn't correct.
rk3288 has low power state and may turn off the cpu power domain
which will lost any logic state in cpu.
>
> A more general approach would be to enable the broadcast hrtimer for
> arm, as has been done for arm64.
>
> See commit 5d1638acb9f6 (tick: Introduce hrtimer based broadcast) which
> introduced the broadcast hrtimer, and commit 9358d755bd5c (arm64:
> kernel: initialize broadcast hrtimer based clock event device) which
> added the requisite plumbing for arm64.
I'll going to implement this and send another patch.

Thanks.

-Kever

