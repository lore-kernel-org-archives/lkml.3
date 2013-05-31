Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3EaHy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 03:54:57 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:55716 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab3EaHyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 03:54:51 -0400
Message-ID: <51A85749.6060005@atmel.com>
Date: Fri, 31 May 2013 09:54:49 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <dgilbert@interlog.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Robert Nelson <robertcnelson@gmail.com>, Johan Hovold <jhovold@gmail.com>,
        Robert Nelson <Robert.Nelson@digikey.com>,
        <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/5] rtc-at91rm9200: add shadow interrupt mask
References: <1364983415-20298-1-git-send-email-jhovold@gmail.com> <1369298335-24597-1-git-send-email-jhovold@gmail.com> <20130529133354.dd181c845ee4e96527483345@linux-foundation.org> <CAOCHtYiK8Y6iTnb4dWAE+cKHqEta-64gj+PorSFVGBF5wmg1+Q@mail.gmail.com> <51A704C3.6010109@atmel.com> <20130530123609.6e2966a66dd7b131961ed052@linux-foundation.org> <51A7DE20.5080603@interlog.com>
In-Reply-To: <51A7DE20.5080603@interlog.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/2013 01:17, Douglas Gilbert :
> On 13-05-30 03:36 PM, Andrew Morton wrote:
>> On Thu, 30 May 2013 09:50:27 +0200 Nicolas Ferre
>> <nicolas.ferre@atmel.com> wrote:
>>
>>> The review of this patch series was in my TODO list for some time...
>>>
>>> Today, I magically took time to review it ;-)
>>> The patch series is good and I (even if it is too late) here is my:
>>>
>>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>>
>>> I do not know if the series can be stacked for inclusion in 3.10-rc but
>>> the resolution of this bug can help a lot (as Douglas is saying in
>>> subsequent email...).
>>
>> We can do that, but looking through the discussion and changelogs I
>> can't seem to find a usable description of what impact the bug (and its
>> fix) have upon end-users.
>>
>> A nicely packaged description of that impact would help grease the
>> wheels, please.
>
> How about this:
>
> The members of Atmel's at91sam9x5 family (9x5) have
> a broken RTC interrupt mask register (AT91_RTC_IMR).
> It does not reflect enabled interrupts but instead
> always returns zero.
>
> The kernel's rtc-at91rm9200 driver handles the RTC
> for the 9x5 family. Currently when the date/time is
> set, an interrupt is generated and this driver neglects
> to handle the interrupt. The kernel complains about the
> un-handled interrupt and disables it henceforth. This
> not only breaks the RTC function, but since that
> interrupt is shared (Atmel's SYS interrupt) then other
> things break as well (e.g. the debug port no longer
> accepts characters).
>
> Tested on the at91sam9g25. Bug confirmed by Atmel.

Absolutely. Thank you Douglas for the detailed description.

>
> Edit as you please.
>
> Doug Gilbert
>
>


-- 
Nicolas Ferre
