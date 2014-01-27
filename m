Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaA0H0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 02:26:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61855 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbaA0H0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 02:26:39 -0500
X-IronPort-AV: E=Sophos;i="4.95,727,1384272000"; 
   d="scan'208";a="9457404"
Message-ID: <52E60ABF.9020400@cn.fujitsu.com>
Date: Mon, 27 Jan 2014 15:29:03 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when seting
 kernel nodes to unhotpluggable.
References: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com> <alpine.DEB.2.02.1401222203330.8088@chino.kir.corp.google.com> <20140123061343.GB15206@redhat.com> <alpine.DEB.2.02.1401222214290.8088@chino.kir.corp.google.com> <20140123065824.GA17684@redhat.com> <20140123223136.GA18468@redhat.com>
In-Reply-To: <20140123223136.GA18468@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/27 15:24:58,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/27 15:25:00,
	Serialize complete at 2014/01/27 15:25:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On 01/24/2014 06:31 AM, Dave Jones wrote:
> On Thu, Jan 23, 2014 at 01:58:24AM -0500, Dave Jones wrote:
>
>   >  128 bytes is a pretty small amount of stack though, so I'm just as confused
>   >  as to what the actual bug here is.
>   >
>   >  After trying the proposed fix, I got another oops in the early init code..
>   >
>   >  <trace>
>   >  nr_free_zone_pages
>   >  nr_free_pagecache_pages
>   >  build_all_zonelists
>   >  start_kernel
>   >  <rip>  ffffffffbc164b1e next_zones_zonelist
>   >  <rsp>  ffffffffbcc01f00
>
> Ok, this is crashing here in next_zones_zonelist...
>
>                  while (zonelist_zone_idx(z)>  highest_zoneidx)
>    de:   3b 77 08                cmp    0x8(%rdi),%esi
>
>
> I stuck this at the top of the function..
>
> printk(KERN_ERR "z:%p nodes:%p highest:%d\n", z, nodes, highest_zoneidx);
>
> and got
>
> z: 1d08   nodes: (null)  highest:3
>
>
> Some build tests show..
>
> MAXSMP ( NODESHIFT=10 ) : Bug
> NRCPUS=4&  NODESHIFT=10 : Bug
> NRCPUS=4&  NODESHIFT=1 : no bug
>
>
> The middle config test was accidental, I hadn't realised disabling MAXSMP
> wouldn't reset NODESHIFT to something sane.
>
> I'll start bisecting, as MAXSMP worked fine until a few days ago.

Hi Dave,

I didn't reproduce this bug. Would you please share the bisect result ?

Thanks.

>
> 	Dave
>
>
