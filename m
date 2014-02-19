Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaBSC5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 21:57:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:56526 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbaBSC5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 21:57:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,503,1389772800"; 
   d="scan'208";a="477423826"
Message-ID: <53041D89.2050204@intel.com>
Date: Wed, 19 Feb 2014 10:57:13 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Takashi Iwai <tiwai@suse.de>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Peter Weber <bugs@ttyhoney.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kevin Smith <thirdwiggin@gmail.com>,
        Rinat Ibragimov <ibragimovrinat@mail.ru>, sov.info@mail.ru,
        Thomas Christensen <christensenthomas@gmail.com>,
        Vladimir Sherenkov <a_12300@mail.ru>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: Re: [PATCH v4] ACPI / video: Add systems that should favour native
 backlight interface
References: <5302F58C.1080001@intel.com> <20140218103442.GS5018@intel.com> <s5hfvngy2bh.wl%tiwai@suse.de> <1903167.TtlOFgMB6X@vostro.rjw.lan> <20140218154640.GT5018@intel.com>
In-Reply-To: <20140218154640.GT5018@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 11:46 PM, Mika Westerberg wrote:
> On Tue, Feb 18, 2014 at 04:22:27PM +0100, Rafael J. Wysocki wrote:
>> On Tuesday, February 18, 2014 02:31:46 PM Takashi Iwai wrote:
>>> At Tue, 18 Feb 2014 12:34:42 +0200,
>>> Mika Westerberg wrote:
>>>>
>>>> On Tue, Feb 18, 2014 at 01:54:20PM +0800, Aaron Lu wrote:
>>>>> +	{
>>>>> +	.callback = video_set_use_native_backlight,
>>>>> +	.ident = "HP EliteBook 2013 models",
>>>>> +	.matches = {
>>>>> +		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
>>>>> +		DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook "),
>>>>> +		DMI_MATCH(DMI_PRODUCT_NAME, " G1"),
>>>>> +		},
>>>>> +	},
>>>>
>>>> I see my device is listed here but the above doesn't really use native
>>>> backlight because it is still in acpi_osi blacklist. Tried this and I can
>>>> see both acpi_video0 and intel_backlight listed under /sys/class/backlight.
>>>> Was this the intention?
>>>
>>> The acpi_osi blacklist commit (2d4054d84224) has to be reverted, as I
>>> mentioned earlier.  But the revert can be done individually after
>>> merging this patch.  Rafael, could you care?
>>
>> Done.  Please check the result in linux-pm.git/linux-next.
> 
> With your revert and this patch from Aaron, backlight on my HP EliteBook
> Revolve G1 works fine, thanks!
> 
> Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Thanks for the test Mika and sorry for all the confusions caused.

-Aaron

