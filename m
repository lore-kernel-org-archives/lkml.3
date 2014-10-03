Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbaJCGuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 02:50:20 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:50611 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaJCGuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 02:50:19 -0400
Message-ID: <542E4721.8040300@collabora.co.uk>
Date: Fri, 03 Oct 2014 08:50:09 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the arm-soc tree
References: <20141002113742.2b521495@canb.auug.org.au> <14357384.nIoLZkacVq@wuerfel>
In-Reply-To: <14357384.nIoLZkacVq@wuerfel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd, Stephen,

On 10/02/2014 04:32 PM, Arnd Bergmann wrote:
> On Thursday 02 October 2014 11:37:42 Stephen Rothwell wrote:
>> After merging the arm-soc tree, today's linux-next build (arm
>> multi_v7_defconfig) failed like this:
>> 
>> arch/arm/boot/dts/exynos5250-snow.dts:13:46: fatal error: dt-bindings/clock/maxim,max77686.h: No such file or directory
>>  #include <dt-bindings/clock/maxim,max77686.h>
>>                                               ^
>> 
>> Caused by commit c04c92ed5614 ("ARM: dts: Add rtc_src clk for s3c-rtc
>> on exynos5250-snow").
>> 
>> Presumably there is some dependency on some tree that someone has
>> forgotten to merge 
>> 
>> I reverted that commit for today.
>> 
>> Which then got to:
>> 
>> /scratch/sfr/next/arch/arm/boot/dts/exynos5420-peach-pit.dts:15:46: fatal error: dt-bindings/clock/maxim,max77802.h: No such file or directory
>>  #include <dt-bindings/clock/maxim,max77802.h>
>>                                               ^
>> compilation terminated.
>> /scratch/sfr/next/arch/arm/boot/dts/exynos5800-peach-pi.dts:15:46: fatal error: dt-bindings/clock/maxim,max77802.h: No such file or directory
>>  #include <dt-bindings/clock/maxim,max77802.h>
>>                                               ^
>> compilation terminated.
>> Error: /scratch/sfr/next/arch/arm/boot/dts/hisi-x5hd2.dtsi:417.21-22 syntax error
>> FATAL ERROR: Unable to parse input tree
>> 
>> Caused by 8bd43b6e6df7 ("ARM: dts: Add rtc_src clk for s3c-rtc on
>> exynos Peach boards").
>> 
>> I give up ... please test your trees better ...
> 
> I'm deeply sorry about that. I actually saw the problem here but was too
> tired to fix it up again by redoing all the merges in our next/late
> branch.
> 

I'm so sorry about the breakage, when I posted this patch I mentioned that
it was meant for the 3.18-rc cycle once 3.18-rc1 was released [0]. Because
it fixes a regression caused by a patch queued in the clock tree for 3.18.
I should had been more explicit about the dependencies to avoid confusions.

> I've changed the for-next branch now to drop all of next/late, I think
> we're better off not sending any of it for 3.18, especially as I found
> some other problems as well.
> 

Do you think that it may be possible to send this for the 3.18-rc cycle
or should it have to wait for 3.19? Without this the real time clock does
not work on the Peach Chromebooks and your next/late branch contains other
fixes as well (e.g: the Exynos USB dr_mode DT patches).

>> I have used the arm-soc tree form next-20141001 for today (which still
>> needs 5 reverts to get it to build :-().
> 
> D'oh. I actually fixed these already last friday in the next/dt branch
> but for some reason forgot to include it in for-next.
> I've made sure that everything is included now.
> 
> 	Arnd
>

Thanks a lot and best regards,
Javier

[0]: https://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg36702.html
