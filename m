Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbaGOHli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 03:41:38 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:33321 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755536AbaGOHlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 03:41:37 -0400
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
Message-ID: <53C4DB2D.80406@ladisch.de>
Date: Tue, 15 Jul 2014 09:41:33 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@alien8.de>, jdelvare@suse.de,
        rdunlap@infradead.org, bhelgaas@google.com, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] hwmon, k10temp: Add support for AMD F15h M60h processor
References: <1405369388-12729-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <20140714195128.GA25124@pd.tnic> <53C43BDF.2070403@ladisch.de> <20140714203336.GA30926@roeck-us.net>
In-Reply-To: <20140714203336.GA30926@roeck-us.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck wrote:
> On Mon, Jul 14, 2014 at 10:21:51PM +0200, Clemens Ladisch wrote:
>> Borislav Petkov wrote:
>>> On Mon, Jul 14, 2014 at 03:23:08PM -0500, Aravind Gopalakrishnan wrote:
>>>> +	if (boot_cpu_data.x86 == 0x15 && boot_cpu_data.x86_model == 0x60) {
>>>> +		pci_bus_write_config_dword(pdev->bus, PCI_DEVFN(0, 0),
>>>> +					   NB_SMU_IND_ADDR, IND_ADDR_OFFSET);
>>>> +		pci_bus_read_config_dword(pdev->bus, PCI_DEVFN(0, 0),
>>>> +					  NB_SMU_IND_DATA, &regval);
>>
>> How do you prevent races with any other code that accesses some indirect
>> register?
>>
> I just wanted to ask exactly the same question. I think this will need
> locking.

If there actually is any other code; these indirect SMU registers appear
to be mostly undocumented and to be intended to be used by the BIOS.
(Which makes me wonder why the temperature sensor was moved there.)

Anyway, if a lock is needed, it looks as if it could go into a helper
function such as "amd_nb_smu_ind_read()" in arch/x86/kernel/amd_nb.c.


Regards,
Clemens
