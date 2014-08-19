Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaHSIgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:36:41 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:44798 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaHSIgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:36:38 -0400
In-Reply-To: <20140817125809.GA22213@redhat.com>
References: <1407659404-razya@il.ibm.com> <20140810083035.0CF58380729@moren.haifa.ibm.com> <20140810194559.GA4344@redhat.com> <20140811.124621.576073630604147753.davem@davemloft.net> <20140812091850.GD6440@redhat.com> <OF93E480CE.EFA0854D-ONC2257D32.003BE092-C2257D32.003C1F49@il.ibm.com> <20140813121550.GA21026@redhat.com> <OFFB3DD9F0.3A92A6A0-ONC2257D37.0043D722-C2257D37.004522A0@il.ibm.com> <20140817125809.GA22213@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: abel.gordon@gmail.com, Alex Glikson <GLIKSON@il.ibm.com>,
        David Miller <davem@davemloft.net>,
        Eran Raichstein <ERANRA@il.ibm.com>, Joel Nider <JOELN@il.ibm.com>,
        kvm@vger.kernel.org, kvm-owner@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Yossi Kuperman1 <YOSSIKU@il.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] vhost: Add polling mode
X-KeepSent: B79DEF3C:1ADC0F14-C2257D39:002F0F0A;
 type=4; name=$KeepSent
X-Mailer: IBM Notes Release 9.0.1SHF211 December 19, 2013
From: Razya Ladelsky <RAZYA@il.ibm.com>
Message-ID: <OFB79DEF3C.1ADC0F14-ONC2257D39.002F0F0A-C2257D39.002F3CBC@il.ibm.com>
Date: Tue, 19 Aug 2014 11:36:31 +0300
X-MIMETrack: Serialize by Router on D06ML319/06/M/IBM(Release 8.5.3FP5IF1HF3|November 07, 2013) at
 19/08/2014 11:36:31,
	Serialize complete at 19/08/2014 11:36:31
Content-Type: text/plain; charset="US-ASCII"
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081908-0542-0000-0000-00000056D856
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That was just one example. There many other possibilities.  Either
> actually make the systems load all host CPUs equally, or divide
> throughput by host CPU.
> 

The polling patch adds this capability to vhost, reducing costly exit 
overhead when the vm is loaded.

In order to load the vm I ran netperf  with msg size of 256:

Without polling:  2480 Mbits/sec,  utilization: vm - 100%   vhost - 64% 
With Polling: 4160 Mbits/sec,  utilization: vm - 100%   vhost - 100% 

Therefore, throughput/cpu without polling is 15.1, and 20.8 with polling.

My intention was to load vhost as close as possible to 100% utilization 
without polling, in order to compare it to the polling utilization case 
(where vhost is always 100%). 
The best use case, of course, would be when the shared vhost thread work 
(TBD) is integrated and then vhost will actually be using its polling 
cycles to handle requests of multiple devices (even from multiple vms).

Thanks,
Razya


