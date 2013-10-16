Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934407Ab3JPM7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:59:31 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:63809 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934287Ab3JPM72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:59:28 -0400
Message-ID: <525E8DAD.60801@gmail.com>
Date: Wed, 16 Oct 2013 07:59:25 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Neil Zhang <zhangwm@marvell.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yu Tang <ytang5@marvell.com>, Zhou Zhu <zzhu3@marvell.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [Question] Ask for arm arch timer
References: <175CCF5F49938B4D99B2E3EF7F558EBE49FCEFF280@SC-VEXCH4.marvell.com>
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE49FCEFF280@SC-VEXCH4.marvell.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding Will and Catalin...]

On 10/16/2013 07:39 AM, Neil Zhang wrote:
> Hi Rob,
> I saw your following patch called clocksource_of_init() directly in time_init() for arm64.
> My question is that what should we do if there are some Soc special work need to be done before arch timer can be used?
> Thanks in advance.

If the timer itself is different, then you should have a different DT
compatible string which you can use to trigger additional initialization.

Integration level initialization like enabling clocks would need
something different as no machine descriptors exist for arm64.

Another option would be do the setup in secure world or the bootloader.

Can you be more specific what initialization is needed.

Rob

> commit 0583fe478a7d93be2c814b7e50d6e81c287edfe8
> Author: Rob Herring <rob.herring@calxeda.com>
> Date:   Wed Apr 10 18:27:51 2013 -0500
> 
>     ARM: convert arm/arm64 arch timer to use CLKSRC_OF init
> 
> 
> Best Regards,
> Neil Zhang
> 
> 

