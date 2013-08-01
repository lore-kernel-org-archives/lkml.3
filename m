Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3HAIiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:38:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55825 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3HAIiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:38:06 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <51FA1E41.20304@jp.fujitsu.com>
Date: Thu, 1 Aug 2013 17:37:21 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: <rafael.j.wysocki@intel.com>, <vasilis.liaskovitis@profitbricks.com>,
        <toshi.kani@hp.com>
CC: <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <tangchen@cn.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: Cannot hot remove a memory device
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By following commit, I cannot hot remove a memory device.

ACPI / memhotplug: Bind removable memory blocks to ACPI device nodes
commit e2ff39400d81233374e780b133496a2296643d7d

Details are follows:
When I add a memory device, acpi_memory_enable_device() always fails
as follows:

...
[ 1271.114116]  [ffffea121c400000-ffffea121c7fffff] PMD -> [ffff880813c00000-ffff880813ffffff] on node 3
[ 1271.128682]  [ffffea121c800000-ffffea121cbfffff] PMD -> [ffff880813800000-ffff880813bfffff] on node 3
[ 1271.143298]  [ffffea121cc00000-ffffea121cffffff] PMD -> [ffff880813000000-ffff8808133fffff] on node 3
[ 1271.157799]  [ffffea121d000000-ffffea121d3fffff] PMD -> [ffff880812c00000-ffff880812ffffff] on node 3
[ 1271.172341]  [ffffea121d400000-ffffea121d7fffff] PMD -> [ffff880812800000-ffff880812bfffff] on node 3
[ 1271.186872]  [ffffea121d800000-ffffea121dbfffff] PMD -> [ffff880812400000-ffff8808127fffff] on node 3
[ 1271.201481]  [ffffea121dc00000-ffffea121dffffff] PMD -> [ffff880812000000-ffff8808123fffff] on node 3
[ 1271.216041]  [ffffea121e000000-ffffea121e3fffff] PMD -> [ffff880811c00000-ffff880811ffffff] on node 3
[ 1271.230623]  [ffffea121e400000-ffffea121e7fffff] PMD -> [ffff880811800000-ffff880811bfffff] on node 3
[ 1271.245148]  [ffffea121e800000-ffffea121ebfffff] PMD -> [ffff880811400000-ffff8808117fffff] on node 3
[ 1271.259683]  [ffffea121ec00000-ffffea121effffff] PMD -> [ffff880811000000-ffff8808113fffff] on node 3
[ 1271.274194]  [ffffea121f000000-ffffea121f3fffff] PMD -> [ffff880810c00000-ffff880810ffffff] on node 3
[ 1271.288764]  [ffffea121f400000-ffffea121f7fffff] PMD -> [ffff880810800000-ffff880810bfffff] on node 3
...	
[ 1271.325841] acpi PNP0C80:03: acpi_memory_enable_device() error
...	

By this failure, hot added acpi_memory_info->enalbed is not set to 1.
So when hot removing the memory device, acpi_memory_remove_memory() does
nothing, since acpi_memory_info->enabled is 0. Thus I cannot hot remove
the memory device.

According to the messages, add_memory() succeeded. So I think that it is
caused by failing acpi_bind_memory_blocks().

I'm now investigating why acpi_bind_memory_blocks() fails.

Thanks,
Yasuaki Ishimatsu

