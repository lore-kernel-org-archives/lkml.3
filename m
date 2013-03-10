Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab3CJBL6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 20:11:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab3CJBL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 20:11:57 -0500
Message-ID: <513BDDCE.2050502@redhat.com>
Date: Sat, 09 Mar 2013 20:11:42 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Don Dutile <ddutile@redhat.com>
CC: Andreas Mohr <andi@lisas.de>, Neil Horman <nhorman@tuxdriver.com>,
        linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
References: <20130302155942.GA353@rhlx01.hs-esslingen.de> <5134A080.9070308@redhat.com>
In-Reply-To: <5134A080.9070308@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2013 08:24 AM, Don Dutile wrote:
> On 03/02/2013 10:59 AM, Andreas Mohr wrote:
>> Hi,
>>
>>> if ((revision == 0x13)&&  irq_remapping_enabled) {
>>> +        pr_warn("WARNING WARNING WARNING WARNING WARNING
>>> WARNING\n"
>>> +            "This system BIOS has enabled interrupt
>>> remapping\n"
>>> +            "on a chipset that contains an errata making
>>> that\n"
>>> +            "feature unstable.  Please reboot with
>>> nointremap\n"
>>> +            "added to the kernel command line and contact\n"
>>> +            "your BIOS vendor for an update");
>>> +    }
>>
>> Forgive me, but ISTR that there's a special BIOS firmware quirk bug annotating
>> logger warning message mechanism (have I managed to hit all keywords yet? ;)
>> in the kernel which might be useful in this case.
>>
>>
>> OK, found something (but I don't think it was the mechanism
>> that ISTR - perhaps it got modernized?):
>>
>>
>> include/linux/printk.h:
>>
>> /*
>>   * FW_BUG
>>   * Add this to a message where you are sure the firmware is buggy or
>>   * behaves
>>   * really stupid or out of spec. Be aware that the responsible BIOS
>>   * developer
>>   * should be able to fix this issue or at least get a concrete idea of
>>   * the
>>   * problem by reading your message without the need of looking at the
>>   * kernel
>>   * code.
>>   *
>>   * Use it for definite and high priority BIOS bugs.
>>   *
>>   * FW_WARN
>>   * Use it for not that clear (e.g. could the kernel messed up things
>>   * already?)
>>   * and medium priority BIOS bugs.
>>   *
>>   * FW_INFO
>>   * Use this one if you want to tell the user or vendor about something
>>   * suspicious, but generally harmless related to the firmware.
>>   *
>>   * Use it for information or very low priority BIOS bugs.
>>   */
>>
> 
> It is not a firmware/BIOS bug. 

Correct.  This is a hardware bug that *may be* resolved through a BIOS update.
But there is no guarantee that a BIOS update is available.  Labelling it a FW
bug would be a mistake.

Prarit's comment to annotate it as
> a HW_ERR is more accurate.  A software patch is being tested now
> to see if it can do set-affinity in a manner that avoids this race
> and enables IR to stay on for all these systems.  It requires
> more testing to ensure the logic is valid.  This patch was
> recommended as a necessary short-term fix, and to highlight to
> others this possible state -- which Gerry mentioned he had.

Yup -- as mstowe asked ... should we even consider this patch then, or should we
wait for the possible real fix?

Having said that ... I'm nervous about playing around with the set-affinity path
for this HW problem.  We're basically changing good/reliable code for broken-ass
hardware.  :/  That doesn't seem a like a good choice to me.

I can understand if we all feel that the code is broken, or it can be made
better -- but to change it because of bad HW  just doesn't seem like the right
thing to do.

IMO.

P.
