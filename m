Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaBQNHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:07:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:7689 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbaBQNHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:07:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,860,1384329600"; 
   d="scan'208";a="482901823"
Message-ID: <5302097C.4000000@intel.com>
Date: Mon, 17 Feb 2014 21:07:08 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "ACPI / video: Add HP EliteBook Revolve 810 to
 the blacklist"
References: <1392381247-28109-1-git-send-email-mika.westerberg@linux.intel.com>	<s5hy51dzr9f.wl%tiwai@suse.de>	<20140214152601.GL5018@intel.com>	<5716481.SxKZLEy9L1@vostro.rjw.lan>	<5301A3AE.9030703@intel.com> <s5h61oe12r7.wl%tiwai@suse.de>
In-Reply-To: <s5h61oe12r7.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 05:56 PM, Takashi Iwai wrote:
> At Mon, 17 Feb 2014 13:52:46 +0800,
> Aaron Lu wrote:
>>
>> On 02/15/2014 06:21 AM, Rafael J. Wysocki wrote:
>>> On Friday, February 14, 2014 05:26:01 PM Mika Westerberg wrote:
>>>> On Fri, Feb 14, 2014 at 03:46:20PM +0100, Takashi Iwai wrote:
>>>>> The acpi_osi blacklist is just a workaround, and if we have better
>>>>> solutions, it should be removed.  That's why I'm asking it.
>>>>>
>>>>> So, after removing acpi_osi blacklist, and keeping your video
>>>>> blacklist patch, the backlight works?
>>>>
>>>> Yes, the backlight works (there is only intel_backlight listed under
>>>> /sys/class/backlight).
>>>>
>>>>> If yes, as mentioned, we should think of rather extending this video
>>>>> blacklist to more EliteBook G1 and ProBook G1 machines, and remove
>>>>> acpi_osi blacklist instead.
>>>>
>>>> Makes sense to me. (Well, I'm fine as long as backlight on my machine works
>>>> ;-))
>>>>
>>>> Aaron, Rafael, any comments on this?
>>>
>>> I generally agree with Takashi, but I'm not sure what to do for 3.14.
>>
>> I can re-base the previously sent patch titled:
>> [PATCH] ACPI / video: Add systems that should favor native backlight interface
>> And put Mika's system into the DMI table that will use native backlight
>> interface in video module and remove it from video_detect's DMI table at
>> the same time. Does this sound OK?
> 
> Rather put more generic DMI entries for the recent HP ProBook and
> EliteBook machines as in acpi_osi blacklist:
> 
> 	{
> 	.callback = dmi_disable_osi_win8,
> 	.ident = "HP ProBook 2013 models",
> 	.matches = {
> 		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> 		     DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook "),
> 		     DMI_MATCH(DMI_PRODUCT_NAME, " G1"),
> 		},
> 	},
> 	{
> 	.callback = dmi_disable_osi_win8,
> 	.ident = "HP EliteBook 2013 models",
> 	.matches = {
> 		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> 		     DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook "),
> 		     DMI_MATCH(DMI_PRODUCT_NAME, " G1"),
> 		},
> 	},
> 	{
> 	.callback = dmi_disable_osi_win8,
> 	.ident = "HP ZBook 14",
> 	.matches = {
> 		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> 		     DMI_MATCH(DMI_PRODUCT_NAME, "HP ZBook 14"),
> 		},
> 	},
> 	{
> 	.callback = dmi_disable_osi_win8,
> 	.ident = "HP ZBook 15",
> 	.matches = {
> 		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> 		     DMI_MATCH(DMI_PRODUCT_NAME, "HP ZBook 15"),
> 		},
> 	},
> 	{
> 	.callback = dmi_disable_osi_win8,
> 	.ident = "HP ZBook 17",
> 	.matches = {
> 		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> 		     DMI_MATCH(DMI_PRODUCT_NAME, "HP ZBook 17"),
> 		},
> 	},
> 	{
> 	.callback = dmi_disable_osi_win8,
> 	.ident = "HP EliteBook 8780w",
> 	.matches = {
> 		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> 		     DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 8780w"),
> 		},
> 	},
> 
> All these are known to have different behavior with Win8, including
> the broken ACPI backlight.  Once after merging that patch, we can
> revert the commit 2d4054d84224.

OK, thanks for the info.
I'll add the above laptops to the video module's use_native_backlight
DMI table.

Thanks,
Aaron

> 
> I suppose it'd be OK for to do these for 3.14, since the acpi_osi
> commit was merged first in 3.14.  Then we can continue fixing in a
> saner way.
> 
> 
> thanks,
> 
> Takashi
> 

