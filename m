Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbaFLHwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:52:43 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42889 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaFLHwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:52:41 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 12 Jun 2014 16:56:38 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 10/10] mm, cma: use spinlock instead of mutex
Message-ID: <20140612075638.GD20199@js1304-P5Q-DELUXE>
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1402543307-29800-11-git-send-email-iamjoonsoo.kim@lge.com>
 <20140612074029.GB12663@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612074029.GB12663@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 04:40:29PM +0900, Minchan Kim wrote:
> On Thu, Jun 12, 2014 at 12:21:47PM +0900, Joonsoo Kim wrote:
> > Currently, we should take the mutex for manipulating bitmap.
> > This job may be really simple and short so we don't need to sleep
> > if contended. So I change it to spinlock.
> 
> I'm not sure it would be good always.
> Maybe you remember we discussed about similar stuff about bitmap
> searching in vmap friend internally, which was really painful
> when it was fragmented. So, at least we need number if you really want
> and I hope the number from ARM machine most popular platform for CMA
> at the moment.

Good Point!! Agreed. I will drop this one in next spin and re-submit
in separate patchset after some testing.

Thanks.
