Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab3JaPZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:25:42 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37561 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab3JaPZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:25:40 -0400
Message-ID: <1383233136.4857.77.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: Got iperf regression while intel_iommu is on, how to cut the
 cost of cache flushing
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: Ashok Raj <ashok.raj@intel.com>, Shaohua Li <shaohua.li@intel.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 31 Oct 2013 08:25:36 -0700
In-Reply-To: <CABawtvN+PEzm_h4Gg5uYtJCjVC5yPjikwwMepkZNZR=cQ+YQmg@mail.gmail.com>
References: <CABawtvN+PEzm_h4Gg5uYtJCjVC5yPjikwwMepkZNZR=cQ+YQmg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-31 at 10:44 +0800, Ethan Zhao wrote:
> Hi guys,
> 
>      We got network I/O performance degradation with latest stable
> kernel and the be2net driver as compared to old kernel 3.0.6.   later
> we found even compared to
> the same latest stable kernel but the INTEL_IOMMU set to 'n',  still
> got very noticeable performance regression:
> 
> Kernel   : 3.11.x with  CONFIG_INTEL_IOMMU_DEFAULT_ON not set
> Network driver    : be2net
> 
> Average Bandwidth for :
>    1.tcp-unidirectional test    : 7908 Mbits/sec
>    2.tcp-unidirectional-parallel: 9400 Mbits/sec
>    3.tcp-bidirectonal test      : 5464 Mbits/sec
> 
> Kernel   : 3.11.x with CONFIG_INTEL_IOMMU_DEFAULT_ON set
> Network driver    : be2net

You might hit a known problem for some 10Gb links.

3.12-rc6 has the fixes already, and stable has some pending backports :

commit 95bd09eb27507691520d39ee1044d6ad831c1168
tcp: TSO packets automatic sizing

commit c9eeec26e32e087359160406f96e0949b3cc6f10
tcp: TSQ can use a dynamic limit

Please check that current 3.12-rc6 is OK ?



