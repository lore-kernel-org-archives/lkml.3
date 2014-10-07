Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaJGMrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:47:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbaJGMru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:47:50 -0400
Date: Tue, 7 Oct 2014 15:51:15 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 01/15] virtio_pci: fix virtio spec compliance on
 restore
Message-ID: <20141007125115.GA5968@redhat.com>
References: <1412608214-31944-1-git-send-email-mst@redhat.com>
 <1412608214-31944-2-git-send-email-mst@redhat.com>
 <20141007120513.GA823@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007120513.GA823@grmbl.mre>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 05:35:13PM +0530, Amit Shah wrote:
> On (Mon) 06 Oct 2014 [18:10:40], Michael S. Tsirkin wrote:
> > On restore, virtio pci does the following:
> > + set features
> > + init vqs etc - device can be used at this point!
> > + set ACKNOWLEDGE,DRIVER and DRIVER_OK status bits
> > 
> > This is in violation of the virtio spec, which
> > requires the following order:
> > - ACKNOWLEDGE
> > - DRIVER
> > - init vqs
> > - DRIVER_OK
> > 
> > This behaviour will break with hypervisors that assume spec compliant
> > behaviour.  It seems like a good idea to have this patch applied to
> > stable branches to reduce the support butden for the hypervisors.
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Amit Shah <amit.shah@redhat.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> I didn't see my previous questions answered from the initial posting
> -- can you please respond to them?
> 
> 		Amit

Ooops missed your mail.
Will respond now.

