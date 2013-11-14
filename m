Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab3KNBUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 20:20:34 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19394 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3KNBU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 20:20:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 13 Nov 2013 17:14:45 -0800
Message-ID: <52842553.2080807@nvidia.com>
Date: Thu, 14 Nov 2013 10:20:19 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Pawel Moll <pawel.moll@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Dave Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 0/7] ARM: support for Trusted Foundations secure monitor
References: <1383819106-1400-1-git-send-email-acourbot@nvidia.com> <52828EF5.6090909@wwwdotorg.org> <CAOesGMhatp9ZQr=eTCtQ_9a_E9LXKdTCzJd+P7Sy9Ut9wtvnsA@mail.gmail.com> <5282E068.1070608@nvidia.com> <CAOesGMgcvTFD4u9b7T5HNhuJe_PQyV25Ei++v8hG8AsY_rOdyw@mail.gmail.com>
In-Reply-To: <CAOesGMgcvTFD4u9b7T5HNhuJe_PQyV25Ei++v8hG8AsY_rOdyw@mail.gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2013 02:57 AM, Olof Johansson wrote:
> On Tue, Nov 12, 2013 at 6:14 PM, Alex Courbot <acourbot@nvidia.com> wrote:
>> On 11/13/2013 05:38 AM, Olof Johansson wrote:
>>>
>>> On Tue, Nov 12, 2013 at 12:26 PM, Stephen Warren <swarren@wwwdotorg.org>
>>> wrote:
>>>>
>>>> On 11/07/2013 03:11 AM, Alexandre Courbot wrote:
>>>>>
>>>>> Just a set of small fixes to address the concerns expressed on v9 with
>>>>> the
>>>>> non-prefixed version DT properties. I hope there won't be a need for an
>>>>> eleventh (!) version. :P
>>>>
>>>>
>>>> BTW, this version looks fine to me. On IRC, Olof said it looked OK to
>>>> him. I'm just waiting to hear back from Olof/Russell whether I should
>>>> merge this through the Tegra tree, or whether the first 1-3 patches
>>>> should go through Russell's tree.
>>>
>>>
>>> I pinged Russell, and he brought up the fact that there were earlier
>>> requests to move it to drivers/firmware. It would make sense to try to
>>> get that done before merging, especially if you anticipate someone
>>> using TF on 64-bit platforms.
>>
>>
>> IIRC when we discussed this point your last comment was as follows:
>
> Touche. :) Thanks for the reminder.
>
>> On Tue, Oct 29, 2013 at 6:55 AM, Olof Johansson <olof@lixom.net> wrote:
>>> I think we can probably merge this under arch/arm now, and when we
>>> figure out what needs to be common with ARM64 we can move it out to a
>>> good location. It might be that mostly just a header file with ABI
>>> conventions needs to be shared, not actual implementation, for
>>> example.
>>
>> So I thought we agreed on that. If in the end we prefer to move the ARM
>> firmware interface into drivers/firmware, I'm fine with that too (Tomasz
>> also confirmed he would be ok with it) but I wonder if that would not be
>> somehow premature.
>>
>> Another worry of mine is that this might delay this patchset some more.
>> Support for TF is one of the last remaining step towards making NVIDIA
>> branded Tegra retail devices (SHIELD and TegraNote at the moment) run
>> upstream directly. I missed 3.13, I'd like to make sure I won't miss 3.14.
>> Would it be acceptable if we move the ARM firmware interface to a common
>> place after this patchset is merged?
>
> Well, as I already said I'm ok with things going into arch/arm to
> start with, as long as Russell is. Once we see 64-bit needs for the
> same we'll move it out -- it's not like it's a whole lot of code to
> start with. But Russell has veto on the topic. :-)

Thanks Olof. Russell, are you ok with the patchset in its current form? 
I can start moving the firmware interface out of arch/arm if that's what 
you want (there is no user outside of ARM at the moment, but as Olof 
pointed out that's not too much code) but I'd really like to see this 
series secured for 3.14.

Thanks,
Alex.
