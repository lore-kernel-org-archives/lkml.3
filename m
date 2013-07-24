Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab3GXPz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:55:56 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:36859 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3GXPzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:55:52 -0400
Date: Wed, 24 Jul 2013 11:55:46 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 13/21] x86, acpi: Try to find SRAT in firmware earlier.
Message-ID: <20130724155546.GB20377@mtj.dyndns.org>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
 <1374220774-29974-14-git-send-email-tangchen@cn.fujitsu.com>
 <20130723204949.GR21100@mtj.dyndns.org>
 <51EFA873.9050300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EFA873.9050300@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 06:12:03PM +0800, Tang Chen wrote:
> Do you mean get the SRAT's address without touching any ACPI global
> variables, such as acpi_gbl_root_table_list ?
> 
> The physical addresses of all tables is stored in RSDT (Root System
> Description Table), which is the root table. We need to parse RSDT
> to get SRAT address.
> 
> Using acpi_gbl_root_table_list is very convenient. The initialization
> of acpi_gbl_root_table_list is using acpi_os_map_memory(), so it can be
> done before init_mem_mapping() and relocate_initrd().
> 
> With acpi_gbl_root_table_list initialized, we can iterate it and find
> SRAT easily. Otherwise, we have to do the same procedure to parse RSDT,
> and find SRAT, which I don't think could be any simpler. I think reuse
> the existing acpi_gbl_root_table_list code is better.

I see.  As long as ACPI people are fine with the modifications, I
don't mind either way.

Thanks.

-- 
tejun
