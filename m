Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3C2QRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:17:04 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:27871 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab3C2QRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:17:03 -0400
Date: Fri, 29 Mar 2013 17:17:00 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH v3, part4 38/39] mm/hotplug: prepare for removing
	num_physpages
Message-ID: <20130329161700.GA6201@merkur.ravnborg.org>
References: <1364313298-17336-1-git-send-email-jiang.liu@huawei.com> <1364313298-17336-39-git-send-email-jiang.liu@huawei.com> <20130329111856.GA3824@merkur.ravnborg.org> <5155B517.3040501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5155B517.3040501@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> >> index 97454b3..9b1b494 100644
> >> --- a/mm/memory_hotplug.c
> >> +++ b/mm/memory_hotplug.c
> >> @@ -751,10 +751,6 @@ EXPORT_SYMBOL_GPL(restore_online_page_callback);
> >>  
> >>  void __online_page_set_limits(struct page *page)
> >>  {
> >> -	unsigned long pfn = page_to_pfn(page);
> >> -
> >> -	if (pfn >= num_physpages)
> >> -		num_physpages = pfn + 1;
> >>  }
> >>  EXPORT_SYMBOL_GPL(__online_page_set_limits);
> > 
> > How can this be correct?
> > With this change __online_page_set_limits() is now a nop.
> Hi Sam,
> 	We will eventually remove the global variable num_physpages in the last patch.
> I kept the nop __online_page_set_limits() because I have a plan to use it to fix other
> bugs in memory hotplug, otherwise it may be killed too.

The xen ballon driver uses __online_page_set_limits for memory
hotplug - so this will break this driver afaics.

	Sam
