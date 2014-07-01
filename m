Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbaGAIVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:21:21 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37196 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397AbaGAIVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:21:18 -0400
Message-ID: <53B26F44.7050404@linaro.org>
Date: Tue, 01 Jul 2014 16:20:20 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        "rric@kernel.org" <rric@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Al Stone <al.stone@linaro.org>
Subject: Re: [PATCH v4 13/13] ARM64 / ACPI: Enable ARM64 in Kconfig
References: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org> <1403840976-7456-14-git-send-email-hanjun.guo@linaro.org> <20140630104652.GG28951@arm.com> <53B2694F.7070501@linaro.org>
In-Reply-To: <53B2694F.7070501@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>>>  	depends on PCI
>>>  	select PNP
>>> -	default y
>>> +	default y if !ARM64
>>
>> For the benefit of single Image, I think you can default to y here.
> 
> It ok to me. if we default to y here, devicetree will not be unflattened
> in default, is it ok to you? you can refer to "[PATCH 12/13] ARM64 / ACPI: if
> we chose to boot from acpi then disable FDT".

Ah, sorry I didn't describe it clearly. since there is no shipping board
with ACPI tables, so ACPI will disabled in the very early stage and FDT
still have chance to be unflattened, so will not break DT booting in
this patchset.

Thanks
Hanjun

