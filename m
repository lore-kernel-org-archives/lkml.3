Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab3LIWZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 17:25:22 -0500
Received: from mail.nic.cz ([217.31.204.67]:46105 "EHLO mail.nic.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab3LIWZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 17:25:20 -0500
Message-ID: <52A6434B.9040100@nic.cz>
Date: Mon, 09 Dec 2013 23:25:15 +0100
From: =?UTF-8?B?SmFuIFbEjWVsw6Fr?= <jan.vcelak@nic.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: lenb@kernel.org, rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: full battery charge cannot exceed current one
References: <1386419801-10091-1-git-send-email-jan.vcelak@nic.cz> <20131209170214.GB30717@srcf.ucam.org>
In-Reply-To: <20131209170214.GB30717@srcf.ucam.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Some degraded batteries report maximal capacity to be smaller than
>> current charge of the battery. This can confuse some user space
>> applications (like upower).
> 
> Can't we just fix upower?

It looks like upower already resolved that:

http://cgit.freedesktop.org/upower/tree/src/linux/up-device-supply.c#n652

If the purpose of sysfs is to provide raw values retrieved from battery,
then I agree that this should not be handled in kernel.
Otherwise I would expect semantically correct data there.

>> +	/* Some degraded batteries report lower full charge than current one. */
>> +	if (battery->capacity_now > battery->full_charge_capacity)
>> +		battery->full_charge_capacity = battery->capacity_now;
>> +
> 
> Does upower read *_full on every read of the value? How do we guarantee 
> that it won't read energy_now without updating energy_full and still 
> come up with an incorrect calculation?

That's a good point. I'm not sure about other applications, but upower
always refreshes all values. Function up_device_supply_refresh_battery
seems to be the only place where 'charge_now' is being read:

http://cgit.freedesktop.org/upower/tree/src/linux/up-device-supply.c#n485
