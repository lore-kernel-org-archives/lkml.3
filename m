Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaIJO2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:28:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44539 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbaIJO2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:28:47 -0400
Message-ID: <54106010.8040206@ti.com>
Date: Wed, 10 Sep 2014 10:28:32 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <bhelgaas@google.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] PCI: keystone: update to support multiple pci
 ports
References: <1410293835-13050-1-git-send-email-m-karicheri2@ti.com> <3967092.l9bxcqMaSa@wuerfel> <540F8425.70304@ti.com> <3814561.AbrslYBNjb@wuerfel>
In-Reply-To: <3814561.AbrslYBNjb@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 04:22 AM, Arnd Bergmann wrote:
> On Tuesday 09 September 2014 18:50:13 Murali Karicheri wrote:
>> My mistake. It is the device ID, not vendor ID. The PCI driver supports
>> PCI h/w on K2HK, K2E and K2L SoCs for which PCI device IDs are assigned as
>>
>> +#define PCIE_RC_K2HK           0xb008
>> +#define PCIE_RC_K2E            0xb009
>> +#define PCIE_RC_K2L            0xb00a
>> +
>>
>> and the same driver code runs on all these h/w. The device ID is not
>> filled in by default by the h/w, in the config space of the RC at offset
>> 1000h "VENDOR_DEVICE_ID Vendor and Device Identification Register".
>> Same is available in a seperate SoC register whose offset is specified
>> by index 2. This is read by driver and updated in the config space. The
>> Vendor ID is however set by default.
>>
>> There is a mrrs PCI quirk required for Keystone PCI which depends on
>> this vendor ID to be filled correctly as it match vendor id/ device id
>> of the bridge device to apply the quirk.
>>
>> Hope this clarify your question.
>
> Ok, I understand now. Yes, this makes sense, though I wonder if it would
> have been easier to handle the quirk in a different way based on the
> driver rather than the PCI ID. It's probably not worth revisiting though,
> unless Bjorn wants to see it done differently now.

Bjorn has reviewed the quirk patch and wanted to check the device ID and 
vendor ID to avoid applying the quirck when bridge is non TI and same 
device ID.

So support for two PCI port requires only the PCI device id related 
change. So I will modify the subject and commit log to reflect the same 
and re-send the patch.

Thanks again Arnd for your comments.

Regards,

Murali
>
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

