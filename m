Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab3AKMHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 07:07:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:42846 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab3AKMHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 07:07:15 -0500
X-IronPort-AV: E=Sophos;i="4.84,452,1355068800"; 
   d="scan'208";a="6568156"
Message-ID: <50F00041.2040305@cn.fujitsu.com>
Date: Fri, 11 Jan 2013 20:06:25 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wu Jianguo <wujianguo@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmots: memory-hotplug: implement register_page_bootmem_info_section
 of sparse-vmemmap fix
References: <20130111095658.GC7286@dhcp22.suse.cz> <20130111101745.GD7286@dhcp22.suse.cz> <20130111102924.GE7286@dhcp22.suse.cz> <20130111104759.GF7286@dhcp22.suse.cz>
In-Reply-To: <20130111104759.GF7286@dhcp22.suse.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/11 20:06:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/11 20:06:37,
	Serialize complete at 2013/01/11 20:06:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 06:47 PM, Michal Hocko wrote:
>>
>> Darn! And now that I am looking at the patch closer it is too x86
>> centric so this cannot be in the generic code. I will try to cook
>> something better. Sorry about the noise.
>
> It is more complicated than I thought. One would tell it's a mess.
> The patch bellow fixes the compilation issue but I am not sure we want
> to include memory_hotplug.h into arch/x86/mm/init_64.c. Moreover
>
> +void register_page_bootmem_memmap(unsigned long section_nr,
> +				  struct page *start_page, unsigned long size)
> +{
> +	/* TODO */
> +}
>
> for other archs would suggest that the code is not ready yet. Should
> this rather be dropped for now?

Hi Michal,

Do you mean remove register_page_bootmem_memmap() from other
architectures ?  Well, I think this function is called by
register_page_bootmem_info_section(), which is a common function
in mm/memory_hotplug.c shared by all architectures. So I don't think
we should remove it. :)

Thanks. :)

