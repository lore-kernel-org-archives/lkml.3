Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3AKMMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 07:12:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab3AKMM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 07:12:28 -0500
Date: Fri, 11 Jan 2013 13:12:26 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wu Jianguo <wujianguo@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmots: memory-hotplug: implement
 register_page_bootmem_info_section of sparse-vmemmap fix
Message-ID: <20130111121226.GI7286@dhcp22.suse.cz>
References: <20130111095658.GC7286@dhcp22.suse.cz>
 <20130111101745.GD7286@dhcp22.suse.cz>
 <20130111102924.GE7286@dhcp22.suse.cz>
 <20130111104759.GF7286@dhcp22.suse.cz>
 <50F00041.2040305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F00041.2040305@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 11-01-13 20:06:25, Tang Chen wrote:
> On 01/11/2013 06:47 PM, Michal Hocko wrote:
> >>
> >>Darn! And now that I am looking at the patch closer it is too x86
> >>centric so this cannot be in the generic code. I will try to cook
> >>something better. Sorry about the noise.
> >
> >It is more complicated than I thought. One would tell it's a mess.
> >The patch bellow fixes the compilation issue but I am not sure we want
> >to include memory_hotplug.h into arch/x86/mm/init_64.c. Moreover
> >
> >+void register_page_bootmem_memmap(unsigned long section_nr,
> >+				  struct page *start_page, unsigned long size)
> >+{
> >+	/* TODO */
> >+}
> >
> >for other archs would suggest that the code is not ready yet. Should
> >this rather be dropped for now?
> 
> Hi Michal,
> 
> Do you mean remove register_page_bootmem_memmap() from other
> architectures ?

No I meant the patch to be dropped until it gets implementation for
other architectures or the users of the function would be explicit about
archs which are supported. What happens if the implementation is empty
will the generic code work properly? From my very limitted understanding
of the code it won't.

-- 
Michal Hocko
SUSE Labs
