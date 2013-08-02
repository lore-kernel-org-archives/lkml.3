Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab3HBFvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 01:51:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6947 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab3HBFvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 01:51:00 -0400
X-IronPort-AV: E=Sophos;i="4.89,799,1367942400"; 
   d="scan'208";a="8095878"
Message-ID: <51FB485A.9070801@cn.fujitsu.com>
Date: Fri, 02 Aug 2013 13:49:14 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 10/18] x86, acpi: Try to find if SRAT is overrided
 earlier.
References: <1375340800-19332-1-git-send-email-tangchen@cn.fujitsu.com>  <1375340800-19332-11-git-send-email-tangchen@cn.fujitsu.com> <1375406353.10300.73.camel@misato.fc.hp.com>
In-Reply-To: <1375406353.10300.73.camel@misato.fc.hp.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/02 13:49:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/02 13:49:34,
	Serialize complete at 2013/08/02 13:49:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 09:19 AM, Toshi Kani wrote:
......
>> +phys_addr_t __init early_acpi_override_srat(void)
>> +{
>> +	int i;
>> +	u32 length;
>> +	long offset;
>> +	void *ramdisk_vaddr;
>> +	struct acpi_table_header *table;
>> +	struct cpio_data file;
>> +	unsigned long map_step = NR_FIX_BTMAPS<<  PAGE_SHIFT;
>> +	phys_addr_t ramdisk_image = get_ramdisk_image();
>> +	char cpio_path[32] = "kernel/firmware/acpi/";
>
> Don't you need to check if ramdisk is present before parsing the table?
> You may need something like:
>
>    if (!ramdisk_image || !get_ramdisk_size())
>          return 0;

Yes, it is better to do such a check here. But is there a possibility that
no ramdisk is present and we come to setup_arch() ?

......
>> +
>> +	return ramdisk_image;
>
> Doesn't this function return a physical address regardless of SRAT if a
> ramdisk is present?

Yes, and it is not good. I'll add the check above so that this won't happen.

Thanks.

