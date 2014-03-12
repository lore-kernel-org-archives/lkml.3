Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaCLLsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:48:14 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:4953 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaCLLsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:48:12 -0400
Message-ID: <53204956.30703@huawei.com>
Date: Wed, 12 Mar 2014 19:47:34 +0800
From: Liu hua <sdu.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: <linux@arm.linux.org.uk>
CC: <will.deacon@arm.com>, <nicolas.pitre@linaro.org>, <msalter@redhat.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Wang Nan <wangnan0@huawei.com>, <peifeiyue@huawei.com>,
        <wangkefeng.wang@huawei.com>, Li Zefan <lizefan@huawei.com>
Subject: [ARM]Fixmap mapping region is not enough for system of 14+ CPUs.
References: <53203F9C.8040500@huawei.com>
In-Reply-To: <53203F9C.8040500@huawei.com>
X-Forwarded-Message-Id: <53203F9C.8040500@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.58.238]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell, Will or Nicolas,

(In this mail, we only discuss ARM 32-bit linux.)

As we know, the region (0xfff00000-0xfffdffff) is reserved as fixmap
mapping region.

The function "kmap_atomic" maps highmem pages to this region referring
to CPUID and per-cpu variable "__kmap_atomic_idx" via

  idx = type + KM_TYPE_NR * smp_processor_id();
  vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);

Size of region used by one cpu is 0x10000 (KM_TYPE_NR << PAGE_SHIFT).
And the total size of the fixmap mapping region is 0xe0000.
(only support 14 CPUs).

So in a system of more than 14 CPUs, this region is not large enough.
should we change the memory layout on ARM Linux to support 14+ cpu system ?
Or can we do anything else to support that ?


Thanks,

Liu Hua






.




