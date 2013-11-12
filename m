Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab3KLBec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 20:34:32 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:42158 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab3KLBeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 20:34:21 -0500
Message-ID: <1384220059.13547.17.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: Got iperf regression while intel_iommu is on, how to cut the
 cost of cache flushing
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: Ashok Raj <ashok.raj@intel.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 11 Nov 2013 17:34:19 -0800
In-Reply-To: <CABawtvPSjm7LnE=nn6siJyoR+gf31iNA=ywSLz_0BR6rp_iK=w@mail.gmail.com>
References: <CABawtvN+PEzm_h4Gg5uYtJCjVC5yPjikwwMepkZNZR=cQ+YQmg@mail.gmail.com>
	 <1383233136.4857.77.camel@edumazet-glaptop.roam.corp.google.com>
	 <CABawtvPSjm7LnE=nn6siJyoR+gf31iNA=ywSLz_0BR6rp_iK=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-12 at 09:03 +0800, Ethan Zhao wrote:
> Eric,
>     We have tested the performance with the TSO and TSQ patches
> merged, the result not good, even worse than kernel without those two
> patches. any idea ?
> 
> kernel   : 3.11.x with TSO & TSQ merged.  ( CONFIG_INTEL_IOMMU_DEFAULT_ON=y )
> Network Interface : eth4
> Network driver    : be2net
> 
> Average Bandwidth for :
>    1.tcp-unidirectional test    : 4385 Mbits/sec
>    2.tcp-unidirectional-parallel: 9383 Mbits/sec
>    3.tcp-bidirectonal test      : 2755 Mbits/sec
> 
> vs
> 
> kernel   :  3.11.x without TSO & TSQ patches.
> (CONFIG_INTEL_IOMMU_DEFAULT_ON is not set)
> Network Interface : eth4
> Network driver    : be2net
> 
> Average Bandwidth for :
>    1.tcp-unidirectional test    : 7992 Mbits/sec
>    2.tcp-unidirectional-parallel: 9403 Mbits/sec
>    3.tcp-bidirectonal test      : 5802 Mbits/sec
> 

So it seems its not the TSO/TSQ changes, but
CONFIG_INTEL_IOMMU_DEFAULT_ON being on instead of off.



