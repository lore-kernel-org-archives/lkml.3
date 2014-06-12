Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaFLTCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:02:13 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:52209 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaFLTCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:02:09 -0400
Message-ID: <5399F92B.50406@dev.rtsoft.ru>
Date: Thu, 12 Jun 2014 23:02:03 +0400
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTSoft Software Development Center
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Andreas Larsson <andreas@gaisler.com>
CC: lugovskoy@dev.rtsoft.ru, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH 00/21] add and use devm_irq_of_parse_and_map()
References: <53997AF6.1040003@gaisler.com> <5399AE1B.1080301@gaisler.com>
In-Reply-To: <5399AE1B.1080301@gaisler.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Currently many device tree aware drivers use irq_of_parse_and_map() to
>> get
>> IRQ number and then devm_request_irq() to set up IRQ handler.
>>
>> This causes a problem for exit path and for error paths: undo action for
>> irq_of_parse_and_map() is irq_dispose_mapping() that must not be called
>> while IRQ handler is defined, but devres moves free_irq() out of driver
>> so driver does not have safe place to call irq_dispose_mapping().
>>
>> So many drivers do not call irq_dispose_mapping() at all, others call it
>> while IRQ handler is defined (which is incorrect and causes error
>> messages
>> in logs), even others refuse to use devres for managing IRQ handlers.
>>
>> This patchset adds devres version of irq_of_parse_and_map(), and updates
>> in-tree users of both devres and irq_of_parse_and_map() to use
>> devm_irq_of_parse_and_map() instead.
> 
> 
> SPARC does not use OF_IRQ and has a different implementation of
> irq_of_parse_and_map than the one in drivers/of/irq.c. All code
> converted from irq_of_parse_and_map to devm_irq_of_parse_and_map in this
> patch set will be unlinkable for SPARC. This includes SPI in general and
> many drivers that are used for SPARC (of which several are currently
> only used on SPARC platforms).

Can this be fixed by adding a copy of devm_irq_of_parse_and_map() to
arch/sparc/kernel/of_device_common.c ?

Or there are some deep reasons why irq_of_parse_and_map() can't be
devm'd for sparc at all?

Nikita

