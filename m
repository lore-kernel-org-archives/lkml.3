Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaB1WPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:15:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbaB1WPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:15:04 -0500
Message-ID: <53110A62.7070109@redhat.com>
Date: Fri, 28 Feb 2014 17:14:58 -0500
From: Vlad Yasevich <vyasevic@redhat.com>
Reply-To: vyasevic@redhat.com
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: "David S. Miller" <davem@davemloft.net>, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: macvtap performance regression (bisected) between 3.13 and 3.14-rc1
References: <530FA586.3010400@de.ibm.com>
In-Reply-To: <530FA586.3010400@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 03:52 PM, Christian Borntraeger wrote:
> Vlad,
> 
> commit 6acf54f1cf0a6747bac9fea26f34cfc5a9029523
>     macvtap: Add support of packet capture on macvtap device.
> 
> causes a performance regression for iperf traffic between two KVM guests
> on my s390 system. Both guests are connected via two macvtaps on the same OSA
> network card.
> Before that patch I get ~20 Gbit/sec between two guests, afterwards I get
> ~4Gbit/sec
> 
> Latency seems to be unchanges (uperf 1byte ping pong).
> 
> According to ifconfig in the guest, I have ~ 1500 bytes per packet with this
> patch and ~  40000 bytes without. So for some reason this patch causes the
> network stack to do segmentation. (the guest kernel stays the same, only host 
> kernel is changed).
> 
> Any ideas?

I am looking.  It shouldn't cause addition segmentations and when I ran
netperf on the code I didn't see any difference in the throughput.

-vlad

> 
> 
> Christian
> 

