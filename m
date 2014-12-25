Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaLYPF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 10:05:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbaLYPFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 10:05:55 -0500
Date: Thu, 25 Dec 2014 17:05:48 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v2 0/2] virtio/vhost: fix alignment requirements
Message-ID: <20141225150548.GA12865@redhat.com>
References: <1419517332-12291-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419517332-12291-1-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 05:05:01PM +0200, Michael S. Tsirkin wrote:
> vhost incorrectly asked for 8 byte alignment for
> used ring pointer, it should be 4 byte.
> 
> Let's add explicit macros for ring element alignment,
> this makes it easier to make sure our requirements
> match the spec.
> 
> Rusty, OK to merge this through my vhost tree, or do you
> prefer merging this through yours?

Just to clarify, this is needed in 3.19.

> Michael S. Tsirkin (2):
>   virtio_ring: document alignment requirements
>   vhost: relax used address alignment
> 
>  include/uapi/linux/virtio_ring.h |  7 +++++++
>  drivers/vhost/vhost.c            | 10 +++++++---
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> -- 
> MST
> 
