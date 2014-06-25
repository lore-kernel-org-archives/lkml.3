Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaFYC2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 22:28:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:37982 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbaFYC2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 22:28:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,542,1400050800"; 
   d="scan'208";a="449619349"
Message-ID: <53AA33C5.7060501@intel.com>
Date: Wed, 25 Jun 2014 10:28:21 +0800
From: "Chen, Tiejun" <tiejun.chen@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Zhenyu Wang <zhenyuw@linux.intel.com>
CC: daniel.vetter@ffwll.ch, jani.nikula@linux.intel.com, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        qemu-devel@nongnu.org
Subject: Re: [Intel-gfx] [RFC][PATCH] gpu:drm:i915:intel_detect_pch: back
 to check devfn instead of check class type
References: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com> <20140624025944.GJ1045@zhen-hp.sh.intel.com>
In-Reply-To: <20140624025944.GJ1045@zhen-hp.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/24 10:59, Zhenyu Wang wrote:
> On 2014.06.19 17:53:51 +0800, Tiejun Chen wrote:
>> Originally the reason to probe ISA bridge instead of Dev31:Fun0
>> is to make graphics device passthrough work easy for VMM, that
>> only need to expose ISA bridge to let driver know the real
>> hardware underneath. This is a requirement from virtualization
>> team. Especially in that virtualized environments, XEN, there
>> is irrelevant ISA bridge in the system with that legacy qemu
>> version specific to xen, qemu-xen-traditional. So to work
>> reliably, we should scan through all the ISA bridge devices
>> and check for the first match, instead of only checking the
>> first one.
>>
>> But actually, qemu-xen-traditional, is always enumerated with
>> Dev31:Fun0, 00:1f.0 as follows:
>>
>> hw/pt-graphics.c:
>>
>> intel_pch_init()
>>      |
>>      + pci_isa_bridge_init(bus, PCI_DEVFN(0x1f, 0), ...);
>>
>> so this mean that isa bridge is still represented with Dev31:Func0
>> like the native OS. Furthermore, currently we're pushing VGA
>> passthrough support into qemu upstream, and with some discussion,
>> we wouldn't set the bridge class type and just expose this devfn.
>>
>> So we just go back to check devfn to make life normal.
>>
>> Signed-off-by: Tiejun Chen <tiejun.chen@intel.com>
>
> This was added historically when supporting graphics device passthrough.
> Looks qemu upstream can't accept multiple ISA bridge and our PCH is always
> on device 31: func0 as far as I know. Looks good to me.
>
> Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
>

Thanks for your review.

Do you know when this can be applied?

Tiejun
