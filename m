Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab3AKPi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 10:38:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab3AKPi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 10:38:26 -0500
Date: Fri, 11 Jan 2013 16:38:23 +0100
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
Message-ID: <20130111153823.GK7286@dhcp22.suse.cz>
References: <20130111095658.GC7286@dhcp22.suse.cz>
 <20130111101745.GD7286@dhcp22.suse.cz>
 <20130111102924.GE7286@dhcp22.suse.cz>
 <20130111104759.GF7286@dhcp22.suse.cz>
 <50F00041.2040305@cn.fujitsu.com>
 <20130111121226.GI7286@dhcp22.suse.cz>
 <50F007C9.10606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F007C9.10606@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 11-01-13 20:38:33, Tang Chen wrote:
> On 01/11/2013 08:12 PM, Michal Hocko wrote:
> >On Fri 11-01-13 20:06:25, Tang Chen wrote:
> >>On 01/11/2013 06:47 PM, Michal Hocko wrote:
> >>>>
> >>>>Darn! And now that I am looking at the patch closer it is too x86
> >>>>centric so this cannot be in the generic code. I will try to cook
> >>>>something better. Sorry about the noise.
> >>>
> >>>It is more complicated than I thought. One would tell it's a mess.
> >>>The patch bellow fixes the compilation issue but I am not sure we want
> >>>to include memory_hotplug.h into arch/x86/mm/init_64.c. Moreover
> >>>
> >>>+void register_page_bootmem_memmap(unsigned long section_nr,
> >>>+				  struct page *start_page, unsigned long size)
> >>>+{
> >>>+	/* TODO */
> >>>+}
> >>>
> >>>for other archs would suggest that the code is not ready yet. Should
> >>>this rather be dropped for now?
> >>
> >>Hi Michal,
> >>
> >>Do you mean remove register_page_bootmem_memmap() from other
> >>architectures ?
> >
> >No I meant the patch to be dropped until it gets implementation for
> >other architectures or the users of the function would be explicit about
> >archs which are supported. What happens if the implementation is empty
> >will the generic code work properly? From my very limitted understanding
> >of the code it won't.
> 
> Hi Michal,
> 
> Hum, I see. Thank you for your remind. :)
> register_page_bootmem_info_section() will be different in other
> architectures if register_page_bootmem_memmap() is empty.

Not sure I understand what "different" means here but I suspect it would
be buggy. Is that correct?

> I think we can post a patch to make register_page_bootmem_info_section()
> the same as before, and we just implement the x86 version first. So that
> it will have no harm to other architectures.

I haven't followed the previous versions of the patch - I have noticed
this being broken only because it failed during my automatic build
testing when merging new mmots tree into mm git tree. I have no
objections for further patches of course but this one seems to be buggy
so it should be dropped until a fixed version is available.

> How do you think ?
> 
> Thanks. :)
> 
> >
> 

-- 
Michal Hocko
SUSE Labs
