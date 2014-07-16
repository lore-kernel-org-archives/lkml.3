Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965216AbaGPOXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:23:52 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:45648 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964901AbaGPOXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:23:50 -0400
Subject: Re: [PATCH v6 2/7] arm64: Introduce VA_BITS and translation level options
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=windows-1252
From: Jungseok Lee <jungseoklee85@gmail.com>
In-Reply-To: <95F7642B-124A-4E03-ACDE-5BF9D70E8E15@arm.com>
Date: Wed, 16 Jul 2014 23:23:42 +0900
Cc: Joel Schopp <joel.schopp@amd.com>, Timur Tabi <timur@codeaurora.org>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "barami97@gmail.com" <barami97@gmail.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Christoffer Dall <christoffer.dall@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <6986494B-04F6-45F0-9C39-303D1F5992D3@gmail.com>
References: <000101cf6dc6$3b93d510$b2bb7f30$@samsung.com> <CAOZdJXWCu-zHuQoAUdiieqsKqCfG9BsZariFqQP=NCgQP-zpNA@mail.gmail.com> <53C43FE3.1050008@amd.com> <20140714224159.GA9829@arm.com> <3AF98E68-6818-416A-BC33-57148F1EC246@gmail.com> <95F7642B-124A-4E03-ACDE-5BF9D70E8E15@arm.com>
To: Catalin Marinas <Catalin.Marinas@arm.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 16, 2014, at 6:44 AM, Catalin Marinas wrote:
> On 15 Jul 2014, at 15:53, Jungseok Lee <jungseoklee85@gmail.com> wrote:
>> On Jul 15, 2014, at 7:41 AM, Catalin Marinas wrote:
>>> On Mon, Jul 14, 2014 at 09:38:59PM +0100, Joel Schopp wrote:
>>>> I agree that these patches would be very useful.  I just rebased my fix
>>>> for a VTTBR_BADDR_MASK bug on one of these patches that could be pulled
>>>> out independently.  See
>>>> https://lists.cs.columbia.edu/pipermail/kvmarm/2014-July/010480.html
>>>> 
>>>> The original author Jungseok Lee is no longer available to work on
>>>> future versions of these patches.  I was thinking that if they didn't
>>>> get picked up as they are that with the original author's blessing I
>>>> would pick them up and keep them forward ported/resubmitted.  I have an
>>>> SOC to test them on.
>>> 
>>> The patches are pretty good. I'll give them a try tomorrow and if there
>>> isn't something fundamental missing I'll consider taking them for 3.17.
>> 
>> Hi All,
>> 
>> If only stage1 side is taken and merged, KVM should be disabled under 4 level
>> lookups with the following configuration adjustment. I've tested it on top of
>> arm64/for-next/core branch and it works fine.
>> 
>> --- a/arch/arm64/kvm/Kconfig
>> +++ b/arch/arm64/kvm/Kconfig
>> @@ -18,6 +18,7 @@ if VIRTUALIZATION
>> 
>> config KVM
>>       bool "Kernel-based Virtual Machine (KVM) support"
>> +       depends on !ARM64_4_LEVELS
>>       select MMU_NOTIFIER
>>       select PREEMPT_NOTIFIERS
>>       select ANON_INODES
>> 
>> However, I don't know whether it does make sense or not.
> 
> I added some patches on top of your series, I hope to be able to post
> them tomorrow. My interim approach was to disable 4-levels if KVM is
> enabled.

Hi Catalin,

Thanks for the work!
I will take a close look at them.

- Jungseok Lee