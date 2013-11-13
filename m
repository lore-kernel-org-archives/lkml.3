Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399Ab3KMR6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:58:06 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:48460 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab3KMR55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:57:57 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <5282E068.1070608@nvidia.com>
References: <1383819106-1400-1-git-send-email-acourbot@nvidia.com>
	<52828EF5.6090909@wwwdotorg.org>
	<CAOesGMhatp9ZQr=eTCtQ_9a_E9LXKdTCzJd+P7Sy9Ut9wtvnsA@mail.gmail.com>
	<5282E068.1070608@nvidia.com>
Date: Wed, 13 Nov 2013 09:57:57 -0800
Message-ID: <CAOesGMgcvTFD4u9b7T5HNhuJe_PQyV25Ei++v8hG8AsY_rOdyw@mail.gmail.com>
Subject: Re: [PATCH v10 0/7] ARM: support for Trusted Foundations secure monitor
From: Olof Johansson <olof@lixom.net>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 6:14 PM, Alex Courbot <acourbot@nvidia.com> wrote:
> On 11/13/2013 05:38 AM, Olof Johansson wrote:
>>
>> On Tue, Nov 12, 2013 at 12:26 PM, Stephen Warren <swarren@wwwdotorg.org>
>> wrote:
>>>
>>> On 11/07/2013 03:11 AM, Alexandre Courbot wrote:
>>>>
>>>> Just a set of small fixes to address the concerns expressed on v9 with
>>>> the
>>>> non-prefixed version DT properties. I hope there won't be a need for an
>>>> eleventh (!) version. :P
>>>
>>>
>>> BTW, this version looks fine to me. On IRC, Olof said it looked OK to
>>> him. I'm just waiting to hear back from Olof/Russell whether I should
>>> merge this through the Tegra tree, or whether the first 1-3 patches
>>> should go through Russell's tree.
>>
>>
>> I pinged Russell, and he brought up the fact that there were earlier
>> requests to move it to drivers/firmware. It would make sense to try to
>> get that done before merging, especially if you anticipate someone
>> using TF on 64-bit platforms.
>
>
> IIRC when we discussed this point your last comment was as follows:

Touche. :) Thanks for the reminder.

> On Tue, Oct 29, 2013 at 6:55 AM, Olof Johansson <olof@lixom.net> wrote:
>> I think we can probably merge this under arch/arm now, and when we
>> figure out what needs to be common with ARM64 we can move it out to a
>> good location. It might be that mostly just a header file with ABI
>> conventions needs to be shared, not actual implementation, for
>> example.
>
> So I thought we agreed on that. If in the end we prefer to move the ARM
> firmware interface into drivers/firmware, I'm fine with that too (Tomasz
> also confirmed he would be ok with it) but I wonder if that would not be
> somehow premature.
>
> Another worry of mine is that this might delay this patchset some more.
> Support for TF is one of the last remaining step towards making NVIDIA
> branded Tegra retail devices (SHIELD and TegraNote at the moment) run
> upstream directly. I missed 3.13, I'd like to make sure I won't miss 3.14.
> Would it be acceptable if we move the ARM firmware interface to a common
> place after this patchset is merged?

Well, as I already said I'm ok with things going into arch/arm to
start with, as long as Russell is. Once we see 64-bit needs for the
same we'll move it out -- it's not like it's a whole lot of code to
start with. But Russell has veto on the topic. :-)

Russell still has his pull requests outstanding so I'm not sure where
things are at, but I don't think this will miss 3.14 at this rate.


-Olof
