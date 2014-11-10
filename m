Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaKJJRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:17:33 -0500
Received: from service87.mimecast.com ([91.220.42.44]:38168 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaKJJRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:17:31 -0500
Message-ID: <546082A8.60401@arm.com>
Date: Mon, 10 Nov 2014 09:17:28 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: AMR: sun7i: CPU hotplug support?
References: <545FC215.7010802@web.de> <20141109231744.GC2989@lukather> <5460554A.1060701@web.de> <5460766B.8070000@web.de>
In-Reply-To: <5460766B.8070000@web.de>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 10 Nov 2014 09:17:29.0314 (UTC) FILETIME=[2696C420:01CFFCC7]
X-MC-Unique: 114111009172909401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/14 08:25, Jan Kiszka wrote:
> On 2014-11-10 07:03, Jan Kiszka wrote:
>> On 2014-11-10 00:17, Maxime Ripard wrote:
>>> Hi Jan,
>>> 
>>> On Sun, Nov 09, 2014 at 08:35:49PM +0100, Jan Kiszka wrote:
>>>> did anyone already happen to look into enabling CPU hotplug
>>>> for the Allwinner A20 in upstream? I'm currently running the
>>>> sunxi-next branch on Banana Pi, and echo 0 > .../cpu1/online
>>>> just hangs the system. The old 3.4 LeMaker kernel works fine
>>>> in this regard. I can try to look into details and port
>>>> things over, just want to avoid duplicate efforts.
>>> 
>>> Having hotplug support would indeed be very welcome.
>>> 
>>> However, it should be done in u-boot, through PSCI, and not in
>>> the kernel itself.
>>> 
>>> As far as I'm aware, no one worked actively on it, beside some
>>> WIP commit from Marc a while ago: 
>>> https://git.kernel.org/cgit/linux/kernel/git/maz/u-boot.git/commit/?h=wip/psci&id=45379c0f9cf812f0f62722f4015ec907fa5dc144
>>
>>
>>> 
OK - I guess I will need a little guidance in then: Is there a good
>> reference board to study and to derive from? And maybe also: What
>> is missing or not working in that u-boot branch? If I get this
>> interface right, I just takes some device tree bits to enable
>> this for the kernel afterward, correct?
> 
> Started to play with that patch in naive ways: CPU0 locks up when 
> offlining CPU1 - unless I disable the FIQ signal from CPU1. Then
> it "works", both offlining and onlining again. However, I suspect
> that this only parks CPU1 in wfi and does not do anything
> interesting to it.

Here's how this is supposed to work:
- CPU1 sends a FIQ to CPU0, bringing it into secure mode.
- CPU0 then kills CPU1 by doing the magic incantations on the power
controller

What is missing here is all the cache cleaning before signalling CPU0.
If you add that, things should look a lot better (patches welcome).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

