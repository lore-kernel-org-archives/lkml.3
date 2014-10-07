Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbaJGMFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:05:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaJGMFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:05:21 -0400
Date: Tue, 7 Oct 2014 17:35:13 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 01/15] virtio_pci: fix virtio spec compliance on
 restore
Message-ID: <20141007120513.GA823@grmbl.mre>
References: <1412608214-31944-1-git-send-email-mst@redhat.com>
 <1412608214-31944-2-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412608214-31944-2-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Mon) 06 Oct 2014 [18:10:40], Michael S. Tsirkin wrote:
> On restore, virtio pci does the following:
> + set features
> + init vqs etc - device can be used at this point!
> + set ACKNOWLEDGE,DRIVER and DRIVER_OK status bits
> 
> This is in violation of the virtio spec, which
> requires the following order:
> - ACKNOWLEDGE
> - DRIVER
> - init vqs
> - DRIVER_OK
> 
> This behaviour will break with hypervisors that assume spec compliant
> behaviour.  It seems like a good idea to have this patch applied to
> stable branches to reduce the support butden for the hypervisors.
> 
> Cc: stable@vger.kernel.org
> Cc: Amit Shah <amit.shah@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

I didn't see my previous questions answered from the initial posting
-- can you please respond to them?

		Amit
