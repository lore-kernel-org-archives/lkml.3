Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbaGOVq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:46:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39834 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546AbaGOVqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:46:15 -0400
From: Catalin Marinas <Catalin.Marinas@arm.com>
To: Jungseok Lee <jungseoklee85@gmail.com>
CC: Joel Schopp <joel.schopp@amd.com>, Timur Tabi <timur@codeaurora.org>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "barami97@gmail.com" <barami97@gmail.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Christoffer Dall <christoffer.dall@linaro.org>
Date: Tue, 15 Jul 2014 22:44:56 +0100
Subject: Re: [PATCH v6 2/7] arm64: Introduce VA_BITS and translation level
 options
Thread-Topic: [PATCH v6 2/7] arm64: Introduce VA_BITS and translation level
 options
Thread-Index: Ac+gdgVDJMPieG9/QXGgc+RR0bnw/g==
Message-ID: <95F7642B-124A-4E03-ACDE-5BF9D70E8E15@arm.com>
References: <000101cf6dc6$3b93d510$b2bb7f30$@samsung.com>
 <CAOZdJXWCu-zHuQoAUdiieqsKqCfG9BsZariFqQP=NCgQP-zpNA@mail.gmail.com>
 <53C43FE3.1050008@amd.com> <20140714224159.GA9829@arm.com>
 <3AF98E68-6818-416A-BC33-57148F1EC246@gmail.com>
In-Reply-To: <3AF98E68-6818-416A-BC33-57148F1EC246@gmail.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
MIME-Version: 1.0
X-MC-Unique: 114071522445905602
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Jul 2014, at 15:53, Jungseok Lee <jungseoklee85@gmail.com> wrote:
> On Jul 15, 2014, at 7:41 AM, Catalin Marinas wrote:
>> On Mon, Jul 14, 2014 at 09:38:59PM +0100, Joel Schopp wrote:
>>> I agree that these patches would be very useful.  I just rebased my fix
>>> for a VTTBR_BADDR_MASK bug on one of these patches that could be pulled
>>> out independently.  See
>>> https://lists.cs.columbia.edu/pipermail/kvmarm/2014-July/010480.html
>>>
>>> The original author Jungseok Lee is no longer available to work on
>>> future versions of these patches.  I was thinking that if they didn't
>>> get picked up as they are that with the original author's blessing I
>>> would pick them up and keep them forward ported/resubmitted.  I have an
>>> SOC to test them on.
>>
>> The patches are pretty good. I'll give them a try tomorrow and if there
>> isn't something fundamental missing I'll consider taking them for 3.17.
>
> Hi All,
>
> If only stage1 side is taken and merged, KVM should be disabled under 4 level
> lookups with the following configuration adjustment. I've tested it on top of
> arm64/for-next/core branch and it works fine.
>
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -18,6 +18,7 @@ if VIRTUALIZATION
>
> config KVM
>        bool "Kernel-based Virtual Machine (KVM) support"
> +       depends on !ARM64_4_LEVELS
>        select MMU_NOTIFIER
>        select PREEMPT_NOTIFIERS
>        select ANON_INODES
>
> However, I don't know whether it does make sense or not.

I added some patches on top of your series, I hope to be able to post
them tomorrow. My interim approach was to disable 4-levels if KVM is
enabled.

> In other words, stage2 side should be prepared to fully support 4 level lookups.
>
> In order to cover all combinations of host and guest, VTTBR_X should be determined
> dynamically as referring to hardware capability. At this point, the patches have
> been revised many times, but they don't have got ACKs from Christoffer and Marc yet.
>
> That is why the patches are pending now in the author's point of view.

I have some clean-up for stage 1 on top but nothing major.

Catalin

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

ARM Limited, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2557590
ARM Holdings plc, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2548782

