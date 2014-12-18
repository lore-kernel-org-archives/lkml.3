Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaLRNkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 08:40:15 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:52576 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaLRNkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 08:40:11 -0500
Message-ID: <5492D938.1020907@gmail.com>
Date: Thu, 18 Dec 2014 16:40:08 +0300
From: Dmitry Tunin <hanipouspilot@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH v3 1/2] acpi: Add "acpi_osi=" for ASUS X200MA to enable,
 brightness keys
References: <5492C5A3.8090700@gmail.com> <CA+5PVA43jLUp4K9=56nwgQJEyLB9EkEynb2PqfEhBWD8q-m-DQ@mail.gmail.com>
In-Reply-To: <CA+5PVA43jLUp4K9=56nwgQJEyLB9EkEynb2PqfEhBWD8q-m-DQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did not notice the inline question.
The rest of the keys work as they did before.
Now other regressions have been noticed.
Many people use acpi_osi= as a boot paremeter, since there
is no other way to get Fn+F5 and F6 working.

18.12.2014 16:25, Josh Boyer пишет:
> On Thu, Dec 18, 2014 at 7:16 AM, Dmitry Tunin <hanipouspilot@gmail.com> wrote:
>> Add "acpi_osi=" quirk for ASUS X200MA
>> More information can be found in UX302LA bugreport
>> https://bugzilla.kernel.org/show_bug.cgi?id=70241
>>
>> X200MA is affected by th e same bug and the solution has been tested
>>
>> I reported it to launchpad too
>> https://bugs.launchpad.net/ubuntu/bug/1400068
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Dmitry Tunin <hanipouspilot@gmail.com>
>>
>
> The UX301LA models have the same setup, with 16 devices instead of 8.
> I discussed this with Matthew Garrett a bit and a more ideal approach
> is to actually enumerate all 16 devices between the firmware and i915
> driver.  The problem we have is that the intel opregion spec that
> hasn't been updated since 2008 doesn't cover the additional 8 devices.
> Anyway, that is being tracked here:
>
> https://bugs.freedesktop.org/show_bug.cgi?id=81762
>
>> ---
>>   drivers/acpi/blacklist.c | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
>> index 7556e7c..f78ed08 100644
>> --- a/drivers/acpi/blacklist.c
>> +++ b/drivers/acpi/blacklist.c
>> @@ -162,6 +162,17 @@ static int __init dmi_disable_osi_win8(const struct
>> dmi_system_id *d)
>>          acpi_osi_setup("!Windows 2012");
>>          return 0;
>>   }
>> +/*
>> + * Some ASUS models firmware declares 16 devices instead of 8
>> + * 'acpi_osi=' kernel parameter fixes it
>> + * Without this parameters brightness keys Fn+F5 and F6 do not work
>> + */
>> +static int __init dmi_disable_osi_all(const struct dmi_system_id *d)
>> +{
>> +       printk(KERN_NOTICE PREFIX "DMI detected: %s\n", d->ident);
>> +       acpi_osi_setup("");
>> +       return 0;
>> +}
>
> What does this do to the rest of the function keys?  Does everything
> else still work as expected, including suspend and resume?
>
>>    static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
>>          {
>> @@ -371,6 +382,15 @@ static struct dmi_system_id acpi_osi_dmi_table[]
>> __initdata = {
>>                       DMI_MATCH(DMI_PRODUCT_NAME, "1015PX"),
>>                  },
>>          },
>> +       /* Without this brightness keys do not work */
>> +       {
>> +       .callback = dmi_disable_osi_all,
>> +       .ident = "ASUSTeK COMPUTER INC. X200MA",
>> +       .matches = {
>> +                    DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
>> +                    DMI_MATCH(DMI_PRODUCT_NAME, "X200MA"),
>> +               },
>> +       },
>>          {}
>>   };
>>
>> --
>> 1.9.1
>> --
>> To unsubscribe from this list: send the line "unsubscribe stable" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
