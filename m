Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3JOBlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 21:41:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19154 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756534Ab3JOBle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 21:41:34 -0400
X-IronPort-AV: E=Sophos;i="4.93,495,1378828800"; 
   d="scan'208";a="8756233"
Message-ID: <525C9CFA.7070601@cn.fujitsu.com>
Date: Tue, 15 Oct 2013 09:40:10 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Yinghai Lu <yinghai@kernel.org>, Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH part2 v2 0/8] Arrange hotpluggable memory as ZONE_MOVABLE
References: <525BFCF3.5010908@gmail.com> <20131014142719.GI4722@htj.dyndns.org> <525C02DC.4050706@gmail.com> <20131014145131.GJ4722@htj.dyndns.org> <525C0866.2010808@gmail.com> <20131014151902.GL4722@htj.dyndns.org> <525C0EFE.2010409@gmail.com> <CAE9FiQX0xeR61ehPy2SfWfN-fgSZVS=dtaWT-QQ+RR12tx+A0w@mail.gmail.com> <20131014200437.GA5720@htj.dyndns.org> <CAE9FiQXCG6gR-XL9fVudpNVEdS-3MHPObfWQ=Uf=q7pv33QBOA@mail.gmail.com> <20131014205540.GM4722@htj.dyndns.org>
In-Reply-To: <20131014205540.GM4722@htj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/15 09:39:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/15 09:39:16,
	Serialize complete at 2013/10/15 09:39:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello tejun, peter and yinghai

On 10/15/2013 04:55 AM, Tejun Heo wrote:
> Hello,
> 
> On Mon, Oct 14, 2013 at 01:37:20PM -0700, Yinghai Lu wrote:
>> The problem is how to define "amount necessary". If we can parse srat early,
>> then we could just map RAM for all boot nodes one time, instead of try some
>> small and then after SRAT table, expand it cover non-boot nodes.
> 
> Wouldn't that amount be fairly static and restricted?  If you wanna
> chunk memory init anyway, there's no reason to init more than
> necessary until smp stage is reached.  The more you do early, the more
> serialized you're, so wouldn't the goal naturally be initing the
> minimum possible?
> 
>> To keep non-boot numa node hot-removable. we need to page table (and other
>> that we allocate during boot stage) on ram of non boot nodes, or their
>> local node ram.  (share page table always should be on boot nodes).
> 
> The above assumes the followings,
> 
> * 4k page mappings.  It'd be nice to keep everything working for 4k
>   but just following SRAT isn't enough.  What if the non-hotpluggable
>   boot node doesn't stretch high enough and page table reaches down
>   too far?  This won't be an optional behavior, so it is actually
>   *likely* to happen on certain setups.
> 
> * Memory hotplug is at NUMA node granularity instead of device.
> 
>>> Optimizing NUMA boot just requires moving the heavy lifting to
>>> appropriate NUMA nodes.  It doesn't require that early boot phase
>>> should strictly follow NUMA node boundaries.
>>
>> At end of day, I like to see all numa system (ram/cpu/pci) could have
>> non boot nodes to be hot-removed logically. with any boot command
>> line.
> 
> I suppose you mean "without any boot command line"?  Sure, but, first
> of all, there is a clear performance trade-off, and, secondly, don't
> we want something finer grained?  Why would we want to that per-NUMA
> node, which is extremely coarse?
> 

Both ways seem ok enough *currently*. But what tejun always emphasizes
is the trade-off, or benefit / cost ratio. 

Yinghai and peter insist on the long-term plan. But it seems currently
no actual requirements and plans that *must* parse SRAT earlier comparing
to the current approach in this patchset, right?

Should we follow "Make it work first and optimize/beautify it later"?
I think if we have the scene that must parse SRAT earlier, I think tejun
will have no objection to it.

-- 
Thanks.
Zhang Yanfei
