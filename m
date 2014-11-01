Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaKAWtJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:49:09 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:53149 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaKAWsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:48:38 -0400
Message-ID: <54556341.6040506@gmail.com>
Date: Sat, 01 Nov 2014 23:48:33 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benoit Masson <yahoo@perenite.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Armada XP pinctrl consolidation and ix4-300d fixes
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com> <20141101223625.GB3698@titan.lakedaemon.net>
In-Reply-To: <20141101223625.GB3698@titan.lakedaemon.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.11.2014 23:36, Jason Cooper wrote:
> On Fri, Sep 19, 2014 at 10:14:36PM +0200, Sebastian Hesselbarth wrote:
>> this is a patch set preparing barebox support for ix4-300d. As usual,
>> I stumbled upon a few nice-to-haves before actually touching ix4-300d
>> dts. As it is a mach-mvebu thing, I just added the related mailing
>> lists instead of each of the DT maintainers.
>>
>> First 5 patches consolidate SoC-specific pinctrl nodes to one common
>> node in armada-xp.dtsi, compatible overwrites for each SoC, and node
>> alias usage for each board. Also, ge{0,1} pinctrl settings are moved
>> to the common node from one board specific node.
>>
>> Last 3 patches then use that ge{0,1} pinctrl settings on ix4-300d which
>> is vital for bootloader init. During exploration of ix4-300d, I also
>> found a i2c eeprom that has not been added to the dts, yet. Finally,
>> there is only one 74hc595 on ix4 mainboard while dts property is set
>> for two.
>>
>> I cannot recall in detail what is on that eeprom, but IIRC it is nothing
>> important. Some reg,addr pairs for some init stuff that should have
>> already been done by stock u-boot. Anyway, adding the node will do no
>> harm.
>>
>> Patches are based on v3.17-rc1 and intended for v3.18 but I am not in
>> a hurry. I only compile tested this, so a formal Tested-by from Benoit
>> for the ix4 and any other Armada XP board would be great.
>
> I lost track of this thread, are you resending?  Did Benoit get a
> successful test run?

Looks like there was this A0 stepping thing, but basically yes

http://www.spinics.net/lists/devicetree/msg53364.html

I have just rebased it on top of v3.18-rc1, feel free to pick them
up from

git://git.infradead.org/users/hesselba/linux-berlin.git devel/mvebu/ix4-300d
git://git.infradead.org/users/hesselba/linux-berlin.git
Sebastian
