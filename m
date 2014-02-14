Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaBNOub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:50:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:3977 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaBNOu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:50:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,845,1384329600"; 
   d="scan'208";a="481575086"
Message-ID: <52FE2D44.10006@intel.com>
Date: Fri, 14 Feb 2014 22:50:44 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
CC: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "ACPI / video: Add HP EliteBook Revolve 810 to
 the blacklist"
References: <1392381247-28109-1-git-send-email-mika.westerberg@linux.intel.com>	<s5hmwht24ub.wl%tiwai@suse.de>	<20140214140316.GI5018@intel.com>	<s5hfvnl23pq.wl%tiwai@suse.de>	<20140214141652.GJ5018@intel.com>	<s5ha9dt22zp.wl%tiwai@suse.de>	<20140214144524.GK5018@intel.com> <s5hy51dzr9f.wl%tiwai@suse.de>
In-Reply-To: <s5hy51dzr9f.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 10:46 PM, Takashi Iwai wrote:
> At Fri, 14 Feb 2014 16:45:24 +0200,
> Mika Westerberg wrote:
>>
>> On Fri, Feb 14, 2014 at 03:16:58PM +0100, Takashi Iwai wrote:
>>> At Fri, 14 Feb 2014 16:16:52 +0200,
>>> Mika Westerberg wrote:
>>>>
>>>> On Fri, Feb 14, 2014 at 03:01:21PM +0100, Takashi Iwai wrote:
>>>>> At Fri, 14 Feb 2014 16:03:16 +0200,
>>>>> Mika Westerberg wrote:
>>>>>>
>>>>>> On Fri, Feb 14, 2014 at 02:37:00PM +0100, Takashi Iwai wrote:
>>>>>>> At Fri, 14 Feb 2014 14:34:07 +0200,
>>>>>>> Mika Westerberg wrote:
>>>>>>>>
>>>>>>>> This reverts commit e18ac62fa4b3f16234bab0d5a6627c57dbae9e7e.
>>>>>>>>
>>>>>>>> The referenced commit added HP EliteBook Revolve 810 to the ACPI video
>>>>>>>> detected blacklist so that only the native Intel backlight interface was
>>>>>>>> exported.
>>>>>>>>
>>>>>>>> However, this turned to be wrong solution after all. The ACPI video
>>>>>>>> interface works and as long as we only use that there are no problems. So
>>>>>>>> we can revert this commit and stick to use the backlight interface provided
>>>>>>>> by the ACPI video driver.
>>>>>>>>
>>>>>>>> (Using Intel native interface will not work after resume since the ACPI
>>>>>>>> video driver will restore it's state which takes control over the native
>>>>>>>> one. That's a separate thing and should be addressed in the ACPI video
>>>>>>>> driver, I suppose.)
>>>>>>>>
>>>>>>>> References: https://bugzilla.kernel.org/show_bug.cgi?id=70231
>>>>>>>> Cc: Aaron Lu <aaron.lu@intel.com>
>>>>>>>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>>>>>>>> ---
>>>>>>>> Rafael, 
>>>>>>>>
>>>>>>>> This turned out to be misunderstanding from my side. I should have
>>>>>>>> investigated this further before submitting the original patch. Sorry about
>>>>>>>> that.
>>>>>>>>
>>>>>>>> Aaron,
>>>>>>>>
>>>>>>>> Thanks for the investigation and pointing me to the right direction (e.g to
>>>>>>>> use acpi_video0 over the native one).
>>>>>>>
>>>>>>> Could you check whether the ACPI video still really works even if you
>>>>>>> remove the recent acpi_osi blacklist entry below?  It might be that
>>>>>>> BIOS changed its mind to behave more kindly as if handling for Win7.
>>>>>>>
>>>>>>>
>>>>>>> Takashi
>>>>>>>
>>>>>>> ---
>>>>>>> diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
>>>>>>> index 10e4964d051a..64d14406465d 100644
>>>>>>> --- a/drivers/acpi/blacklist.c
>>>>>>> +++ b/drivers/acpi/blacklist.c
>>>>>>> @@ -322,6 +322,7 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
>>>>>>>  		     DMI_MATCH(DMI_PRODUCT_VERSION, "2349D15"),
>>>>>>>  		},
>>>>>>>  	},
>>>>>>> +#if 0
>>>>>>>  	{
>>>>>>>  	.callback = dmi_disable_osi_win8,
>>>>>>>  	.ident = "HP ProBook 2013 models",
>>>>>>> @@ -372,6 +373,7 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
>>>>>>>  		     DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 8780w"),
>>>>>>>  		},
>>>>>>>  	},
>>>>>>> +#endif
>>>>>>>  
>>>>>>>  	/*
>>>>>>>  	 * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
>>>>>>
>>>>>> After this patch is applied, the ACPI backlight doesn't work anymore. The
>>>>>> brightness stays the same, no matter what I do.
>>>>>
>>>>> So, you need the video blacklist when acpi_osi blacklist doesn't
>>>>> exist, right?
>>>>
>>>> In my case I don't actually need video blacklist if I use only ACPI video
>>>> for backlight control. Then it works fine.
>>>
>>> Hmm, after removing acpi_osi blacklist above, you loose the ACPI video
>>> backlight doesn't work, no?  If so, you need the video blacklist.
>>> Am I missing anything obvious...?
>>
>> Yes, the machine needs to be in acpi_osi blacklist then the ACPI video
>> works fine.
> 
> The acpi_osi blacklist is just a workaround, and if we have better
> solutions, it should be removed.  That's why I'm asking it.
> 
> So, after removing acpi_osi blacklist, and keeping your video
> blacklist patch, the backlight works?  If yes, as mentioned, we should
> think of rather extending this video blacklist to more EliteBook G1
> and ProBook G1 machines, and remove acpi_osi blacklist instead.

Agree.

> 
> Now hp-wireless is there, so the rfkill part should work without
> acpi_osi blacklist, too.

Suppose we have some work around of making backlight work for
them in Win8 mode, it seems the acpi_osi blacklist is ready to
be removed now?
