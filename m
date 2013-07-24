Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3GXDKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:10:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:28266 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab3GXDKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:10:07 -0400
X-IronPort-AV: E=Sophos;i="4.89,732,1367942400"; 
   d="scan'208";a="8000079"
Message-ID: <51EF462D.1020709@cn.fujitsu.com>
Date: Wed, 24 Jul 2013 11:12:45 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
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
Subject: Re: [PATCH 09/21] x86: Make get_ramdisk_{image|size}() global.
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com> <1374220774-29974-10-git-send-email-tangchen@cn.fujitsu.com> <20130723195604.GN21100@mtj.dyndns.org>
In-Reply-To: <20130723195604.GN21100@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 11:07:58,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 11:08:03,
	Serialize complete at 2013/07/24 11:08:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 03:56 AM, Tejun Heo wrote:
> On Fri, Jul 19, 2013 at 03:59:22PM +0800, Tang Chen wrote:
>> In the following patches, we need to call get_ramdisk_{image|size}()
>> to get initrd file's address and size. So make these two functions
>> global.
>>
>> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
>> ---
>>   arch/x86/include/asm/setup.h |    3 +++
>>   arch/x86/kernel/setup.c      |    4 ++--
>>   2 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
>> index b7bf350..69de7a1 100644
>> --- a/arch/x86/include/asm/setup.h
>> +++ b/arch/x86/include/asm/setup.h
>> @@ -106,6 +106,9 @@ void *extend_brk(size_t size, size_t align);
>>   	RESERVE_BRK(name, sizeof(type) * entries)
>>
>>   extern void probe_roms(void);
>> +u64 get_ramdisk_image(void);
>> +u64 get_ramdisk_size(void);
>
> Might as well make these accessors inline functions.\

Sure, will make them as static inline functions in 
arch/x86/include/asm/setup.h.

Thanks.
