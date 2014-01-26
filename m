Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaAZJcA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 04:32:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:34450 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbaAZJby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 04:31:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,723,1384329600"; 
   d="scan'208";a="470928816"
Message-ID: <52E4D607.6090509@linux.intel.com>
Date: Sun, 26 Jan 2014 17:31:51 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, jrg.otte@gmail.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [kernel 3.13.0-06058-g2d08cd0] Strange ACPI error messages
References: <CADDKRnDZt9Q4XKyJcO1htMrCJYj6_5yECURBHsJ7O==hup7ZRw@mail.gmail.com> <4387759.ffnsEjDaad@vostro.rjw.lan> <20140125161817.GB25531@khazad-dum.debian.net> <2010872.ETICEKhYmO@vostro.rjw.lan>
In-Reply-To: <2010872.ETICEKhYmO@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
	I will take care of this issue and send out a patch soon.
Thanks!
Gerry

On 2014/1/26 6:31, Rafael J. Wysocki wrote:
> On Saturday, January 25, 2014 02:18:17 PM Henrique de Moraes Holschuh wrote:
>> On Sat, 25 Jan 2014, Rafael J. Wysocki wrote:
>>> On Saturday, January 25, 2014 02:53:24 PM Rafael J. Wysocki wrote:
>>>> On Saturday, January 25, 2014 11:03:09 AM Jörg Otte wrote:
>>>>> Kernel 3.13.0-06058-g2d08cd0 displays following errors on the console:
>>>>>
>>>>> ACPI: \_PR_.CPU4: failed to get CPU APIC ID.
>>>>> ACPI: \_PR_.CPU5: failed to get CPU APIC ID.
>>>>> ACPI: \_PR_.CPU6: failed to get CPU APIC ID.
>>>>> ACPI: \_PR_.CPU7: failed to get CPU APIC ID.
>>>>>
>>>>> I don't have CPUs 4..7! Error messages regarding not existing
>>>>> CPUs should not be displayed.
>>>>> kernel 3.13.0-05617-g3aacd62 and before did'nt show this messages.
>>>>>
>>>>> This is a regression. I never saw this messages before.
>>>>
>>>> Does your system show any other suspicious symptoms or are you worried about
>>>> those messages only?
>>>
>>> Gerry, this is your commit b981513f806d (ACPI / scan: bail out early if failed
>>> to parse APIC ID for CPU).  Apparently, the BIOS has room for 4 CPUs more than
>>> there actually are in the system.  Maybe we can reduce the log level of those
>>> messages to avoid ringing bells unnecessarily?
>>
>> It is standard practice (at least in SuperMicro boxes, but I've also seen it
>> elsewhere) for the BIOS to have ACPI tables mentioning all cores supported
>> by the biggest core-count CPU topology possible by the motherboard.  The
>> cores you don't have are reported as if they were hotpluggable but absent,
>> even if they will *never* show up at runtime.  Meh.
>>
>> So yes, such warnings will get annoying *very* quickly.
> 
> Well, what about using acpi_handle_debug() in there, then?
> 
