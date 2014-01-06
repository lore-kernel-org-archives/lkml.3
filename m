Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaAFGTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:19:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:37985 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025AbaAFGSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:18:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,611,1384329600"; 
   d="scan'208";a="454106853"
Message-ID: <52CA4AC5.5080704@linux.intel.com>
Date: Mon, 06 Jan 2014 14:18:45 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Peter Huewe <peterhuewe@gmx.de>,
        Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jiri Kosina <jkosina@suse.cz>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v2 00/13] Introduce ACPI _DSM helper functions to simplify
 code
References: <1387456702-4709-1-git-send-email-jiang.liu@linux.intel.com> <1922556.NGT5hD6mbC@vostro.rjw.lan>
In-Reply-To: <1922556.NGT5hD6mbC@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Rafael!

On 2014/1/6 5:58, Rafael J. Wysocki wrote:
> On Thursday, December 19, 2013 08:38:09 PM Jiang Liu wrote:
>> There are several drivers making use of ACPI _DSM method to detect
>> and invoke device specific methods. Currently every driver has
>> implemented its private version to support ACPI _DSM method.
>> So this patch introduces three helper functions to support ACPI _DSM
>> method, which will be used to replace open-coded versions.  It helps
>> to simplify code and improve code readability.
>>
>> It also includes some bugfixes for TPM/nouveau drivers.
>>
>> It applies to the mainstream kernel on top of
>> b0031f2 Merge tag 's2mps11-build' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
>>
>> Due to lacking of hardware platform, I have only tested the ACPI _DSM
>> helper functions and TPM related changes, but haven't tested changes to
>> other drivers yet. So appreciate help to review and test these patches.
>>
>> V1->V2
>> 1) fix an issue in initializing acpi_object structure
>>
>> Jiang Liu (13):
>>   ACPI: introduce helper interfaces to support ACPI _DSM method
>>   ACPI, extlog: replace open-coded _DSM specific code with helper
>>     functions
>>   PCI, pci-label: release allocated ACPI object on error recovery path
>>   ACPI, PCI: replace open-coded _DSM specific code with helper
>>     functions
>>   PCI, pci-label: treat PCI label with index 0 as valid label
>>   ACPI, TPM: fix memory leak when walking ACPI namespace
>>   ACPI, TPM: matching node name instead of full path when searching for
>>     TPM device
>>   ACPI, TPM: replace open-coded _DSM specific code with helper
>>     functions
>>   ACPI, TPM: detecting PPI features by checking availability of _DSM
>>     functions
>>   ACPI, i2c-hid: replace open-coded _DSM specific code with helper
>>     functions
>>   ACPI, i915: replace open-coded _DSM specific code with helper
>>     functions
>>   nouveau: fix memory leak in ACPI _DSM related code
>>   ACPI, nouveau: replace open-coded _DSM specific code with helper
>>     functions
>>
>>  drivers/acpi/acpi_extlog.c                     |   61 +---
>>  drivers/acpi/utils.c                           |   98 ++++++
>>  drivers/char/tpm/tpm_ppi.c                     |  406 +++++++++---------------
>>  drivers/gpu/drm/i915/intel_acpi.c              |  144 ++-------
>>  drivers/gpu/drm/nouveau/core/subdev/mxm/base.c |   48 +--
>>  drivers/gpu/drm/nouveau/nouveau_acpi.c         |  134 +++-----
>>  drivers/hid/i2c-hid/i2c-hid.c                  |   26 +-
>>  drivers/pci/pci-label.c                        |  129 +++-----
>>  include/acpi/acpi_bus.h                        |   26 ++
>>  9 files changed, 406 insertions(+), 666 deletions(-)
> 
> I've queued up the entire series for 3.14, thanks a lot!
> 
