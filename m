Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497AbaEMOaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:30:00 -0400
Received: from stringer.orebokech.com ([212.83.175.182]:34604 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbaEMO37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:29:59 -0400
From: Romain Francoise <romain@orebokech.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michael Mueller <mimu@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        cornelia.huck@de.ibm.com, ddongch@cn.ibm.com
Subject: Re: [PATCH v1] vhost: avoid large order allocations
Organization: orebokech dot com
References: <1399970133-46783-1-git-send-email-mimu@linux.vnet.ibm.com>
	<1399970133-46783-2-git-send-email-mimu@linux.vnet.ibm.com>
	<20140513084049.GE29442@redhat.com>
Date: Tue, 13 May 2014 16:29:58 +0200
In-Reply-To: <20140513084049.GE29442@redhat.com> (Michael S. Tsirkin's message
	of "Tue, 13 May 2014 11:40:49 +0300")
Message-ID: <87tx8tg3a1.fsf@kima.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> Please dont' do this, extra indirection hurts performance.
> Instead, please change vhost_net_open and scsi to allocate the whole
> structure with vmalloc if kmalloc fails, along the lines of
> 74d332c13b2148ae934ea94dac1745ae92efe8e5

Back in January 2013, you didn't seem to think it was a good idea:

https://lkml.org/lkml/2013/1/23/492
