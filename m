Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaAGTbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 14:31:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39677 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaAGTbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 14:31:00 -0500
Message-ID: <52CC55EF.90006@infradead.org>
Date: Tue, 07 Jan 2014 11:30:55 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "David E. Box" <david.e.box@linux.intel.com>
CC: mjg59@srcf.ucam.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH v6][RESEND] platform: x86: New BayTrail IOSF-SB MBI driver
References: <1388427149-25456-1-git-send-email-david.e.box@linux.intel.com> <1389117812-28061-1-git-send-email-david.e.box@linux.intel.com> <52CC4427.20405@infradead.org> <20140107184805.GA28135@linux.intel.com>
In-Reply-To: <20140107184805.GA28135@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/14 10:48, David E. Box wrote:
> On Tue, Jan 07, 2014 at 10:15:03AM -0800, Randy Dunlap wrote:
>> On 01/07/14 10:03, David E. Box wrote:
>>> From: "David E. Box" <david.e.box@linux.intel.com>
>>>
>>> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
>>> index b51a746..6e199a5 100644
>>> --- a/drivers/platform/x86/Kconfig
>>> +++ b/drivers/platform/x86/Kconfig
>>> @@ -819,4 +819,14 @@ config PVPANIC
>>>  	  a paravirtualized device provided by QEMU; it lets a virtual machine
>>>  	  (guest) communicate panic events to the host.
>>>  
>>> +config INTEL_BAYTRAIL_MBI
>>> +	tristate
>>
>> Is this kconfig option displayed when you run menuconfig/nconfig/xconfig/gconfig etc.?
>> Doesn't it need a prompt string?
>> How did you enable it and test it?
>>
> 
> It is not displayed on purpose. The driver isn't exposed to user space.
> It was tested by adding the option to .config, both as module and built-in.
> 
>>> +	depends on PCI
>>> +	---help---
>>> +	  Needed on Baytrail platforms for access to the IOSF Sideband Mailbox
>>> +	  Interface. This is a requirement for systems that need to configure
>>> +	  the PUNIT for power management features such as RAPL. Register
>>> +	  addresses and r/w opcodes are defined in
>>
>> Think of users reading this.  At least change "r/w" to read/write.
>> What is IOSF?  does it matter here?
>> PUNIT?  RAPL?
>>
> 
> If you don't know what the IOSF Sideband is you probably shouldn't be enabling
> this feature. Users of this driver (of which for now there are few) will be
> kernel space drivers that should have ample knowledge of the registers this
> interface provides access to.

I see.  Thanks.


-- 
~Randy
