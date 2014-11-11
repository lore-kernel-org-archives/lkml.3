Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaKKXjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 18:39:48 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:38020 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaKKXjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 18:39:46 -0500
Message-ID: <54629E4A.7050201@wwwdotorg.org>
Date: Tue, 11 Nov 2014 16:39:54 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Thierry Reding <thierry.reding@gmail.com>
CC: Alexandre Courbot <gnurou@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        gregkh@linux-foundation.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH] ARM: dts: tegra: move serial aliases to per-board
References: <1415738970-7963-1-git-send-email-olof@lixom.net>	<54627C1F.9050200@wwwdotorg.org> <CAOesGMh_8Ft=DKqm=e0fQdREC4aLmAAp3N0QyNsqWn2_rCbmnA@mail.gmail.com>
In-Reply-To: <CAOesGMh_8Ft=DKqm=e0fQdREC4aLmAAp3N0QyNsqWn2_rCbmnA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 03:45 PM, Olof Johansson wrote:
> [again in plain text mode. Sigh]
>
>
> On Tue, Nov 11, 2014 at 1:14 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 11/11/2014 01:49 PM, Olof Johansson wrote:
>>>
>>> There are general changes pending to make the /aliases/serial* entries
>>> number the serial ports on the system. On tegra, so far the ports have
>>> been
>>> just numbered dynamically as they are configured so that makes them
>>> change.
>>>
>>> To avoid this, add specific aliases per board to keep the old numbers.
>>> This
>>> allows us to change the numbering by default on future SoCs while keeping
>>> the
>>> numbering on existing boards.
>>
>>
>> This change seems mostly OK to me. FWIW though, I had suggested this
>> approach when the UART aliases were first added, and Laxman disagreed with
>> it. See commit b6551bb933f9 "ARM: tegra: dts: add aliases and DMA requestor
>> for serial controller", and its discussion:
>> https://lkml.org/lkml/2012/12/25/4. I've CC'd Laxman in case he still
>> objects.
>>
>>> Signed-off-by: Olof Johansson <olof@lixom.net>
>>> ---
>>>
>>> Stephen/Thierry/Alex, as noticed this week we really should try to get
>>> this in before the 3.19 merge window so that the global aliases change
>>> can happen there without regression.
>>
>>
>> How did we resolve the issue that patch causes with old DTs; namely that it
>> causes a change in behaviour for those old DTs? On IRC, I'd wondered whether
>> we should set a flag so the kernel ignored aliases for boards containing
>> currently upstreamed Tegra SoCs so that issue wouldn't occur. If we did
>> that, we wouldn't need this patch.
>
> Another way could be to remove aliases from the kernel side during
> booting if they're found. Anyway, feel free to send a patch to do that
> if that's your preference.

That would work too.

I'll let Thierry make the call re: whether it's important to support old 
DTs with the current aliase content without a change in device names 
when booted on a newer kernel. If not, as I mentioned, I'm fine with 
this patch.

