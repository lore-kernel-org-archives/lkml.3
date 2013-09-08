Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105Ab3IHXt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 19:49:58 -0400
Received: from nm6-vm7.access.bullet.mail.bf1.yahoo.com ([216.109.114.150]:33626
	"EHLO nm6-vm7.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847Ab3IHXt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 19:49:57 -0400
X-Yahoo-Newman-Id: 38311.70650.bm@smtp117.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XWVCXskVM1mZVvoQRX.R6wL6cNb4Xtee13_PwgQho3oh6tt
 Fgr3A4_rq.kYxc_xrUrjjRVc5ehqR9mvGZJwjWKnwYeJJbqaRnmxFVnDQ09u
 LT_bZsQGQpzaAQJWx81QQC5i7ikVSzKhQLG.h6SYKBCy34VM9Qo9MtSFZNgY
 LXtciVFq9EJXvxAM77bJ4sxFLdFw.mF4Pk64mwsKm5xc10zV6.FLNQVk_epS
 IxU8EJNRv6tJoa_bI5Q6J2QTy62D4rVieJ6nB1spsoa46GxZ97S0gFo5ysUC
 ZKBGFF.7tspcV5ndKGtmDoXkOdua3EJiicPXbfPKtcvphZmAYCbRdSLP_6Aj
 yVl6GGbZvY.mINEZkCHN.3YS40qYL67QTv_trw1KtO8dJpVy_mFp55_HYF0x
 GxTD5bsho.emKsJBKEt_HYLqGOBUv1gaMj1.ymBK7b6tClufOjB9mIzCH8Iz
 .AEQXd9FjmgvNkvzXxQGw4K.z44x8nxyXq.9dWA8oPf9D2Lf_sHacM1r6DMc
 xqOmUUdztFjR_f0BMHwOXbYufLuTyf55BOOCq5uPXRzh2zNK.j8vzWGDh1km
 vj_xAyRKa1OhGOJqle1gclQyxA6q8pMR1Zbh2fcdBsSQUA8fMEUJjNSEUYQa
 uBGmAta87XzRZNZo7IQ--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with )
        by smtp117.sbc.mail.bf1.yahoo.com with SMTP; 08 Sep 2013 23:49:55 +0000 UTC
Message-ID: <522D0D37.3050500@att.net>
Date: Sun, 08 Sep 2013 18:50:15 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130730 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-gpio <linux-gpio@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: "Virtual" Interrupts -- Need help please
References: <522BC27A.5080303@att.net> <522BCA33.6000701@roeck-us.net>
In-Reply-To: <522BCA33.6000701@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2013 07:52 PM, Guenter Roeck wrote:
> On 09/07/2013 05:19 PM, Daniel Santos wrote:
>> I've posted a number of requests for aid on this and have gotten very 
>> little responses and none that were helpful. I have spent at least 24 
>> hours of research time on this and just a little direction from 
>> somebody who knows this subsystem can help me immensely as the IRQ 
>> subsystem is new to me.
>>
>> This is for the MCP2210 driver (a USB to SPI/GPIO bridge) and my 
>> driver is the first of its class for the Linux kernel, giving me less 
>> to look at as an example.  I intend to use standard drivers for 
>> whatever I have connected at the other end.  For this to work, I need 
>> to supply interrupts for some of these drivers to work correctly.  
>> How do I do this? Every thing else on this driver is ready to go and 
>> my handler functions for this are empty and waiting for some code.
>>
> Not really. Have a look at https://github.com/groeck/diolan even 
> though the SPI part there
> still isn't working and it is far from being acceptable upstream in 
> its current form.
> It also doesn't support interrupts.

Oh, this is wonderful to know!  While I like breaking new ground, I 
certainly don't enjoy doing it when I'm trying to write my first device 
driver and having to learn so many new things.

>
> It is modeled as mfd driver, which I think you might want to consider 
> as well.
>
>> So do i create an IRQ domain and then call generic_handle_irq() from 
>> my URB complete() function? If so, which type of IRQ Domain is 
>> appropriate for this? Unlike typical platform devices, these are 
>> dynamically added and removed throughout the life of the kernel, 
>> adding to the challenge. So, if I understand correctly, my base IRQ 
>> number needs to be dynamically generated.  How should I manage this?
>>
>> Finally, if you have any example drivers that are doing something 
>> similar, that would be SO very helpful as well!
>>
> There are several drivers in drivers/mfd solving the same problem, ie 
> using
> irq domains to pass interrupts to client drivers. Look for 
> irq_domain_add_simple().
> drivers/mfd/tc3589x.c seems to be a good example.

Ahh, wonderful! I was looking at a lot of the code in mfd, but it 
contains so many things that I don't understand yet, so it's been harder 
to be clear on what the driver is doing and why w/o extensive 
examination & study of the subsystems it's using.  This will help!

>
>> I have some secondary (and less important) questions about how to 
>> integrate this with device drivers that want a DT / open firmware 
>> config (which I know almost nothing about at this time), but that can 
>> wait.
>>
> If you look into the mfd subsystem, you may notice that it handles at 
> least some of the complexity
> of interrupt handling as well as devicetree integration. One more 
> reason to use it.
>
> Guenter

Even better, thank you very much!! If this thing had more EEPROM storage 
I would consider using the OF format for it's settings, but I only have 
256 bytes to play with so I'm using a custom compression/encoding.

I'm hoping to present this for an initial review in a month or so. I'm 
sure you guys will shred it, but I'm excited about it anyway! :)

Thanks again!
Daniel
