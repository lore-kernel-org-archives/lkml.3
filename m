Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763Ab3E3BF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 21:05:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:27493 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab3E3BFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 21:05:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,767,1363158000"; 
   d="scan'208";a="309818396"
Message-ID: <51A6A5E7.1040601@intel.com>
Date: Thu, 30 May 2013 09:05:43 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH RFC] PM / Runtime: Rework the "runtime idle" helper routine
References: <Pine.LNX.4.44L0.1305291023170.1473-100000@iolanthe.rowland.org> <1645401.1grgttHPMR@vostro.rjw.lan>
In-Reply-To: <1645401.1grgttHPMR@vostro.rjw.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 06:18 AM, Rafael J. Wysocki wrote:
> On Wednesday, May 29, 2013 10:51:11 AM Alan Stern wrote:
>> On Wed, 29 May 2013, Rafael J. Wysocki wrote:
>>
>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>
>>> The "runtime idle" helper routine, rpm_idle(), currently ignores
>>> return values from .runtime_idle() callbacks executed by it.
>>>
>>> However, it turns out that many subsystems use the generic idle
>>> callback routine pm_generic_runtime_idle() which checks the return
>>> value of the driver's callback and executes pm_runtime_suspend() for
>>> the device unless that value is different from 0.  If that logic is
>>> moved to rpm_idle() instead, pm_generic_runtime_idle() can be dropped
>>> and its users will not need any .runtime_idle() callbacks any more.
>>
>> Since you're making this change, wouldn't it be a good idea to adopt
>> Mika's original suggestion and turn on the RPM_AUTO bit in rpmflags
>> when the use_autosuspend flag is set?
> 
> I'm not actually sure.  It can be done, but I'd prefer to do that as a separate
> change in any case.

For SCSI idle callback, that would be a welcome change, where instead of
calling pm_runtime_autosuspend and then return -EBUSY, it can be changed
to simply return 0 after mark_last_busy.

Thanks,
Aaron
