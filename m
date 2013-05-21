Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3EUJAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 05:00:41 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:55676 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab3EUJAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 05:00:39 -0400
MIME-Version: 1.0
In-Reply-To: <008d01ce55e9$7c479510$74d6bf30$@lge.com>
References: <519AD82A.6090809@wwwdotorg.org>
	<1369116149-2361-1-git-send-email-neidhard.kim@lge.com>
	<008d01ce55e9$7c479510$74d6bf30$@lge.com>
Date: Tue, 21 May 2013 10:00:37 +0100
X-Google-Sender-Auth: lVAiRcNnGqFK7dDe3dcoOHgAKfE
Message-ID: <CAE8Q9tD8UiV=3sYbPPFGgiPCGzMS6xUWSGCRnR8tpGwQegyEQQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: bcm2835: override the HW UART periphid
From: Gordon Hollingworth <gordon@holliweb.co.uk>
To: Jongsung Kim <neidhard.kim@lge.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, gregkh@linuxfoundation.org,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-rpi-kernel@lists.infradead.org" 
	<linux-rpi-kernel@lists.infradead.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have checked with the designer of the UART block and he confirmed that
the 2835 PL011 contains a 16 deep fifo not 32 deep...

Hardware guys, they can never just leave it alone!!!

Gordon

On 21 May 2013 07:07, Jongsung Kim <neidhard.kim@lge.com> wrote:
> Jongsung Kim <neidhard.kim@lge.com> :
>> diff --git a/arch/arm/boot/dts/bcm2835.dtsi
> b/arch/arm/boot/dts/bcm2835.dtsi
>> index f0052dc..1e12aef 100644
>> --- a/arch/arm/boot/dts/bcm2835.dtsi
>> +++ b/arch/arm/boot/dts/bcm2835.dtsi
>> @@ -44,6 +44,7 @@
>>                       reg = <0x7e201000 0x1000>;
>>                       interrupts = <2 25>;
>>                       clock-frequency = <3000000>;
>> +                     arm,primecell-periphid = <0x00241011>;
>>               };
>>
>>               gpio: gpio {
>
> Stephen, how do you think about this kind of approach instead?
>
>
> _______________________________________________
> linux-rpi-kernel mailing list
> linux-rpi-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rpi-kernel
