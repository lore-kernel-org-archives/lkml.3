Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab3APCM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 21:12:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:47069 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757252Ab3APCMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 21:12:53 -0500
X-IronPort-AV: E=Sophos;i="4.84,476,1355068800"; 
   d="scan'208";a="6594960"
Message-ID: <50F60C77.9000201@cn.fujitsu.com>
Date: Wed, 16 Jan 2013 10:12:07 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: akpm@linux-foundation.org, rientjes@google.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, hpa@zytor.com, linfeng@cn.fujitsu.com,
        laijs@cn.fujitsu.com, mgorman@suse.de, yinghai@kernel.org,
        glommer@parallels.com, jiang.liu@huawei.com, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Subject: Re: [BUG Fix Patch 1/6] Bug fix: Hold spinlock across find|remove
 /sys/firmware/memmap/X operation.
References: <1358247267-18089-1-git-send-email-tangchen@cn.fujitsu.com> <1358247267-18089-2-git-send-email-tangchen@cn.fujitsu.com> <CAGRGNgWCdvWhp=9+PDRbC9bK100BdBv9kpcsqoM-J6ipq22Szw@mail.gmail.com>
In-Reply-To: <CAGRGNgWCdvWhp=9+PDRbC9bK100BdBv9kpcsqoM-J6ipq22Szw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/16 10:12:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/16 10:12:07,
	Serialize complete at 2013/01/16 10:12:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 06:26 AM, Julian Calaby wrote:
> Hi Tang,
>
> One minor point.
>
>>
>>   /*
>> - * Search memmap entry
>> + * firmware_map_find_entry: Search memmap entry.
>> + * @start: Start of the memory range.
>> + * @end:   End of the memory range (exclusive).
>> + * @type:  Type of the memory range.
>> + *
>> + * This function is to find the memmap entey of a given memory range.
>> + * The caller must hold map_entries_lock, and must not release the lock
>> + * until the processing of the returned entry has completed.
>> + *
>> + * Return pointer to the entry to be found on success, or NULL on failure.
>
> Why not make this completely kernel-doc compliant as you're already
> re-writing the comment?

Hi Julian,

Thank you for reminding me this. I think I may have some more problems
like this. I'll post a patch to fix as many of them as I can. :)

Thanks.

