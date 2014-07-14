Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbaGNUWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:22:48 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:50382 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757078AbaGNUWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:22:44 -0400
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
Message-ID: <53C43BDF.2070403@ladisch.de>
Date: Mon, 14 Jul 2014 22:21:51 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
CC: Borislav Petkov <bp@alien8.de>, jdelvare@suse.de, linux@roeck-us.net,
        rdunlap@infradead.org, bhelgaas@google.com, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] hwmon, k10temp: Add support for AMD F15h M60h processor
References: <1405369388-12729-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <20140714195128.GA25124@pd.tnic>
In-Reply-To: <20140714195128.GA25124@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> On Mon, Jul 14, 2014 at 03:23:08PM -0500, Aravind Gopalakrishnan wrote:
>> +	if (boot_cpu_data.x86 == 0x15 && boot_cpu_data.x86_model == 0x60) {
>> +		pci_bus_write_config_dword(pdev->bus, PCI_DEVFN(0, 0),
>> +					   NB_SMU_IND_ADDR, IND_ADDR_OFFSET);
>> +		pci_bus_read_config_dword(pdev->bus, PCI_DEVFN(0, 0),
>> +					  NB_SMU_IND_DATA, &regval);

How do you prevent races with any other code that accesses some indirect
register?

>> +
>> +	} else
>> +		pci_read_config_dword(pdev, REG_REPORTED_TEMPERATURE, &regval);

Why the empty line?  Also, use braces in both branches.


Regards,
Clemens
