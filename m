Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab3HWSiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:38:46 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:50427 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab3HWSio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:38:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAOLK0pwQJVvcT5xA-+Ftb85FzbjHN-OZmXO=n7r4EWh4nFjSBA@mail.gmail.com>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
	<1376189294-32022-29-git-send-email-yinghai@kernel.org>
	<CANVTcTYhSfU+Su9s1B+mTTBfgsZgqvQxHiTsLck1zT_vg1Cs4g@mail.gmail.com>
	<CANVTcTb2+qX6XMBqrzeLho9yFS55AnztVJ85JBMuxjoH11qzaQ@mail.gmail.com>
	<CAOLK0pwQJVvcT5xA-+Ftb85FzbjHN-OZmXO=n7r4EWh4nFjSBA@mail.gmail.com>
Date: Fri, 23 Aug 2013 11:38:44 -0700
X-Google-Sender-Auth: _sB8GrZec7BRfArMpVvjkt_Whx0
Message-ID: <CAE9FiQWnGaa6omcLW0zxLj+UMspRGxjVoYXUsH3ndydGD51T9w@mail.gmail.com>
Subject: Re: [PATCH v4 28/28] PCI, x86, ACPI: get ioapic address from acpi device
From: Yinghai Lu <yinghai@kernel.org>
To: Lan Tianyu <lantianyu1986@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: rui wang <ruiv.wang@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Linux PCI <linux-pci@vger.kernel.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 8:34 AM, Lan Tianyu <lantianyu1986@gmail.com> wrote:
>> I worked around the problem by replacing acpi_resource_to_address64()
>> with resource_to_addr().  But resource_to_addr() is a static function
>> in arch/x86/pci/acpi.c, not very convenient to use. Here's what I did:
>>
>
> Hi Rui&Yinghai:
>            How about using the following code to translate struct
>  acpi_resource to struct resouce in this setup_res()?
>
>          if (acpi_dev_resource_address_space(...)
>                 || acpi_dev_resource_memory(..))
>               return AE_OK;

Yest, that could be better, will update that.

Also can you submit patch that will use that in res_to_addr of
arch/x86/pci/acpi.c?

Thanks

Yinghai
