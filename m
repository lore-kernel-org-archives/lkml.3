Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423323Ab3FUPbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:31:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:24318 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423241Ab3FUPbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:31:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,913,1363158000"; 
   d="scan'208";a="258305730"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        infinipath <infinipath@intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: linux-next: Tree for Jun 21 (infiniband: qib)
Thread-Topic: linux-next: Tree for Jun 21 (infiniband: qib)
Thread-Index: AQHObpREkYyIoqGc0EO3DUflOKl5UZlAS3pg
Date: Fri, 21 Jun 2013 15:31:17 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211592E2@FMSMSX107.amr.corp.intel.com>
References: <20130621181721.11783d80583444868725b62c@canb.auug.org.au>
 <51C4717D.4090002@infradead.org>
In-Reply-To: <51C4717D.4090002@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just submitted  a fix for this.

> -----Original Message-----
> From: Randy Dunlap [mailto:rdunlap@infradead.org]
> Sent: Friday, June 21, 2013 11:30 AM
> To: Stephen Rothwell
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; infinipath; linux-
> rdma@vger.kernel.org
> Subject: Re: linux-next: Tree for Jun 21 (infiniband: qib)
> 
> On 06/21/13 01:17, Stephen Rothwell wrote:
> > Hi all,
> >
> > Happy solstice!
> >
> > Changes since 20130620:
> >
> 
> 
> on x86_64:
> 
> when CONFIG_SMP is not enabled:
> 
> (from qib.h:)
> 
> #ifdef CONFIG_INFINIBAND_QIB_DCA
> struct qib_irq_notify {
> 	int rcv;
> 	void *arg;
> 	struct irq_affinity_notify notify;
> };
> #endif
> 
> struct irq_affinity_notify is only defined for CONFIG_SMP or
> GENERIC_HARDIRQS.
> Build error happens when one of those is not enabled.
> 
> 
> In file included from drivers/infiniband/hw/qib/qib_cq.c:41:0:
> drivers/infiniband/hw/qib/qib.h:447:29: error: field 'notify' has incomplete type
> make[4]: *** [drivers/infiniband/hw/qib/qib_cq.o] Error 1
> 
> 
> 
> 
> --
> ~Randy
