Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab3CZV1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:27:55 -0400
Received: from smtp.infotech.no ([82.134.31.41]:40471 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab3CZV1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:27:53 -0400
Message-ID: <51520EA7.8090808@interlog.com>
Date: Tue, 26 Mar 2013 17:09:59 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: rtc-at91rm9200: use a variable for storing IMR
References: <1363369032-12639-1-git-send-email-nicolas.ferre@atmel.com> <20130326192713.GA31628@localhost>
In-Reply-To: <20130326192713.GA31628@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-03-26 03:27 PM, Johan Hovold wrote:
> On Fri, Mar 15, 2013 at 06:37:12PM +0100, Nicolas Ferre wrote:
>> On some revisions of AT91 SoCs, the RTC IMR register is not working.
>> Instead of elaborating a workaround for that specific SoC or IP version,
>> we simply use a software variable to store the Interrupt Mask Register and
>> modify it for each enabling/disabling of an interrupt. The overhead of this
>> is negligible anyway.
>
> The patch does not add any memory barriers or register read-backs when
> manipulating the interrupt-mask variable. This could possibly lead to
> spurious interrupts both when enabling and disabling the various
> RTC-interrupts due to write reordering and bus latencies.
>
> Has this been considered? And is this reason enough for a more targeted
> work-around so that the SOCs with functional RTC_IMR are not affected?

The SoCs in question use a single embedded ARM926EJ-S and
according to the Atmel documentation, that CPU's instruction
set contains no barrier (or related) instructions.

In the arch/arm/mach-at91 sub-tree of the kernel source
I can find no use of the wmb() call. Also checked all drivers
in the kernel containing "at91" and none called wmb().

Doug Gilbert

