Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaJQJQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:16:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbaJQJQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:16:43 -0400
Date: Fri, 17 Oct 2014 12:20:11 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Subject: Re: [PATCH] virtio_net: fix use after free
Message-ID: <20141017092011.GA31313@redhat.com>
References: <1413378878-28118-1-git-send-email-mst@redhat.com>
 <20141015.164727.298073723527552510.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015.164727.298073723527552510.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 04:47:27PM -0400, David Miller wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Wed, 15 Oct 2014 16:23:28 +0300
> 
> > You used __netif_subqueue_stopped but that seems to use
> > a slightly more expensive test_bit internally.
> 
> More expensive in what sense?  It should be roughly the same
> as "x & y" sans the volatile.

I really just meant volatile - this might prevent some compiler
optimizations. I have't actually checked the produced binary so
I don't know for sure.

> Anyways I'm ambivalent and I want to see this bug fixes, so I'll
> apply your patch.
> 
> Thanks!
