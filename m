Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab3C1SkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:40:14 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:40704 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab3C1SkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:40:12 -0400
Message-ID: <51548E89.9060505@gmail.com>
Date: Thu, 28 Mar 2013 13:40:09 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: irq: Call irqchit_init if no init_irq function
 is specified
References: <1364463704-13692-1-git-send-email-maxime.ripard@free-electrons.com> <1364463704-13692-2-git-send-email-maxime.ripard@free-electrons.com> <51545832.1050504@gmail.com> <20130328145155.GB3368@n2100.arm.linux.org.uk>
In-Reply-To: <20130328145155.GB3368@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 09:51 AM, Russell King - ARM Linux wrote:
> On Thu, Mar 28, 2013 at 09:48:18AM -0500, Rob Herring wrote:
>> On 03/28/2013 04:41 AM, Maxime Ripard wrote:
>>> +	if (machine_desc->init_irq)
>>> +		machine_desc->init_irq();
>>> +	else
>>> +		irqchip_init();
>>
>> There needs to be an empty version defined for !OF.
> 
> Better:
> 
> #ifdef CONFIG_OF
> 	if (!machine_desc->init_irq)
> 		irqchip_init();
> 	else
> #endif

Or the new style:

	if (IS_ENABLED(CONFIG_OF) && !machine_desc->init_irq)
		irqchip_init();
	else

That needs the empty version, but handles your case.

Rob

> 		machine_desc->init_irq();
> 
> which means we don't even get the test if !OF, and if someone mistakenly
> sets this to NULL for a !OF platform, they get to know about it.
> 

