Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaKYLOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:14:11 -0500
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:45555 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754525AbaKYLOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:14:09 -0500
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <5474655A.9090201@smartplayin.com>
Date: Tue, 25 Nov 2014 16:47:46 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Lucas Stach <l.stach@pengutronix.de>
CC: linux-kernel@vger.kernel.org, broonie@kernel.org, lgirdwood@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] regulator: core: do not disable regulator if boot_on
 is set
References: <1416912803-10772-1-git-send-email-pramod.gurav@smartplayin.com> <1416913037.2741.1.camel@pengutronix.de>
In-Reply-To: <1416913037.2741.1.camel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2014 04:27 PM, Lucas Stach wrote:
> Am Dienstag, den 25.11.2014, 16:23 +0530 schrieb Pramod Gurav:
>> Currently the regulator core disables the regulators which are unused
>> or whose reference count is zero or if they are configured always_on.
>> This change adds a check in this logic to see if a regulator is
>> configured as boot_on and does not disable it if found true.
>>
>> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
>>
>> ---
>>
>> The issue was found on apq8064 based IFC6410 on which a fixed regulator
>> configured as regulator-boot-on in DT and was being disabled when not in
>> use. Tested this change on this board and found working.
>>
> Um, why would this be the correct fix? regulator-boot-on just tells the
> regulator core that the bootloader might have left this regulator
> enabled. If you want it to stay on after the kernel finished init you
> need to mark it as always-on.

Thanks Lucas. Shall mark it as alway_on.
> 
>>  drivers/regulator/core.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
>> index cd87c0c..9f7a13f 100644
>> --- a/drivers/regulator/core.c
>> +++ b/drivers/regulator/core.c
>> @@ -4019,7 +4019,7 @@ static int __init regulator_init_complete(void)
>>  		ops = rdev->desc->ops;
>>  		c = rdev->constraints;
>>  
>> -		if (c && c->always_on)
>> +		if (c && (c->always_on || c->boot_on))
>>  			continue;
>>  
>>  		if (c && !(c->valid_ops_mask & REGULATOR_CHANGE_STATUS))
> 
