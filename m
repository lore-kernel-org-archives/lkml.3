Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbaHUObH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:31:07 -0400
Received: from mx0.aculab.com ([213.249.233.131]:50283 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755084AbaHUObF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:31:05 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Razya Ladelsky'" <RAZYA@il.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC: "abel.gordon@gmail.com" <abel.gordon@gmail.com>,
        Alex Glikson <GLIKSON@il.ibm.com>, Eran Raichstein <ERANRA@il.ibm.com>,
        Joel Nider <JOELN@il.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Yossi Kuperman1 <YOSSIKU@il.ibm.com>
Subject: RE: [PATCH] vhost: Add polling mode
Thread-Topic: [PATCH] vhost: Add polling mode
Thread-Index: AQHPvUt7OIFKlO3q5EmeNecjrxvHLZvbHSSQ
Date: Thu, 21 Aug 2014 14:29:41 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1747D7F3@AcuExch.aculab.com>
References: <1407659404-razya@il.ibm.com>
 <20140810083035.0CF58380729@moren.haifa.ibm.com>
 <20140820105710.GC17371@redhat.com>
 <OFBE98487F.0F49BDD7-ONC2257D3B.004C908C-C2257D3B.004F09FD@il.ibm.com>
In-Reply-To: <OFBE98487F.0F49BDD7-ONC2257D3B.004C908C-C2257D3B.004F09FD@il.ibm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Razya Ladelsky
> "Michael S. Tsirkin" <mst@redhat.com> wrote on 20/08/2014 01:57:10 PM:
> 
> > > Results:
> > >
> > > Netperf, 1 vm:
> > > The polling patch improved throughput by ~33% (1516 MB/sec -> 2046 MB/sec).
> > > Number of exits/sec decreased 6x.
> > > The same improvement was shown when I tested with 3 vms running netperf
> > > (4086 MB/sec -> 5545 MB/sec).
> > >
> > > filebench, 1 vm:
> > > ops/sec improved by 13% with the polling patch. Number of exits
> > > was reduced by 31%.
> > > The same experiment with 3 vms running filebench showed similar numbers.
> > >
> > > Signed-off-by: Razya Ladelsky <razya@il.ibm.com>
> >
> > This really needs more thourough benchmarking report, including
> > system data.  One good example for a related patch:
> > http://lwn.net/Articles/551179/
> > though for virtualization, we need data about host as well, and if you
> > want to look at streaming benchmarks, you need to test different message
> > sizes and measure packet size.
> >
> 
> Hi Michael,
> I have already tried running netperf with several message sizes:
> 64,128,256,512,600,800...
> But the results are inconsistent even in the baseline/unpatched
> configuration.
> For smaller msg sizes, I get consistent numbers. However, at some point,
> when I increase the msg size
> I get unstable results. For example, for a 512B msg, I get two scenarios:
> vm utilization 100%, vhost utilization 75%, throughput ~6300
> vm utilization 80%, vhost utilization 13%, throughput ~9400 (line rate)
> 
> I don't know why vhost is behaving that way for certain message sizes.
> Do you have any insight to why this is happening?

Have you tried looking at the actual ethernet packet sizes.
It may well jump between using small packets (the size of the writes)
and full sized ones.

If you are trying to measure ethernet packet 'cost' you need to use UDP.
However that probably uses different code paths.

	David



