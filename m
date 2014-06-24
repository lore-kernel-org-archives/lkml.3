Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbaFXP61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:58:27 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:34855 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbaFXP6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:58:24 -0400
Message-ID: <53A9A008.6060301@linaro.org>
Date: Tue, 24 Jun 2014 16:58:00 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v6 1/4] arm: fiq: Add callbacks to manage FIQ routings
References: <1403174303-25456-1-git-send-email-daniel.thompson@linaro.org> <1403623097-1153-1-git-send-email-daniel.thompson@linaro.org> <1403623097-1153-2-git-send-email-daniel.thompson@linaro.org> <alpine.LFD.2.11.1406241138450.16842@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1406241138450.16842@knanqh.ubzr>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/14 16:44, Nicolas Pitre wrote:
> On Tue, 24 Jun 2014, Daniel Thompson wrote:
> 
>> Currently enable_fiq/disable_fiq use a simple offset to convert an IRQ
>> virq into a FIQ virq. This is too inflexible for multi-platform kernels
>> and makes runtime error checking impossible.
>>
>> We solve this by introducing a flexible mapping that allows interrupt
>> controllers that support FIQ to register those mappings. This, in turn,
>> makes it much possible for drivers in DT kernels to install FIQ handlers
>> without knowing anything about the interrupt controller.
>>
>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Fabio Estevam <festevam@gmail.com>
>> Cc: Nicolas Pitre <nico@linaro.org>
>> ---
>>  arch/arm/include/asm/fiq.h |   7 +++
>>  arch/arm/kernel/fiq.c      | 103 ++++++++++++++++++++++++++++++++++++++++++++-
>>  2 files changed, 108 insertions(+), 2 deletions(-)
> 
> [...]
> 
>> +bool has_fiq(int fiq)
>> +{
>> +	struct fiq_data *data = lookup_fiq_data(fiq);
>> +
>> +	if (data)
>> +		return true;
>> +
>> +	if (fiq_start == -1)
>> +		return false;
>> +
>> +	return fiq > fiq_start;
> 
> Shouldn't this be fiq >= fiq_start ?

Absolutely! Will fix that shortly.


Thanks

Daniel.


