Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaFPIgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 04:36:39 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:55812 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183AbaFPIgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 04:36:37 -0400
Message-ID: <539EAC92.1040606@dev.rtsoft.ru>
Date: Mon, 16 Jun 2014 12:36:34 +0400
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
References: <53997AF6.1040003@gaisler.com> <5399AE1B.1080301@gaisler.com> <5399F92B.50406@dev.rtsoft.ru> <539EA986.1090501@gaisler.com>
In-Reply-To: <539EA986.1090501@gaisler.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> SPARC does not use OF_IRQ and has a different implementation of
>>> irq_of_parse_and_map than the one in drivers/of/irq.c. All code
>>> converted from irq_of_parse_and_map to devm_irq_of_parse_and_map in this
>>> patch set will be unlinkable for SPARC. This includes SPI in general and
>>> many drivers that are used for SPARC (of which several are currently
>>> only used on SPARC platforms).
>>
>> Can this be fixed by adding a copy of devm_irq_of_parse_and_map() to
>> arch/sparc/kernel/of_device_common.c ?
> 
> Not a copy of the version in irq.c no. On SPARC, IRQ_DOMAIN is not
> selected in general.
> 
> However, there is no technical problem that I can see with having a
> SPARC version of devm_irq_of_parse_and_map that just calls
> irq_of_parse_and_map as there are no mappings that needs to be disposed
> of. (The empty dummy for irq_dispose_mapping is used if any
> irq_dispose_mapping calls are made from drivers).

Ok, I will post an updated patchset that adds sparc
devm_irq_of_parse_and_map() that just calls irq_of_parse_and_map(), and
devm_irq_dispose_mapping() that does nothing.

Also, you mentioned that some drivers that my original patchset touches
are sparc-only?  Then, maybe better not convert these to devm_? Could
you please give a list of such drivers?

Nikita

