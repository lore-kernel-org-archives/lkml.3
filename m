Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbaDHI14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:27:56 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:39484 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbaDHI1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:27:51 -0400
Message-ID: <1396945659.3162.6.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH] memory driver: make phys_index/end_phys_index
 reflect the start/end section number
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, nfont@linux.vnet.ibm.com,
        gregkh@linuxfoundation.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Date: Tue, 08 Apr 2014 16:27:39 +0800
In-Reply-To: <533E0B0E.9020909@jp.fujitsu.com>
References: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com>
	 <533E0B0E.9020909@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040808-3864-0000-0000-00000D723091
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-04 at 10:29 +0900, Yasuaki Ishimatsu wrote:
> (2014/04/02 17:56), Li Zhong wrote:
> > I noticed the phys_index and end_phys_index under
> > /sys/devices/system/memory/memoryXXX/ have the same value, e.g.
> > (for the test machine, one memory block has 8 sections, that is
> >   sections_per_block equals 8)
> >
> > # cd /sys/devices/system/memory/memory100/
> > # cat phys_index end_phys_index
> > 00000064
> > 00000064
> >
> > Seems they should reflect the start/end section number respectively, which
> > also matches what is said in Documentation/memory-hotplug.txt
> >
> > This patch tries to modify that so the two files could show the start/end
> > section number of the memory block.
> >
> > After this change, output of the above example looks like:
> >
> > # cat phys_index end_phys_index
> > 00000320
> > 00000327
> >
> > Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> > ---
> 
> Good catch! This is a bug. So I think the bug should be fixed.
> 
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thank you all for the review. 

If Dave and others don't have further objections, it seems this small
userspace incompatibility could be accepted by most of us, and I don't
need to make a version 2. 

Thanks, Zhong 

> Thanks,
> Yasuaki Ishimatsu
> 
> >   drivers/base/memory.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> > index bece691..b10f2fa 100644
> > --- a/drivers/base/memory.c
> > +++ b/drivers/base/memory.c
> > @@ -114,7 +114,7 @@ static ssize_t show_mem_start_phys_index(struct device *dev,
> >   	struct memory_block *mem = to_memory_block(dev);
> >   	unsigned long phys_index;
> >
> > -	phys_index = mem->start_section_nr / sections_per_block;
> > +	phys_index = mem->start_section_nr;
> >   	return sprintf(buf, "%08lx\n", phys_index);
> >   }
> >
> > @@ -124,7 +124,7 @@ static ssize_t show_mem_end_phys_index(struct device *dev,
> >   	struct memory_block *mem = to_memory_block(dev);
> >   	unsigned long phys_index;
> >
> > -	phys_index = mem->end_section_nr / sections_per_block;
> > +	phys_index = mem->end_section_nr;
> >   	return sprintf(buf, "%08lx\n", phys_index);
> >   }
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


