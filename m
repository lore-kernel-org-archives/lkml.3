Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaIKHSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 03:18:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:6292 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaIKHSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 03:18:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="601305817"
Message-ID: <54114CA4.9030503@linux.intel.com>
Date: Thu, 11 Sep 2014 15:17:56 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Prarit Bhargava <prarit@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [Patch v4 14/16] x86, irq: Introduce helper to check whether
 an IOAPIC has been registered
References: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com> <1409192561-19744-15-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.10.1409091433150.11037@nanos> <540FBB93.4020509@linux.intel.com> <alpine.DEB.2.10.1409102206300.4178@nanos>
In-Reply-To: <alpine.DEB.2.10.1409102206300.4178@nanos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/9/11 4:08, Thomas Gleixner wrote:
> On Wed, 10 Sep 2014, Jiang Liu wrote:
>> On 2014/9/9 20:37, Thomas Gleixner wrote:
>>>> +	ret  = mp_ioapic_registered(gsi_base);
>>>> +	up_write(&acpi_ioapic_rwsem);
>>>> +
>>>> +	return ret;
>>>> +}
>>>
>>> So I assume that this is for a particular caller in the apci ioapic
>>> hotplug code and that call site has its own serialization. Otherwise
>>> the return value is not protected at all.
>>>
>>> Please add a Docbook comment to that function, and document the
>>> locking rules as thats pretty non obvious.
>> How about this comments about locking rules?
>> /*
>>  * Locks related to IOAPIC hotplug
>>  * Hotplug side:
>>  *      ->lock_device_hotplug() //device_hotplug_lock
>>  *              ->acpi_ioapic_rwsem
>>  *                      ->ioapic_lock
>>  * Interrupt mapping side:
>>  *      ->acpi_ioapic_rwsem
>>  *              ->ioapic_mutex
>>  *                      ->ioapic_lock
>>  */
> 
> That looks asymetric. Why is the hotplug side not taking ioapic_mutex?
Hi Thomas,
	We decide to protect system from IOAPIC hotplug in the ACPI
layer. For ACPI enumerated IOAPICs, ioapic_mutex is redundant and
it's used to protect MPPARSE, SFI, OF enumerated IOAPICs.
Regards!
Gerry

> 
> Thanks,
> 
> 	tglx
> 
