Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab3C0L2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:28:52 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:25615 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab3C0L2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:28:51 -0400
Message-ID: <5152D7EA.3030900@atmel.com>
Date: Wed, 27 Mar 2013 12:28:42 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Olof Johansson <olof@lixom.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] at91: fixes for 3.9-rc #2
References: <51517592.5010300@atmel.com> <201303261022.39882.arnd@arndb.de> <51517EEB.7030709@atmel.com> <201303261105.22173.arnd@arndb.de>
In-Reply-To: <201303261105.22173.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 12:05 PM, Arnd Bergmann :
> On Tuesday 26 March 2013, Nicolas Ferre wrote:
>> Indeed, at first sight its looks like a nice solution. But I wonder if
>> we add several nodes in this kind of .dtsi files, we may end up with
>> mess between APB peripherals and board specific ones like leds, NAND, etc.
>> Moreover, the plain and full naming of the node makes it identifiable
>> without doubts, even someone not completely familiar with DT.
>>
>> I slightly prefer to keep it like this, but I can still change my mind ;-)
> 
> If you don't want to use the labels, it's probably better to drop from
> the dtsi files. I think you can also write 
> 
> ahb/apb/ethernet@802c000 {
> 	phy-mode = "rmii";
>         status = "okay";
> };
> 
> although I think most people prefer the labels, and I have not tried
> the above.
> 
> Back to the bug fix, I think we can have a simpler version for 3.9
> if you just mark the ethernet node as "disabled" in the 
> at91sam9g15.dtsi file,

It will not work, the at91sam9g15.dtsi is included before the buggy
at91sam9x5ek.dtsi in the board .dts file.

Modifying only the at91sam9g15ek.dts and disabling it there will create
an awful mess:
macb0:
at91sam9x5.dtsi: status = "disabled";
at91sam9x5ek.dtsi: status = "okay";   <<-- bug!
at91sam9g15ek.dts: status = "disabled"; <<-- fix?

> and then do the patch to change the default
> in an add-on patch for 3.10.

If it is too late for this kernel revision, I would prefer to postpone
this modification and tag it for "stable" than have to deal with this
issue twice...

Bye,
-- 
Nicolas Ferre
