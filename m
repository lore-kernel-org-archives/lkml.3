Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab3FLPdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 11:33:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60798 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3FLPde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 11:33:34 -0400
Message-ID: <51B894C9.4070308@ti.com>
Date: Wed, 12 Jun 2013 18:33:29 +0300
From: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@linaro.org>, <j-keerthy@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] PM / AVS: SmartReflex/class3: Fix order of initialization
 of SR class and SR driver
References: <1370339913-16135-1-git-send-email-andrii.tseglytskyi@ti.com> <1370339913-16135-3-git-send-email-andrii.tseglytskyi@ti.com> <87fvwpdfab.fsf@linaro.org> <20130612133231.GQ8164@atomide.com>
In-Reply-To: <20130612133231.GQ8164@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 04:32 PM, Tony Lindgren wrote:
> * Kevin Hilman <khilman@linaro.org> [130610 10:58]:
>> Andrii Tseglytskyi <andrii.tseglytskyi@ti.com> writes:
>>
>>> SmartReflex consists of three entities: SR device, SR class and
>>> SR driver. SmartReflex driver depends on SmartReflex class, but
>>> order of their initialization is not clear. They both use
>>> late_initcall(), and order depends on Makefile calls.
>>> Patch moves initialization of SR class to device_initcall(),
>>> and removes redundant call of sr_late_init().
>>>
>>> This provides predictable order of SmartReflex initcalls:
>>> 1. device_initcall() -> SmartReflex class init
>>> 2. late_initcall() -> SmartReflex driver init
>>>
>>> Signed-off-by: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
>> Tony will have to decide on whether he's OK with the initcall changes.
>>
>> I can queue this with the rest of the AVS changes with Tony's ack.
> I'd rather not make anything earlier, relying on the Makefile is just
> fine here. These pieces are always compiled in too. The reason why
> we should only minimal things initialized earlier than module_init
> is that this way we have a proper console initialized and see real
> error messages without having to have DEBUG_LL + earlyprintk enabled.
>
> If anything else is needed, you have have just one late_initcall
> that checks the return values of the various SR related init functions
> to make sure all the dependencies are met.
>
> Regards,
>
> Tony
>   
>
Hi Tony,

Thank you for your comment - it sounds reasonable.
Patch can be dropped from this patch series.

Regards,
Andrii


