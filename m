Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3AQLLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 06:11:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:28713 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab3AQLLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 06:11:01 -0500
X-IronPort-AV: E=Sophos;i="4.84,485,1355068800"; 
   d="scan'208";a="6607014"
Message-ID: <50F7D456.9000904@cn.fujitsu.com>
Date: Thu, 17 Jan 2013 18:37:10 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: akpm@linux-foundation.org, linux-mm@kvack.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, jbeulich@suse.com,
        dhowells@redhat.com, wency@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, paul.gortmaker@windriver.com,
        laijs@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie,
        minchan@kernel.org, aquini@redhat.com, jiang.liu@huawei.com,
        tony.luck@intel.com, fenghua.yu@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        davem@davemloft.net, michael@ellerman.id.au,
        gerald.schaefer@de.ibm.com, gregkh@linuxfoundation.org, x86@kernel.org,
        linux390@de.ibm.com, linux-ia64@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        tangchen@cn.fujitsu.com
Subject: Re: [PATCH v3 1/2] memory-hotplug: introduce CONFIG_HAVE_BOOTMEM_INFO_NODE
 and revert register_page_bootmem_info_node() when platform not support
References: <1358324059-9608-1-git-send-email-linfeng@cn.fujitsu.com> <1358324059-9608-2-git-send-email-linfeng@cn.fujitsu.com> <20130116141436.GE343@dhcp22.suse.cz>
In-Reply-To: <20130116141436.GE343@dhcp22.suse.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/17 18:37:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/17 18:38:05,
	Serialize complete at 2013/01/17 18:38:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On 01/16/2013 10:14 PM, Michal Hocko wrote:
> On Wed 16-01-13 16:14:18, Lin Feng wrote:
> [...]
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index 278e3ab..f8c5799 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -162,10 +162,18 @@ config MOVABLE_NODE
>>  	  Say Y here if you want to hotplug a whole node.
>>  	  Say N here if you want kernel to use memory on all nodes evenly.
>>  
>> +#
>> +# Only be set on architectures that have completely implemented memory hotplug
>> +# feature. If you are not sure, don't touch it.
>> +#
>> +config HAVE_BOOTMEM_INFO_NODE
>> +	def_bool n
>> +
>>  # eventually, we can have this option just 'select SPARSEMEM'
>>  config MEMORY_HOTPLUG
>>  	bool "Allow for memory hot-add"
>>  	select MEMORY_ISOLATION
>> +	select HAVE_BOOTMEM_INFO_NODE if X86_64
>>  	depends on SPARSEMEM || X86_64_ACPI_NUMA
>>  	depends on HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG
>>  	depends on (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)
> 
> I am still not sure I understand the relation to MEMORY_HOTREMOVE.
> Is register_page_bootmem_info_node required/helpful even if
> !CONFIG_MEMORY_HOTREMOVE?
>From old kenrel's view register_page_bootmem_info_node() is defined in 
CONFIG_MEMORY_HOTPLUG_SPARSE, it registers some info for 
memory hotplug/remove. If we don't use MEMORY_HOTPLUG feature, this
function is empty, we don't need the info at all.
So this info is not required/helpful if !CONFIG_MEMORY_HOTREMOVE.
> 
> Also, now that I am thinking about that more, maybe it would
> be cleaner to put the select into arch/x86/Kconfig and do it
> same as ARCH_ENABLE_MEMORY_{HOTPLUG,HOTREMOVE} (and name it
> ARCH_HAVE_BOOTMEM_INFO_NODE).
> 
Maybe put it in mm/Kconfig is a better choice, because if one day someone implements
the register_page_bootmem_info_node() for other archs they will get some clues
here, that's it has been implemented on x86_64. 
But I'm not so sure...

thanks,
linfeng
