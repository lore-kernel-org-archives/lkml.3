Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaEMPRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:17:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbaEMPQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:16:56 -0400
Date: Tue, 13 May 2014 18:15:27 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Romain Francoise <romain@orebokech.com>
Cc: Michael Mueller <mimu@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        cornelia.huck@de.ibm.com, ddongch@cn.ibm.com
Subject: Re: [PATCH v1] vhost: avoid large order allocations
Message-ID: <20140513151527.GA28517@redhat.com>
References: <1399970133-46783-1-git-send-email-mimu@linux.vnet.ibm.com>
 <1399970133-46783-2-git-send-email-mimu@linux.vnet.ibm.com>
 <20140513084049.GE29442@redhat.com>
 <87tx8tg3a1.fsf@kima.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tx8tg3a1.fsf@kima.orebokech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 04:29:58PM +0200, Romain Francoise wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> 
> > Please dont' do this, extra indirection hurts performance.
> > Instead, please change vhost_net_open and scsi to allocate the whole
> > structure with vmalloc if kmalloc fails, along the lines of
> > 74d332c13b2148ae934ea94dac1745ae92efe8e5
> 
> Back in January 2013, you didn't seem to think it was a good idea:
> 
> https://lkml.org/lkml/2013/1/23/492

Hmm true, and Dave thought the structure's too large.
I'll have to do some benchmarks to see what the effect
of Michael's patch is, performance-wise.
If it's too expensive I can pick up your patch, no need to
repost.

-- 
MST
