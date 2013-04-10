Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937039Ab3DJQKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:10:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091Ab3DJQK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:10:29 -0400
Date: Wed, 10 Apr 2013 18:05:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>
Cc: Roland Dreier <roland@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
Message-ID: <20130410150539.GA24381@redhat.com>
References: <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com>
 <515F3948.40205@linux.vnet.ibm.com>
 <CAG4TOxPNHZadLjq6-HuOExf1XXLO6AYyvRQ1L09i6qVeA5dbLQ@mail.gmail.com>
 <515F42EE.8060203@linux.vnet.ibm.com>
 <20130409190350.GB8212@redhat.com>
 <5164BFE3.4040204@linux.vnet.ibm.com>
 <20130410032449.GA12777@redhat.com>
 <5164EB5F.80403@linux.vnet.ibm.com>
 <20130410053255.GC12777@redhat.com>
 <516589C8.1040606@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516589C8.1040606@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 11:48:24AM -0400, Michael R. Hines wrote:
> 
> There's a very nice, simple client/server RDMA application on the
> internet you can use to test your patch.
> 
> http://thegeekinthecorner.wordpress.com/2010/09/28/
> rdma-read-and-write-with-ib-verbs/
> 
> This guy provides the source code which dumps several gigabytes over RDMA
> to the other side.
> 
> There's no need to run QEMU to test your patch,
> assuming you have access to infiniband hardware.
> 
> - Michael


Does this app have any COW pages?

> On 04/10/2013 01:32 AM, Michael S. Tsirkin wrote:
> 
>     On Wed, Apr 10, 2013 at 12:32:31AM -0400, Michael R. Hines wrote:
> 
>         On 04/09/2013 11:24 PM, Michael S. Tsirkin wrote:
> 
>             Which mechanism do you refer to? You patches still seem to pin
>             each page in guest memory at some point, which will break all COW.
>             In particular any pagemap tricks to detect duplicates on source
>             that I suggested won't work.
> 
>         Sorry, I mispoke. I'm reffering to dynamic server page registration.
> 
>         Of course it does not eliminate pinning - but it does mitigate the
>         foot print of the VM as a feature that was requested.
> 
>         I have implemented it and documented it.
> 
>         - Michael
> 
>     Okay, but GIFT is supposed to be used on send side: it's only allowed
>     with local/remote read access, and serves to reduce memory usage
>     on send side.
>     For example, disable zero page detection and look at memory usage
>     on send side before and after migration.
>     Dynamic registration on the receive side is nice but seems
>     completely unrelated ...
> 
> 
> 
