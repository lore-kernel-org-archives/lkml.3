Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaKGQGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:06:22 -0500
Received: from down.free-electrons.com ([37.187.137.238]:60311 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751322AbaKGQGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:06:20 -0500
Date: Fri, 7 Nov 2014 17:06:16 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v2] watchdog: at91rm9200 remove mach/ header dependency
Message-ID: <20141107170616.21f335ca@bbrezillon>
In-Reply-To: <1415366564-25408-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1415366564-25408-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On Fri,  7 Nov 2014 14:22:44 +0100
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> Remove the mach/ header dependency by including the necessary macros and taking
> the appropriate resources from the system timer.
> 
> Also change the name to avoid conflicting with the at91sam9 watchdog driver and
> allow to compile both the at91rm920 and at91sam9 watchdog drivers at the same
> time.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
> 
> Changes in v2:
>  - squashed both patches in one

[...]

> +
>  	res = misc_register(&at91wdt_miscdev);
>  	if (res)
>  		return res;
> @@ -267,7 +308,7 @@ static struct platform_driver at91wdt_driver = {
>  	.suspend	= at91wdt_suspend,
>  	.resume		= at91wdt_resume,
>  	.driver		= {
> -		.name	= "at91_wdt",
> +		.name	= "at91rm9200_wdt",
>  		.owner	= THIS_MODULE,
>  		.of_match_table = at91_wdt_dt_ids,

Shouldn't we avoid attaching this driver to the "atmel,at91rm9200-wdt"
compatible string ?
What I mean is that the watchdog should not be represented as a device
node under the apb bus, because it's actually a subdevice of the ST
(System Timer) block, neither it should be declared at the root of the
DT because it's not an external peripheral.
Given those constraints I don't know where we could put the watchdog
node...

I know that removing this of_match_table assignment would break the
existing binding, but nobody is currently using it (at least nobody is
using it in mainline).

Can't we use an MFD to create the watchdog platform device instead of
declaring this node at a random place ?

Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
