Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaHTLEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:04:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbaHTLEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:04:51 -0400
Date: Wed, 20 Aug 2014 13:05:15 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Razya Ladelsky <RAZYA@il.ibm.com>
Cc: abel.gordon@gmail.com, Alex Glikson <GLIKSON@il.ibm.com>,
        David Miller <davem@davemloft.net>,
        Eran Raichstein <ERANRA@il.ibm.com>, Joel Nider <JOELN@il.ibm.com>,
        kvm@vger.kernel.org, kvm-owner@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Yossi Kuperman1 <YOSSIKU@il.ibm.com>
Subject: Re: [PATCH] vhost: Add polling mode
Message-ID: <20140820110515.GD17371@redhat.com>
References: <1407659404-razya@il.ibm.com>
 <20140810083035.0CF58380729@moren.haifa.ibm.com>
 <20140810194559.GA4344@redhat.com>
 <20140811.124621.576073630604147753.davem@davemloft.net>
 <20140812091850.GD6440@redhat.com>
 <OF93E480CE.EFA0854D-ONC2257D32.003BE092-C2257D32.003C1F49@il.ibm.com>
 <20140813121550.GA21026@redhat.com>
 <OFFB3DD9F0.3A92A6A0-ONC2257D37.0043D722-C2257D37.004522A0@il.ibm.com>
 <20140817125809.GA22213@redhat.com>
 <OFB79DEF3C.1ADC0F14-ONC2257D39.002F0F0A-C2257D39.002F3CBC@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFB79DEF3C.1ADC0F14-ONC2257D39.002F0F0A-C2257D39.002F3CBC@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 11:36:31AM +0300, Razya Ladelsky wrote:
> > That was just one example. There many other possibilities.  Either
> > actually make the systems load all host CPUs equally, or divide
> > throughput by host CPU.
> > 
> 
> The polling patch adds this capability to vhost, reducing costly exit 
> overhead when the vm is loaded.
> 
> In order to load the vm I ran netperf  with msg size of 256:
> 
> Without polling:  2480 Mbits/sec,  utilization: vm - 100%   vhost - 64% 
> With Polling: 4160 Mbits/sec,  utilization: vm - 100%   vhost - 100% 
> 
> Therefore, throughput/cpu without polling is 15.1, and 20.8 with polling.
> 

Can you please present results in a form that makes
it possible to see the effect on various configurations
and workloads?

Here's one example where this was done:
https://lkml.org/lkml/2014/8/14/495

You really should also provide data about your host
configuration (missing in the above link).

> My intention was to load vhost as close as possible to 100% utilization 
> without polling, in order to compare it to the polling utilization case 
> (where vhost is always 100%). 
> The best use case, of course, would be when the shared vhost thread work 
> (TBD) is integrated and then vhost will actually be using its polling 
> cycles to handle requests of multiple devices (even from multiple vms).
> 
> Thanks,
> Razya


-- 
MST
