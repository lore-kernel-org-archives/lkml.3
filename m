Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab3CZK4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 06:56:51 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:60451 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab3CZK4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 06:56:50 -0400
Message-ID: <51517EEB.7030709@atmel.com>
Date: Tue, 26 Mar 2013 11:56:43 +0100
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
References: <51517592.5010300@atmel.com> <201303261022.39882.arnd@arndb.de>
In-Reply-To: <201303261022.39882.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 11:22 AM, Arnd Bergmann :
> On Tuesday 26 March 2013, Nicolas Ferre wrote:
>> Another "fixes" pull-request for AT91 on top of material that you have already
>> taken. Fixes are manly typos but the bad node declaration and some misspelling
>> can cause confusion.
> 
> Hi Nicolas,
> 
> I'd prefer to take only fixes for serious bugs into 3.9 now, since I have
> already sent the fixes for -rc5. As far as I can tell, the macb node patch
> is the only one that falls into that category

Yes, fine, I stack them for 3.10 then.


> , but for that one, I'd
> prefer if it could be redone in a simpler way, by replacing
> 
> +       ahb {
> +               apb {
> +                       macb0: ethernet@f802c000 {
> +                               phy-mode = "rmii";
> +                               status = "okay";
> +                       };
> +               };
> +       };
> 
> 
> with
> 
> 	@macb0 {
> 		phy-mode = "rmii";
> 		status = "okay";
> 	}
> 
> as there is no need to provide the full path when you already have
> a label for the device.

Indeed, at first sight its looks like a nice solution. But I wonder if
we add several nodes in this kind of .dtsi files, we may end up with
mess between APB peripherals and board specific ones like leds, NAND, etc.
Moreover, the plain and full naming of the node makes it identifiable
without doubts, even someone not completely familiar with DT.

I slightly prefer to keep it like this, but I can still change my mind ;-)

Bye,
-- 
Nicolas Ferre
