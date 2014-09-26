Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaIZFWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 01:22:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:15535 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbaIZFV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 01:21:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="391854055"
Message-ID: <5424F7F4.5040106@intel.com>
Date: Fri, 26 Sep 2014 13:21:56 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lejun Zhu <lejun.zhu@intel.com>,
        Radivoje Jovanovic <radivoje.jovanovic@intel.com>,
        =?windows-1252?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 1/2] gpio / CrystalCove: support virtual GPIO
References: <1410229968-11638-1-git-send-email-aaron.lu@intel.com> <1410229968-11638-2-git-send-email-aaron.lu@intel.com> <CACRpkdaJjqs9WNcVvjsSWhzLD2QpcyR11MVm4xhm4GqB28eOCA@mail.gmail.com> <54238496.70505@intel.com> <20140925111555.GG1786@lahna.fi.intel.com>
In-Reply-To: <20140925111555.GG1786@lahna.fi.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2014 07:15 PM, Mika Westerberg wrote:
> On Thu, Sep 25, 2014 at 10:57:26AM +0800, Aaron Lu wrote:
>> The virtual GPIO introduced in ACPI table of Baytrail-T based system is
>> used to solve a problem under Windows. We do not have such problems
>> under Linux so we do not actually need them. But we have to tell GPIO
>> library that the Crystal Cove GPIO chip has this many GPIO pins or the
>> common GPIO handler will refuse any access to those high number GPIO
>> pins, which will resulted in a failure evaluation of every ACPI control
>> method that is used to turn on/off power resource and/or report sensor
>> temperatures.
>>
>> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> 
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Thanks for the review!

Regards,
Aaron

> 
> A minor nit, see below:
> 
>> ---
>> v2: remove the hunk to increase NR_GPIO to 512.
>>
>>  drivers/gpio/gpio-crystalcove.c | 19 ++++++++++++++++---
>>  1 file changed, 16 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpio/gpio-crystalcove.c b/drivers/gpio/gpio-crystalcove.c
>> index e3712f0e51ab..186b76ef71a1 100644
>> --- a/drivers/gpio/gpio-crystalcove.c
>> +++ b/drivers/gpio/gpio-crystalcove.c
>> @@ -24,6 +24,7 @@
>>  #include <linux/mfd/intel_soc_pmic.h>
>>  
>>  #define CRYSTALCOVE_GPIO_NUM	16
>> +#define CRYSTALCOVE_VGPIO_NUM	0x5e
> 
> I would rather see this spelled in decimal base.
> 

