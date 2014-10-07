Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaJGQyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:54:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbaJGQyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:54:46 -0400
Date: Tue, 7 Oct 2014 22:24:39 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 01/15] virtio_pci: fix virtio spec compliance on
 restore
Message-ID: <20141007165439.GB823@grmbl.mre>
References: <1412608214-31944-1-git-send-email-mst@redhat.com>
 <1412608214-31944-2-git-send-email-mst@redhat.com>
 <20141007125355.GA5974@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007125355.GA5974@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 07 Oct 2014 [15:53:55], Michael S. Tsirkin wrote:
> On Mon, Oct 06, 2014 at 06:10:40PM +0300, Michael S. Tsirkin wrote:
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
> 
> Tested suspend to ram with virtio net and blk.

I'd recommend running a continuous ping for virtio-net and a dd
process running across s3/s4 for testing.

That's what I had run while doing the original set of patches.

		Amit
