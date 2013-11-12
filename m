Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab3KLBDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 20:03:24 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:63076 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab3KLBDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 20:03:15 -0500
MIME-Version: 1.0
In-Reply-To: <1383233136.4857.77.camel@edumazet-glaptop.roam.corp.google.com>
References: <CABawtvN+PEzm_h4Gg5uYtJCjVC5yPjikwwMepkZNZR=cQ+YQmg@mail.gmail.com>
	<1383233136.4857.77.camel@edumazet-glaptop.roam.corp.google.com>
Date: Tue, 12 Nov 2013 09:03:14 +0800
Message-ID: <CABawtvPSjm7LnE=nn6siJyoR+gf31iNA=ywSLz_0BR6rp_iK=w@mail.gmail.com>
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
    We have tested the performance with the TSO and TSQ patches
merged, the result not good, even worse than kernel without those two
patches. any idea ?

kernel   : 3.11.x with TSO & TSQ merged.  ( CONFIG_INTEL_IOMMU_DEFAULT_ON=y )
Network Interface : eth4
Network driver    : be2net

Average Bandwidth for :
   1.tcp-unidirectional test    : 4385 Mbits/sec
   2.tcp-unidirectional-parallel: 9383 Mbits/sec
   3.tcp-bidirectonal test      : 2755 Mbits/sec

vs

kernel   :  3.11.x without TSO & TSQ patches.
(CONFIG_INTEL_IOMMU_DEFAULT_ON is not set)
Network Interface : eth4
Network driver    : be2net

Average Bandwidth for :
   1.tcp-unidirectional test    : 7992 Mbits/sec
   2.tcp-unidirectional-parallel: 9403 Mbits/sec
   3.tcp-bidirectonal test      : 5802 Mbits/sec

Thanks,
Ethan

On Thu, Oct 31, 2013 at 11:25 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Thu, 2013-10-31 at 10:44 +0800, Ethan Zhao wrote:
>> Hi guys,
>>
>>      We got network I/O performance degradation with latest stable
>> kernel and the be2net driver as compared to old kernel 3.0.6.   later
>> we found even compared to
>> the same latest stable kernel but the INTEL_IOMMU set to 'n',  still
>> got very noticeable performance regression:
>>
>> Kernel   : 3.11.x with  CONFIG_INTEL_IOMMU_DEFAULT_ON not set
>> Network driver    : be2net
>>
>> Average Bandwidth for :
>>    1.tcp-unidirectional test    : 7908 Mbits/sec
>>    2.tcp-unidirectional-parallel: 9400 Mbits/sec
>>    3.tcp-bidirectonal test      : 5464 Mbits/sec
>>
>> Kernel   : 3.11.x with CONFIG_INTEL_IOMMU_DEFAULT_ON set
>> Network driver    : be2net
>
> You might hit a known problem for some 10Gb links.
>
> 3.12-rc6 has the fixes already, and stable has some pending backports :
>
> commit 95bd09eb27507691520d39ee1044d6ad831c1168
> tcp: TSO packets automatic sizing
>
> commit c9eeec26e32e087359160406f96e0949b3cc6f10
> tcp: TSQ can use a dynamic limit
>
> Please check that current 3.12-rc6 is OK ?
>
>
>
