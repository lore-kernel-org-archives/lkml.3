Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab3HBHul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 03:50:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64469 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757858Ab3HBHui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 03:50:38 -0400
X-IronPort-AV: E=Sophos;i="4.89,799,1367942400"; 
   d="scan'208";a="8097089"
Message-ID: <51FB646F.30604@cn.fujitsu.com>
Date: Fri, 02 Aug 2013 15:49:03 +0800
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
Subject: Re: [PATCH v2 06/18] x86, acpi: Initialize ACPI root table list earlier.
References: <1375340800-19332-1-git-send-email-tangchen@cn.fujitsu.com>  <1375340800-19332-7-git-send-email-tangchen@cn.fujitsu.com> <1375401251.10300.53.camel@misato.fc.hp.com>
In-Reply-To: <1375401251.10300.53.camel@misato.fc.hp.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/02 15:49:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/02 15:49:20,
	Serialize complete at 2013/08/02 15:49:20
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 07:54 AM, Toshi Kani wrote:
......
>>   /*
>> + * acpi_root_table_init - Initialize acpi_gbl_root_table_list.
>> + *
>> + * This function will parse RSDT or XSDT, find all tables' phys addr,
>> + * initialize acpi_gbl_root_table_list, and record all tables' phys addr
>> + * in acpi_gbl_root_table_list.
>> + */
>> +void __init acpi_root_table_init(void)
>
> I think acpi_root_table_init() is a bit confusing with
> acpi_boot_table_init().  Perhaps, something like
> acpi_boot_table_pre_init() or early_acpi_boot_table_init() is better to
> indicate that this new function is called before acpi_boot_table_init().
>

OK, will change it to early_acpi_boot_table_init().

>> +{
>> +	dmi_check_system(acpi_dmi_table);
>> +
>> +	/* If acpi_disabled, bail out */
>> +	if (acpi_disabled)
>> +		return;
>> +
>> +	/* Initialize the ACPI boot-time table parser */
>> +	if (acpi_table_init()) {
>> +		disable_acpi();
>> +		return;
>> +	}
>> +}
>> +
>> +/*
>>    * acpi_boot_table_init() and acpi_boot_init()
>>    *  called from setup_arch(), always.
>>    *	1. checksums all tables
>> @@ -1511,21 +1533,7 @@ static struct dmi_system_id __initdata acpi_dmi_table_late[] = {
>>
>>   void __init acpi_boot_table_init(void)
>
> The comment of this function needs to be updated.  For instance, it
> describes acpi_table_init(), which you just relocated.
>
>   * acpi_table_init() is separate to allow reading SRAT without
>   * other side effects.
>   *

Sure. But I don't quite understand this comment. It seems that
acpi_table_init() has nothing to do with SRAT.

Do you know anything about this ?

>
>>   {
>> -	dmi_check_system(acpi_dmi_table);
>> -
>> -	/*
>> -	 * If acpi_disabled, bail out
>> -	 */
>> -	if (acpi_disabled)
>> -		return;
>
> I think this check is still necessary.
>

Yes. Will add it.

Thanks.
