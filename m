Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3KGBTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 20:19:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:39597 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab3KGBS6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 20:18:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="431030351"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "tj@kernel.org" <tj@kernel.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] devres: Freeing the drs after all release() are called
Thread-Topic: [PATCH] devres: Freeing the drs after all release() are called
Thread-Index: AQHO21ORvMZZzU5LpkKUzVYVx2HtLpoY9ygg
Date: Thu, 7 Nov 2013 01:18:54 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01B867B8@SHSMSX101.ccr.corp.intel.com>
References: <1383720018.3650.37.camel@cliu38-desktop-build>
 <20131106085859.GB9487@kroah.com>
 <27240C0AC20F114CBF8149A2696CBE4A01B86696@SHSMSX101.ccr.corp.intel.com>
 <20131107002959.GA32200@mtj.dyndns.org>
 <27240C0AC20F114CBF8149A2696CBE4A01B866C7@SHSMSX101.ccr.corp.intel.com>
 <20131107005151.GB32200@mtj.dyndns.org>
In-Reply-To: <20131107005151.GB32200@mtj.dyndns.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> -----Original Message-----
> From: Tejun Heo [mailto:htejun@gmail.com] On Behalf Of tj@kernel.org
> Sent: Thursday, November 07, 2013 8:52 AM
> To: Liu, Chuansheng
> Cc: Greg KH; dmitry.torokhov@gmail.com; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] devres: Freeing the drs after all release() are called
> 
> Hello,
> 
> On Thu, Nov 07, 2013 at 12:36:56AM +0000, Liu, Chuansheng wrote:
> > Yes, I knew I can put the code always like below:
> > A = devm_kzalloc();
> > C = devm_kzalloc();
> > ...
> > B= devm_request_threaded_irq(isr_handler);
> >
> > But, the above is just one simple coding prototype, if there are many calling:
> > E -- > F -- > D -- >... then to devm_kzalloc().
> >
> > To be honest, it will make code too hard to always adapt the rule?
> > And I trying to find out every potential devm_kzalloc() before irq requesting.
> 
> It isn't a good idea to paper over existing bugs from upper layer.
> You realize that the above code sequence is already buggy during init
> unless there's something explicitly blocking generation of irqs until
> init is complete, right?  The right thing to do would be either
> reordering the operations or wrapping the operation which unblocks irq
> at the end of init with devres so that irq gets blocked before the
> rest of release proceeds.
> 
> What we must *NOT* do is working around existing bugs in a half-assed
> way from midlayer.  

Yes, doing the right order initialization is always right thing.
But normally when we hit the panic during shutdown/reboot like below:
PAGE FAULT XXX 0x12345678

It is really difficult to debug.
So at least, could we have method to expose these hidden issues?

Thanks.

I am reviewing other codes' usage of devm_request_threaded_irq() also.

