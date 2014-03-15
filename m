Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbaCOP3r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 11:29:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:34226 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181AbaCOP3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 11:29:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,660,1389772800"; 
   d="scan'208";a="500592011"
Message-ID: <532471EC.1070107@intel.com>
Date: Sat, 15 Mar 2014 11:29:48 -0400
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>, Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.14-rc: /proc/acpi/battery gone?
References: <20140314211456.GA23213@amd.pavel.ucw.cz> <CAKb7Uvh1TaNLmi0YVBPmCD571ZU_sM1DpbYUSA8xQZnS5xUbCA@mail.gmail.com> <1677000.FsvVVRjEvo@vostro.rjw.lan> <201403150217.50526.s.L-H@gmx.de>
In-Reply-To: <201403150217.50526.s.L-H@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 10:17 PM, Stefan Lippers-Hollmann wrote:
> Hi
>
> On Saturday 15 March 2014, Rafael J. Wysocki wrote:
>> On Friday, March 14, 2014 06:14:12 PM Ilia Mirkin wrote:
>>> On Fri, Mar 14, 2014 at 6:11 PM, Pavel Machek <pavel@ucw.cz> wrote:
>>>> On Fri 2014-03-14 17:29:41, Ilia Mirkin wrote:
>>>>> On Fri, Mar 14, 2014 at 5:14 PM, Pavel Machek <pavel@ucw.cz> wrote:
> [...]
>>> wmbattery
>>>
>>> They have attempted to use the sysfs api, but apparently that
>>> integration was done with an older version of that API. There's also
>>> some attempt to get it to work with upower, but I couldn't figure out
>>> how to make that work either on my (up-to-date gentoo) box. (TBH I
>>> didn't spend more than an hour or two on it, so it may not be
>>> impossible.)
>>
>> Tianyu, can you please have a look at this?
>
> Disclaimer, I've never used wmbattery so far.
>
> The current upstream version (2.42, released in early december 2013)
> of wmbattery[1] no longer reads from /proc/acpi/ at all. Apparently
> it changed to using upower by default, with non-default fall-backs for
> reading from sysfs.
>
> The only change required for building upower with wmbattery 2.42
> appears to be a new build-dependency on libupower-glib-dev (at least
> on Debian, built from the upower source package). Given that this
> version is present in Debian testing and unstable, I'd assume that it's
> supposed to work using upower, although I haven't confirmed that myself.
>
> Judging from the Gentoo ebuild, you probably just have to add
> "sys-power/upower" to the RDEPEND variable and make sure to build
> wmbattery 2.42; this is untested.
>

Hi Stefan:
	I just glance wmbattery code. I find the code in the acpi.c is already 
using the new sysfs battery interfaces, right?

...

#define SYSFS_PATH "/sys/class/power_supply"

...
char *acpi_labels[] = {
	"uevent",
	"status",
	"BAT",
	"AC",
	"POWER_SUPPLY_CAPACITY=",
	"POWER_SUPPLY_??????_FULL_DESIGN=", /* CHARGE or ENERGY */
	"POWER_SUPPLY_PRESENT=",
	"POWER_SUPPLY_??????_NOW=",
	"POWER_SUPPLY_CURRENT_NOW=",
	"POWER_SUPPLY_STATUS=",
#if ACPI_THERMAL
	"thermal_zone",
#endif
	"POWER_SUPPLY_ONLINE=",
	"POWER_SUPPLY_??????_FULL=",
	NULL
};


> Regards
> 	Stefan Lippers-Hollmann
>
> [1]	Homepage: http://kitenet.net/~joey/code/wmbattery/
> 	Vcs-Git: git://git.kitenet.net/wmbattery
>

