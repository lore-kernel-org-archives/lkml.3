Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab3BTVgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:36:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab3BTVgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:36:52 -0500
Date: Wed, 20 Feb 2013 13:36:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: jiang.liu@huawei.com, wujianguo@huawei.com, hpa@zytor.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com,
        yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [Bug fix PATCH 0/2] Make whatever node kernel resides in
 un-hotpluggable.
Message-Id: <20130220133650.4e0913f3.akpm@linux-foundation.org>
In-Reply-To: <1361358056-1793-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1361358056-1793-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013 19:00:54 +0800
Tang Chen <tangchen@cn.fujitsu.com> wrote:

> As mentioned by HPA before, when we are using movablemem_map=acpi, if all the
> memory in SRAT is hotpluggable, then the kernel will have no memory to use, and
> will fail to boot.
> 
> Before parsing SRAT, memblock has already reserved some memory in memblock.reserve,
> which is used by the kernel, such as storing the kernel image. We are not able to
> prevent the kernel from using these memory. So, these 2 patches make the node which
> the kernel resides in un-hotpluggable.

I'm planning to roll all these into a single commit:

acpi-memory-hotplug-support-getting-hotplug-info-from-srat.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix-fix-fix-fix.patch

for reasons of tree-cleanliness and to avoid bisection holes.  They're
at http://ozlabs.org/~akpm/mmots/broken-out/.

Can you please check the changelog for
acpi-memory-hotplug-support-getting-hotplug-info-from-srat.patch to see
if it needs any updates due to all the fixup patches?  If so, please
send me the new changelog, thanks.

Also, please review the changelogging for these:

page_alloc-add-movable_memmap-kernel-parameter.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-rename-movablecore_map-to-movablemem_map.patch

memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix-fix-fix.patch

memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix.patch

memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix-fix.patch

acpi-memory-hotplug-parse-srat-before-memblock-is-ready.patch
acpi-memory-hotplug-parse-srat-before-memblock-is-ready-fix.patch
acpi-memory-hotplug-parse-srat-before-memblock-is-ready-fix-fix.patch


and while we're there, let's pause to admire how prescient I was in
refusing to merge all this into 3.8-rc1 :)
