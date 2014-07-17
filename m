Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934651AbaGQQDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:03:13 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:36690 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757418AbaGQQDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:03:09 -0400
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <53C7F389.7010007@ladisch.de>
Date: Thu, 17 Jul 2014 18:02:17 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Guenter Roeck <linux@roeck-us.net>
CC: Borislav Petkov <bp@alien8.de>, jdelvare@suse.de, rdunlap@infradead.org,
        bhelgaas@google.com, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] hwmon, k10temp: Add support for AMD F15h M60h processor
References: <1405369388-12729-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <20140714195128.GA25124@pd.tnic> <53C43BDF.2070403@ladisch.de> <20140714203336.GA30926@roeck-us.net> <53C4DB2D.80406@ladisch.de> <53C4EE5C.5020407@roeck-us.net> <53C7EA41.8030907@amd.com>
In-Reply-To: <53C7EA41.8030907@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aravind Gopalakrishnan wrote:
> On 7/15/2014 4:03 AM, Guenter Roeck wrote:
>> On 07/15/2014 12:41 AM, Clemens Ladisch wrote:
>>> Guenter Roeck wrote:
>>>> On Mon, Jul 14, 2014 at 10:21:51PM +0200, Clemens Ladisch wrote:
>>>>> Borislav Petkov wrote:
>>>>>> On Mon, Jul 14, 2014 at 03:23:08PM -0500, Aravind Gopalakrishnan wrote:
>>>>>>> +    if (boot_cpu_data.x86 == 0x15 && boot_cpu_data.x86_model == 0x60) {
>>>>>>> +        pci_bus_write_config_dword(pdev->bus, PCI_DEVFN(0, 0),
>>>>>>> +                       NB_SMU_IND_ADDR, IND_ADDR_OFFSET);
>>>>>>> +        pci_bus_read_config_dword(pdev->bus, PCI_DEVFN(0, 0),
>>>>>>> +                      NB_SMU_IND_DATA, &regval);
>>>>>
>>>>> How do you prevent races with any other code that accesses some indirect
>>>>> register?
>>>
>>> If there actually is any other code; these indirect SMU registers appear
>>> to be mostly undocumented and to be intended to be used by the BIOS.
>>> (Which makes me wonder why the temperature sensor was moved there.)
>>
>> Scary. Does that mean there is a chance they may get used through ACPI ?
>
> I have been asking internally about this, and looks like it's just a register address change.
> So we probably don't have to worry about this being used elsewhere..

The conflict is about the SMU index register; the question is whether
_any_ of these SMU registers is used elsewhere (in a way that could
happen concurrently).


Regards,
Clemens
