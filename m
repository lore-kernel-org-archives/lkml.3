Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaENILd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 04:11:33 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:48695 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaENIL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 04:11:27 -0400
Date: Wed, 14 May 2014 10:11:15 +0200
From: Michael Mueller <mimu@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Romain Francoise <romain@orebokech.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        cornelia.huck@de.ibm.com, ddongch@cn.ibm.com
Subject: Re: [PATCH v1] vhost: avoid large order allocations
Message-ID: <20140514101115.4b7ffd69@bee>
In-Reply-To: <20140513151527.GA28517@redhat.com>
References: <1399970133-46783-1-git-send-email-mimu@linux.vnet.ibm.com>
	<1399970133-46783-2-git-send-email-mimu@linux.vnet.ibm.com>
	<20140513084049.GE29442@redhat.com>
	<87tx8tg3a1.fsf@kima.orebokech.com>
	<20140513151527.GA28517@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051408-5024-0000-0000-000009D255BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014 18:15:27 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Tue, May 13, 2014 at 04:29:58PM +0200, Romain Francoise wrote:
> > "Michael S. Tsirkin" <mst@redhat.com> writes:
> > 
> > > Please dont' do this, extra indirection hurts performance.
> > > Instead, please change vhost_net_open and scsi to allocate the whole
> > > structure with vmalloc if kmalloc fails, along the lines of
> > > 74d332c13b2148ae934ea94dac1745ae92efe8e5
> > 
> > Back in January 2013, you didn't seem to think it was a good idea:
> > 
> > https://lkml.org/lkml/2013/1/23/492
> 
> Hmm true, and Dave thought the structure's too large.
> I'll have to do some benchmarks to see what the effect
> of Michael's patch is, performance-wise.
> If it's too expensive I can pick up your patch, no need to
> repost.
> 

Thanks, let us know then.

