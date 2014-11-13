Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbaKMIjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 03:39:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:49421 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbaKMIjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 03:39:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,375,1413270000"; 
   d="scan'208";a="621682028"
Message-ID: <54646E54.5060608@intel.com>
Date: Thu, 13 Nov 2014 16:39:48 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Lee Jones <lee.jones@linaro.org>, linux-acpi@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH 0/3] Support PMIC operation region for CrystalCove and
 XPower
References: <1414735705-18366-1-git-send-email-aaron.lu@intel.com> <3052882.EdcZmghHR3@vostro.rjw.lan> <5462BC5A.7070407@intel.com> <1834078.D8VLOj1LAI@vostro.rjw.lan>
In-Reply-To: <1834078.D8VLOj1LAI@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2014 08:51 AM, Rafael J. Wysocki wrote:
> On Wednesday, November 12, 2014 09:48:10 AM Aaron Lu wrote:
>> On 11/12/2014 07:35 AM, Rafael J. Wysocki wrote:
>>> On Tuesday, November 11, 2014 11:11:52 AM Lee Jones wrote:
>>>> On Tue, 11 Nov 2014, Aaron Lu wrote:
>>>>
>>>>> On 10/31/2014 02:08 PM, Aaron Lu wrote:
>>>>>> On Intel Baytrail-T and Baytrail-T-CR platforms, there are two customized
>>>>>> ACPI operation regions defined for the Power Management Integrated Circuit
>>>>>> device, one is for power resource handling and one is for thermal: sensor
>>>>>> temperature reporting, trip point setting, etc. There are different PMIC
>>>>>> chips used on those platforms and though each has the same two operation
>>>>>> regions and functionality, their implementation is different so every PMIC
>>>>>> will need a driver. But since their functionality is similar, some common
>>>>>> code is abstracted into the intel_soc_pmic_opregion.c.
>>>>>>
>>>>>> The last version is posted here:
>>>>>> https://lkml.org/lkml/2014/9/8/801
>>>>>>
>>>>>> Changes since then:
>>>>>> 1 Move to drivers/acpi as discussed on the above thread;
>>>>>> 2 Added support for XPower AXP288 PMIC operation region support;
>>>>>> 3 Since operation region handler can not be removed(at the moment at least),
>>>>>>   use bool for the two operation region driver configs instead of tristate;
>>>>>>   Another reason to do this is that, with Mika's MFD ACPI support patch, all
>>>>>>   those MFD cell devices created will have the same modalias as their parent's
>>>>>>   so it doesn't make much sense to compile these drivers into modules.
>>>>>>
>>>>>> Patch 1 applies on top of Rafael's pm-next branch, and then patch 2 and
>>>>>> patch 3 needs merge of Lee's mfd/ib-mfd-iio-3.19 branch where the PMIC
>>>>>> driver XPower AXP288 and iio driver axp288_adc is located.
>>>>>
>>>>> Since patch 2-3 are based on top of the mfd/ib-mfd-iio-3.19 branch, it
>>>>> would be easy to go through the mfd/ib-mfd-iio-3.19 branch.
>>>>>
>>>>> Rafael,
>>>>> Can I get your ACK for the three patches?
>>>>>
>>>>> Lee,
>>>>> Can you please take the series if Rafael gives it ack?
>>>>
>>>> Yes, no problem.
>>>
>>> Well, since the code is going to reside mostly in drivers/acpi, I think I should
>>> be applying the patches and from your response it looks like you are fine with
>>> them.  Is that correct?
>>
>> Oh I thought you may not want to merge another branch into your next
>> branch so I asked this question. If you can handle the whole thing in your
>> tree, that's of course not a problem :-)
> 
> Merging one more branch wouldn't be a problem, but we'll take care of that
> later.
> 
> For now, would it be possible to rename the subdir to "pmic" instead of
> "pmic_opregion"?  The "_opregion" part doesn't seem to add much value here.

No problem.

> 
> And can the names of the files be somewhat shorter too?  Like "intel_pmic.[h][c]"
> and "intel_pmic_crc.c"?

Sure, will update and send v2, thanks for the advice.

Regards,
Aaron
