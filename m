Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaAWCVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 21:21:05 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:11779 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbaAWCVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 21:21:01 -0500
Message-ID: <52E07C49.9070509@huawei.com>
Date: Thu, 23 Jan 2014 10:19:53 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "David Airlie" <airlied@linux.ie>, <intel-gfx@lists.freedesktop.org>,
        "DRI mailing list" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Airlie <airlied@redhat.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH v4] ACPI: Fix acpi_evaluate_object() return value check
References: <1390272375-28728-1-git-send-email-wangyijing@huawei.com> <CAErSpo4_VCVHcq2cs_HP-_0kFSnUWsxsr6Y1iiR==3XLNaVc2w@mail.gmail.com>
In-Reply-To: <CAErSpo4_VCVHcq2cs_HP-_0kFSnUWsxsr6Y1iiR==3XLNaVc2w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/23 5:37, Bjorn Helgaas wrote:
> On Mon, Jan 20, 2014 at 7:46 PM, Yijing Wang <wangyijing@huawei.com> wrote:
>> Since acpi_evaluate_object() returns acpi_status and not plain int,
>> ACPI_FAILURE() should be used for checking its return value.
>>
>> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>> v3->v4: Fix spell error, add Jani Nikula reviewed-by.
>> v2->v3: Fix compile error pointed out by Hanjun.
>> v1->v2: Add CC to related subsystem MAINTAINERS
>> ---
>>  drivers/gpu/drm/i915/intel_acpi.c              |   24 ++++++++++++++----------
>>  drivers/gpu/drm/nouveau/core/subdev/mxm/base.c |    9 +++++----
>>  drivers/gpu/drm/nouveau/nouveau_acpi.c         |   23 +++++++++++++----------
>>  drivers/pci/pci-label.c                        |    9 ++++++---
> 
> For the drivers/pci/pci-label.c part,
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Thanks.

> 
>> +       status = acpi_evaluate_object(handle, "_DSM", &input, &output);
>> +       if (ACPI_FAILURE(status)) {
>> +               DRM_DEBUG_DRIVER("failed to evaluate _DSM: %s\n",
>> +                               acpi_format_exception(status));
> 
> It's too bad there isn't an easy way to produce more informative error
> messages, e.g., by including a namespace path or something.  A message
> like:
> 
>     failed to evaluate _DSM: A requested entity is not found
> 
> is only useful if there's enough context to figure out what's going on.

Yes, I will add the namespace path into the debug info, thanks!

> 
> Bjorn
> 
> .
> 


-- 
Thanks!
Yijing

