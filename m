Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab3KLCQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 21:16:46 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:55778 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab3KLCQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 21:16:34 -0500
MIME-Version: 1.0
In-Reply-To: <1384220059.13547.17.camel@edumazet-glaptop2.roam.corp.google.com>
References: <CABawtvN+PEzm_h4Gg5uYtJCjVC5yPjikwwMepkZNZR=cQ+YQmg@mail.gmail.com>
	<1383233136.4857.77.camel@edumazet-glaptop.roam.corp.google.com>
	<CABawtvPSjm7LnE=nn6siJyoR+gf31iNA=ywSLz_0BR6rp_iK=w@mail.gmail.com>
	<1384220059.13547.17.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Tue, 12 Nov 2013 10:16:33 +0800
Message-ID: <CABawtvMpjy_=CS91g=9R3eJtdctRET9E4DZ=G_WrZaLtE89CGw@mail.gmail.com>
Subject: Re: Got iperf regression while intel_iommu is on, how to cut the cost
 of cache flushing
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ashok Raj <ashok.raj@intel.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,
    I do think it is the IO_MMMU reason that brought such performance
down, while TSO/TSQ are not the way to cure such wounded performance.
I might misunderstand the purpose of TSO/TSQ---get rid of the
extra cache flushing pain of mapping and unmapping operation done by
Intel IOMMU. (sorry for last HTML mail, resend txt )

Ethan

On Tue, Nov 12, 2013 at 9:34 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Tue, 2013-11-12 at 09:03 +0800, Ethan Zhao wrote:
>> Eric,
>>     We have tested the performance with the TSO and TSQ patches
>> merged, the result not good, even worse than kernel without those two
>> patches. any idea ?
>>
>> kernel   : 3.11.x with TSO & TSQ merged.  ( CONFIG_INTEL_IOMMU_DEFAULT_ON=y )
>> Network Interface : eth4
>> Network driver    : be2net
>>
>> Average Bandwidth for :
>>    1.tcp-unidirectional test    : 4385 Mbits/sec
>>    2.tcp-unidirectional-parallel: 9383 Mbits/sec
>>    3.tcp-bidirectonal test      : 2755 Mbits/sec
>>
>> vs
>>
>> kernel   :  3.11.x without TSO & TSQ patches.
>> (CONFIG_INTEL_IOMMU_DEFAULT_ON is not set)
>> Network Interface : eth4
>> Network driver    : be2net
>>
>> Average Bandwidth for :
>>    1.tcp-unidirectional test    : 7992 Mbits/sec
>>    2.tcp-unidirectional-parallel: 9403 Mbits/sec
>>    3.tcp-bidirectonal test      : 5802 Mbits/sec
>>
>
> So it seems its not the TSO/TSQ changes, but
> CONFIG_INTEL_IOMMU_DEFAULT_ON being on instead of off.
>
>
>
