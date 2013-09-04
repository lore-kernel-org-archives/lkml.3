Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934455Ab3IDI2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:28:38 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43900 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934291Ab3IDI2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:28:36 -0400
X-AuditID: 9c93016f-b7cf0ae00000518f-57-5226ef33e9ef
Date: Wed, 4 Sep 2013 17:28:34 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] slab: implement byte sized indexes for the freelist
 of a slab
Message-ID: <20130904082834.GB16355@lge.com>
References: <CAAmzW4N1GXbr18Ws9QDKg7ChN5RVcOW9eEv2RxWhaEoHtw=ctw@mail.gmail.com>
 <1378111138-30340-1-git-send-email-iamjoonsoo.kim@lge.com>
 <5226985f.4475320a.1c61.2623SMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5226985f.4475320a.1c61.2623SMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 10:17:46AM +0800, Wanpeng Li wrote:
> Hi Joonsoo,
> On Mon, Sep 02, 2013 at 05:38:54PM +0900, Joonsoo Kim wrote:
> >This patchset implements byte sized indexes for the freelist of a slab.
> >
> >Currently, the freelist of a slab consist of unsigned int sized indexes.
> >Most of slabs have less number of objects than 256, so much space is wasted.
> >To reduce this overhead, this patchset implements byte sized indexes for
> >the freelist of a slab. With it, we can save 3 bytes for each objects.
> >
> >This introduce one likely branch to functions used for setting/getting
> >objects to/from the freelist, but we may get more benefits from
> >this change.
> >
> >Below is some numbers of 'cat /proc/slabinfo' related to my previous posting
> >and this patchset.
> >
> >
> >* Before *
> ># name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables [snip...]
> >kmalloc-512          525    640    512    8    1 : tunables   54   27    0 : slabdata     80     80      0   
> >kmalloc-256          210    210    256   15    1 : tunables  120   60    0 : slabdata     14     14      0   
> >kmalloc-192         1016   1040    192   20    1 : tunables  120   60    0 : slabdata     52     52      0   
> >kmalloc-96           560    620    128   31    1 : tunables  120   60    0 : slabdata     20     20      0   
> >kmalloc-64          2148   2280     64   60    1 : tunables  120   60    0 : slabdata     38     38      0   
> >kmalloc-128          647    682    128   31    1 : tunables  120   60    0 : slabdata     22     22      0   
> >kmalloc-32         11360  11413     32  113    1 : tunables  120   60    0 : slabdata    101    101      0   
> >kmem_cache           197    200    192   20    1 : tunables  120   60    0 : slabdata     10     10      0   
> >
> >* After my previous posting(overload struct slab over struct page) *
> ># name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables [snip...]
> >kmalloc-512          527    600    512    8    1 : tunables   54   27    0 : slabdata     75     75      0   
> >kmalloc-256          210    210    256   15    1 : tunables  120   60    0 : slabdata     14     14      0   
> >kmalloc-192         1040   1040    192   20    1 : tunables  120   60    0 : slabdata     52     52      0   
> >kmalloc-96           750    750    128   30    1 : tunables  120   60    0 : slabdata     25     25      0   
> >kmalloc-64          2773   2773     64   59    1 : tunables  120   60    0 : slabdata     47     47      0   
> >kmalloc-128          660    690    128   30    1 : tunables  120   60    0 : slabdata     23     23      0   
> >kmalloc-32         11200  11200     32  112    1 : tunables  120   60    0 : slabdata    100    100      0   
> >kmem_cache           197    200    192   20    1 : tunables  120   60    0 : slabdata     10     10      0   
> >
> >kmem_caches consisting of objects less than or equal to 128 byte have one more
> >objects in a slab. You can see it at objperslab.
> 
> I think there is one less objects in a slab after observing objperslab.

Yes :)
I did a mistake when I attached the data about this patchset.
The results of *Before* and *After* should be exchanged.
Thanks for pointing out that.

Thanks.
