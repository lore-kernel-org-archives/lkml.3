Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab3JNUnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:43:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56919 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab3JNUnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:43:19 -0400
Message-ID: <525C5727.7000603@zytor.com>
Date: Mon, 14 Oct 2013 13:42:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>
CC: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH part2 v2 0/8] Arrange hotpluggable memory as ZONE_MOVABLE
References: <525B19C3.9040907@gmail.com>	<20131014133835.GG4722@htj.dyndns.org>	<525BFCF3.5010908@gmail.com>	<20131014142719.GI4722@htj.dyndns.org>	<525C02DC.4050706@gmail.com>	<20131014145131.GJ4722@htj.dyndns.org>	<525C0866.2010808@gmail.com>	<20131014151902.GL4722@htj.dyndns.org>	<525C0EFE.2010409@gmail.com>	<CAE9FiQX0xeR61ehPy2SfWfN-fgSZVS=dtaWT-QQ+RR12tx+A0w@mail.gmail.com>	<20131014200437.GA5720@htj.dyndns.org> <CAE9FiQXCG6gR-XL9fVudpNVEdS-3MHPObfWQ=Uf=q7pv33QBOA@mail.gmail.com>
In-Reply-To: <CAE9FiQXCG6gR-XL9fVudpNVEdS-3MHPObfWQ=Uf=q7pv33QBOA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 01:37 PM, Yinghai Lu wrote:
>>
>> Optimizing NUMA boot just requires moving the heavy lifting to
>> appropriate NUMA nodes.  It doesn't require that early boot phase
>> should strictly follow NUMA node boundaries.
> 
> At end of day, I like to see all numa system (ram/cpu/pci) could have
> non boot nodes to be hot-removed logically. with any boot command
> line.
> 

I don't think that is realistic without hardware support, simply because
all it takes is a single page of kernel locked memory to prevent a page
from being removed.  The only realistic way around that, I believe, is
to remove the identity-mapping in the kernel, but it still has all kinds
of funnies involving devices and DMA.

	-hpa

