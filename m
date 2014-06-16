Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbaFPKCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 06:02:41 -0400
Received: from smtprelay-b32.telenor.se ([213.150.131.21]:43056 "EHLO
	smtprelay-b32.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbaFPKCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:02:39 -0400
X-Greylist: delayed 1928 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2014 06:02:39 EDT
X-LISTENER: [mailrelay1.bredband.net]
X-SENDER-IP: [92.33.28.242]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQBALe3nlNcIRzy/2dsb2JhbAANTcQ/gxIBgSeEeAEBAQECAThBBQsLDgoJJQ8CHCoGDQEHAQEXiB8NsBOeeheJQ4UzB4RDAQOlc4tq
X-IPAS-Result: ApQBALe3nlNcIRzy/2dsb2JhbAANTcQ/gxIBgSeEeAEBAQECAThBBQsLDgoJJQ8CHCoGDQEHAQEXiB8NsBOeeheJQ4UzB4RDAQOlc4tq
X-IronPort-AV: E=Sophos;i="5.01,485,1400018400"; 
   d="scan'208";a="703867388"
Message-ID: <539EB8F4.20104@gaisler.com>
Date: Mon, 16 Jun 2014 11:29:24 +0200
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
CC: lugovskoy@dev.rtsoft.ru, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH 00/21] add and use devm_irq_of_parse_and_map()
References: <53997AF6.1040003@gaisler.com> <5399AE1B.1080301@gaisler.com> <5399F92B.50406@dev.rtsoft.ru> <539EA986.1090501@gaisler.com> <539EAC92.1040606@dev.rtsoft.ru>
In-Reply-To: <539EAC92.1040606@dev.rtsoft.ru>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-16 10:36, Nikita Yushchenko wrote:
>>>> SPARC does not use OF_IRQ and has a different implementation of
>>>> irq_of_parse_and_map than the one in drivers/of/irq.c. All code
>>>> converted from irq_of_parse_and_map to devm_irq_of_parse_and_map in this
>>>> patch set will be unlinkable for SPARC. This includes SPI in general and
>>>> many drivers that are used for SPARC (of which several are currently
>>>> only used on SPARC platforms).
>>>
>>> Can this be fixed by adding a copy of devm_irq_of_parse_and_map() to
>>> arch/sparc/kernel/of_device_common.c ?
>>
>> Not a copy of the version in irq.c no. On SPARC, IRQ_DOMAIN is not
>> selected in general.
>>
>> However, there is no technical problem that I can see with having a
>> SPARC version of devm_irq_of_parse_and_map that just calls
>> irq_of_parse_and_map as there are no mappings that needs to be disposed
>> of. (The empty dummy for irq_dispose_mapping is used if any
>> irq_dispose_mapping calls are made from drivers).
>
> Ok, I will post an updated patchset that adds sparc
> devm_irq_of_parse_and_map() that just calls irq_of_parse_and_map(), and
> devm_irq_dispose_mapping() that does nothing.

You have already added the needed empty devm_irq_dispose_mapping in 
include/linux/irqdomain.h.

Note that the IRQ_DOMAIN *can* be used under SPARC (GPIO_GRGPIO is one 
example that selects it), but it is not used at the top level so to 
speak. There should not be a SPARC specific empty version of 
devm_irq_dispose_mapping - CONF_IRQ_DOMAIN or not takes care of that.


> Also, you mentioned that some drivers that my original patchset touches
> are sparc-only?  Then, maybe better not convert these to devm_? Could
> you please give a list of such drivers?

The drivers that I know of off hand is not necessarily SPARC only. Some 
are currently only found in SPARC environments, but that could change in 
the future. I personally don't see a problem with using 
devm_of_parse_and_map solution as long as there is a SPARC-specific one 
as discussed above.

Best regards,
Andreas Larsson
