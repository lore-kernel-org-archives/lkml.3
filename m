Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab3BNG73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 01:59:29 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42286 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab3BNG72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 01:59:28 -0500
Message-ID: <511C8B3F.6010200@ti.com>
Date: Thu, 14 Feb 2013 12:29:11 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
Subject: Re: [PATCH RFC] davinci: poll for sleep completion in resume routine.
References: <1359624393-5898-1-git-send-email-manishv.b@ti.com> <511C65B3.7060109@ti.com> <A4887BF146CD57468F700B415D2F470158374E@DBDE01.ent.ti.com>
In-Reply-To: <A4887BF146CD57468F700B415D2F470158374E@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/14/2013 10:46 AM, Vishwanathrao Badarkhe, Manish wrote:
> Hi Sekhar,
> 
> On Thu, Feb 14, 2013 at 09:48:59, Nori, Sekhar wrote:
>> Manish,
>>
>> On 1/31/2013 2:56 PM, Vishwanathrao Badarkhe, Manish wrote:
>>> As per OMAP-L138 TRM, Software must poll for SLEEPCOMPLETE bit until 
>>> it is set to 1 before clearing SLEEPENABLE bit in DEEPSLEEP register 
>>> in resume routine.
>>> Modifications are as per datasheet:
>>> http://www.ti.com/lit/ug/spruh77a/spruh77a.pdf
>>> See sections 10.10.2.2 and 11.5.21 for more detailed explanation.
>>
>> Polling for SLEEPCOMPLETE is not required in RTC controlled wake-up which is the mode currently supported (see section 10.10.2.1 of the TRM). Polling for SLEEPCOMPLETE is required for external controlled wake-up which to my knowledge has never been tested. If you have tested this with external controlled wakep-up, then I can consider this patch.
>> Else, I would like to take it only after externally controlled wake-up is fully tested/supported instead of taking bits and pieces.
> 
> Yes, for RTC controlled wakeup, this polling is not required as per section 10.10.2.1.
> But if we see in section 10.10.2.2 (Exiting Deep Sleep Mode) step 2, When sleep count 
> completes SLEEPCOMPLETE bit gets sets in DEEPSLEEP register till that it's not safe to 
> release clock to devices. So If we don’t poll for SLEEPCOMPLETE, this delay will not
> come into picture which we actually set while entering deep sleep in case of RTC 
> controlled wakeup (Section 10.10.2.1 step 9). 
> Please let me know, whether these understanding is correct?

The  delay is coming from hardware. Till SLEEPCOUNT completes, the clock
to device is not provided. There is no need to poll for SLEEPCOMPLETE
and indeed 10.10.2.2 does not ask for this bit to be polled.

Thanks,
Sekhar
