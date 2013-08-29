Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3H2By6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 21:54:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20489 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab3H2By4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 21:54:56 -0400
X-IronPort-AV: E=Sophos;i="4.89,979,1367942400"; 
   d="scan'208";a="8338101"
Message-ID: <521EA99B.3010303@cn.fujitsu.com>
Date: Thu, 29 Aug 2013 09:53:31 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Tejun Heo <tj@kernel.org>, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 00/11] x86, memblock: Allocate memory near kernel image
 before SRAT parsed.
References: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com> <20130828151909.GE9295@htj.dyndns.org> <521EA44E.1020205@cn.fujitsu.com> <20130829013657.GA22599@hacker.(null)>
In-Reply-To: <20130829013657.GA22599@hacker.(null)>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/29 09:52:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/29 09:52:54,
	Serialize complete at 2013/08/29 09:52:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wanpeng,

On 08/29/2013 09:36 AM, Wanpeng Li wrote:
......
>> Hi tj,
>>
>> Sorry for the trouble. Please refer to the following branch:
>>
>> https://github.com/imtangchen/linux.git  movablenode-boot-option
>>
>
> Could you post your testcase? So I can test it on x86 and powerpc machines.
>

Sure. Some simple testcases:

1. Boot the kernel without movablenode boot option, check if the memory 
mapping
    is initialized as before, high to low.
2. Boot the kernel with movablenode boot option, check if the memory 
mapping
    is initialized as before, low to high.
3. With movablenode, check if the memory allocation is from high to low 
after
    SRAT is parsed.
4. Check if we can do acpi_initrd_override normally with and without 
movablenode.
    And the memory allocation is from low to high, near the end of 
kernel image.
5. with movablenode, check if crashkernel boot option works normally.
    (This may consume a lot of memory, but should work normally.)
6. With movablenode, check if relocate_initrd() works normally.
    (This may consume a lot of memory, but should work normally.)
7. With movablenode, check if kexec could locate the kernel to higher 
memory.
    (This may consume hotplug memory if higher memory is hotpluggable, 
but should work normally.)


Please do the above tests with and without the following config options:

1. CONFIG_MOVABLE_NODE
2. CONFIG_ACPI_INITRD_OVERRIDE


Thanks for the testing.
