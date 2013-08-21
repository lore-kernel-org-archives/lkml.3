Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab3HUTyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 15:54:39 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:51742 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3HUTyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 15:54:37 -0400
MIME-Version: 1.0
In-Reply-To: <1376551353.2335.117.camel@rzhang-lenovo>
References: <1375829300-14081-1-git-send-email-felipe.contreras@gmail.com>
	<1376551353.2335.117.camel@rzhang-lenovo>
Date: Wed, 21 Aug 2013 14:54:36 -0500
Message-ID: <CAMP44s1_ZN0ZewJre41Bp50OmwM8djM2uR_xGybQLLgke2w2VA@mail.gmail.com>
Subject: Re: [PATCH] thermal: new asus driver
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        corentin.chary@gmail.com, Matthew Garrett <matthew.garrett@nebula.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 2:22 AM, Zhang Rui <rui.zhang@intel.com> wrote:
> On 二, 2013-08-06 at 17:48 -0500, Felipe Contreras wrote:
>> Simple driver to enable control of the fan in ASUS laptops. So far this
>> has only been tested in ASUS Zenbook Prime UX31A, but according to some
>> online reference [1], it should work in other models as well.
>>
> I'd rather prefer to do this in the vendor driver like asus-laptop.c.
> Say, it is the asus-laptop driver that knows the fan control ability of
> the platform and register to the thermal framework.

But asus-laptop doesn't work on this machine. I presume asus-wmi
wouldn't work on some other machines.

I think this is a completely different thing.

>> +static int fan_get_cur_state(struct thermal_cooling_device *cdev,
>> +             unsigned long *state)
>> +{
>> +     struct acpi_object_list params;
>> +     union acpi_object in_objs[1];
>> +     unsigned long long value;
>> +     acpi_status r;
>> +
>> +     params.count = ARRAY_SIZE(in_objs);
>> +     params.pointer = in_objs;
>> +     in_objs[0].type = ACPI_TYPE_INTEGER;
>> +     in_objs[0].integer.value = 0;
>> +
>> +     r = acpi_evaluate_integer(NULL, "\\_TZ.RFAN", &params, &value);
>> +     if (r != AE_OK)
>> +             return r;
>> +
>> +     *state = value;
>> +
>> +     return 0;
>> +}
>> +
>> +static int fan_set(struct thermal_cooling_device *cdev, int fan, int speed)
>> +{
>> +     struct acpi_object_list params;
>> +     union acpi_object in_objs[2];
>> +     unsigned long long value;
>> +
>> +     params.count = ARRAY_SIZE(in_objs);
>> +     params.pointer = in_objs;
>> +     in_objs[0].type = ACPI_TYPE_INTEGER;
>> +     in_objs[0].integer.value = fan;
>> +     in_objs[1].type = ACPI_TYPE_INTEGER;
>> +     in_objs[1].integer.value = speed;
>> +
>> +     return acpi_evaluate_integer(NULL, "\\_SB.PCI0.LPCB.EC0.SFNV", &params, &value);
>> +}
>> +
> I checked a couple of BIOS, and it seems that both of these two methods
> can be invoked by ATKD.WMNB indirectly.
> So I'm wondering if it is proper to invoke these two methods directly,
> and if these are some features/functionalities that are still missing in
> the asus-laptop driver.

I don't know what that means. From what I can see asus-laptop is not
meant to work on all ASUS laptops, and indeed it doesn't work on this
one.

-- 
Felipe Contreras
