Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaHDWHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 18:07:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46547 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaHDWHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 18:07:43 -0400
Date: Mon, 04 Aug 2014 15:07:42 -0700 (PDT)
Message-Id: <20140804.150742.936539469729151133.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 1/1 V2] Drivers: net-next: hyperv: Increase the size of
 the sendbuf region
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407001322-12010-1-git-send-email-kys@microsoft.com>
References: <1407001322-12010-1-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Aug 2014 15:07:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Sat,  2 Aug 2014 10:42:02 -0700

> Intel did some benchmarking on our network throughput when Linux on Hyper-V
> is as used as a gateway. This fix gave us almost a 1 Gbps additional throughput
> on about 5Gbps base throughput we hadi, prior to increasing the sendbuf size.
> The sendbuf mechanism is a copy based transport that we have which is clearly
> more optimal than the copy-free page flipping mechanism (for small packets).
> In the forwarding scenario, we deal only with MTU sized packets,
> and increasing the size of the senbuf area gave us the additional performance.
> For what it is worth, Windows guests on Hyper-V, I am told use similar sendbuf
> size as well.
> 
> The exact value of sendbuf I think is less important than the fact that it needs
> to be larger than what Linux can allocate as physically contiguous memory.
> Thus the change over to allocating via vmalloc().
> 
> We currently allocate 16MB receive buffer and we use vmalloc there for allocation.
> Also the low level channel code has already been modified to deal with physically
> dis-contiguous memory in the ringbuffer setup.
> 
> Based on experimentation Intel did, they say there was some improvement in throughput
> as the sendbuf size was increased up to 16MB and there was no effect on throughput
> beyond 16MB. Thus I have chosen 16MB here.
> 
> Increasing the sendbuf value makes a material difference in small packet handling
> 
> In this version of the patch, based on David's feedback, I have added
> additional details in the commit log.
> 
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

APplied.
