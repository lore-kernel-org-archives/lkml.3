Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaLSDXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 22:23:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:21321 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaLSDXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 22:23:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="431025943"
Message-ID: <54939A30.2020601@intel.com>
Date: Fri, 19 Dec 2014 11:23:28 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>,
        Dmitry Tunin <hanipouspilot@gmail.com>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH v3 1/2] acpi: Add "acpi_osi=" for ASUS X200MA to enable,
 brightness keys
References: <5492C5A3.8090700@gmail.com> <CA+5PVA43jLUp4K9=56nwgQJEyLB9EkEynb2PqfEhBWD8q-m-DQ@mail.gmail.com> <54938360.4000804@intel.com>
In-Reply-To: <54938360.4000804@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2014 09:46 AM, Aaron Lu wrote:
> CC Jani, who is working on the patchset to enable 8+ output devices and
> may have some comments on this.

Change Jani's email address, I got a warning from the mailer about his other
email address.

> 
> Regards,
> Aaron
> 
> On 12/18/2014 09:25 PM, Josh Boyer wrote:
>> On Thu, Dec 18, 2014 at 7:16 AM, Dmitry Tunin <hanipouspilot@gmail.com> wrote:
>>> Add "acpi_osi=" quirk for ASUS X200MA
>>> More information can be found in UX302LA bugreport
>>> https://bugzilla.kernel.org/show_bug.cgi?id=70241
>>>
>>> X200MA is affected by th e same bug and the solution has been tested
>>>
>>> I reported it to launchpad too
>>> https://bugs.launchpad.net/ubuntu/bug/1400068
>>>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Dmitry Tunin <hanipouspilot@gmail.com>
>>>
>>
>> The UX301LA models have the same setup, with 16 devices instead of 8.
>> I discussed this with Matthew Garrett a bit and a more ideal approach
>> is to actually enumerate all 16 devices between the firmware and i915
>> driver.  The problem we have is that the intel opregion spec that
>> hasn't been updated since 2008 doesn't cover the additional 8 devices.
>> Anyway, that is being tracked here:
>>
>> https://bugs.freedesktop.org/show_bug.cgi?id=81762
>>
>>> ---
>>>  drivers/acpi/blacklist.c | 20 ++++++++++++++++++++
>>>  1 file changed, 20 insertions(+)
>>>
>>> diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
>>> index 7556e7c..f78ed08 100644
>>> --- a/drivers/acpi/blacklist.c
>>> +++ b/drivers/acpi/blacklist.c
>>> @@ -162,6 +162,17 @@ static int __init dmi_disable_osi_win8(const struct
>>> dmi_system_id *d)
>>>         acpi_osi_setup("!Windows 2012");
>>>         return 0;
>>>  }
>>> +/*
>>> + * Some ASUS models firmware declares 16 devices instead of 8
>>> + * 'acpi_osi=' kernel parameter fixes it
>>> + * Without this parameters brightness keys Fn+F5 and F6 do not work
>>> + */
>>> +static int __init dmi_disable_osi_all(const struct dmi_system_id *d)
>>> +{
>>> +       printk(KERN_NOTICE PREFIX "DMI detected: %s\n", d->ident);
>>> +       acpi_osi_setup("");
>>> +       return 0;
>>> +}
>>
>> What does this do to the rest of the function keys?  Does everything
>> else still work as expected, including suspend and resume?
>>
>>>   static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
>>>         {
>>> @@ -371,6 +382,15 @@ static struct dmi_system_id acpi_osi_dmi_table[]
>>> __initdata = {
>>>                      DMI_MATCH(DMI_PRODUCT_NAME, "1015PX"),
>>>                 },
>>>         },
>>> +       /* Without this brightness keys do not work */
>>> +       {
>>> +       .callback = dmi_disable_osi_all,
>>> +       .ident = "ASUSTeK COMPUTER INC. X200MA",
>>> +       .matches = {
>>> +                    DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
>>> +                    DMI_MATCH(DMI_PRODUCT_NAME, "X200MA"),
>>> +               },
>>> +       },
>>>         {}
>>>  };
>>>
>>> --
>>> 1.9.1
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe stable" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

