Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab3ETS4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 14:56:36 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:58834 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068Ab3ETS4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 14:56:35 -0400
Message-ID: <519A71D0.7090103@free-electrons.com>
Date: Mon, 20 May 2013 20:56:16 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 00/10] clk: mvebu: restructure SoC clock drivers
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130516184658.0650f838@skate> <20130520175827.GC31290@titan.lakedaemon.net> <20130520201549.475e50d0@skate>
In-Reply-To: <20130520201549.475e50d0@skate>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 08:15 PM, Thomas Petazzoni wrote:
> Dear Jason Cooper,
> 
> On Mon, 20 May 2013 13:58:27 -0400, Jason Cooper wrote:
> 
>>> I've tested on Armada 370 DB (after reverting the ARM core patch
>>> that prevents this platform from booting) and the Armada XP DB.
>>> Both boards boot fine, and detect PCIe devices as they should.
>>>
>>> There is some conflict between this set of commits and the two
>>> commits that modify the PCIe clocks in my PCIe series. I've pushed
>>> a branch at
>>> https://github.com/MISL-EBU-System-SW/mainline-public/tree/marvell-pcie-v10-and-seb-clks
>>> which has the mvebu PCIe stuff + Sebastian patches on top of it,
>>> with the conflicts resolved. The tricky thing is that since
>>> Sebastian is adding new clock files, and then removing the old
>>> ones, it's pretty easy to "loose" the changes the two PCIe clock
>>> patches are doing. The branch above works on Armada 370/XP, so you
>>> can compare the clock files if needed.
>>
>> hmm, in my haste yesterday, I did this in the opposite order (clk,
>> then pcie on top).  I'm going to reshuffle them because I don't want
>> pcie depending on and waiting for this clock series to be ready :)
> 
> Ok. Either way is fine with me, but it's true that chronologically, the
> PCIe stuff has been around for way more time than the clk
> restructure patches.
> 
>> The good news is everything (except kirkwood-pcie, ran out of time)
>> made it through linux-next!  Also, kisskb is now building
>> mvebu_defconfig in addition to all the other ones.
> 
> Ok. Gregory can give more details, but I believe we are also building
> daily linux-next and Linus master for the mvebu_defconfig.

Indeed every day we build linux-next for the mvebu_defconfig and for
multi_v7_defconfig (as mvebu is part of it). You can see the status here:

http://jenkins.free-electrons.com/job/linux-next/

However we don't build Linus master but we could add it.


> 
> Best regards,
> 
> Thomas
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
