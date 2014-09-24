Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaIXL4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:56:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbaIXLz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:55:58 -0400
Date: Wed, 24 Sep 2014 14:59:13 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC] virtio_pci: fix virtio spec compliance on restore
Message-ID: <20140924115913.GA32179@redhat.com>
References: <1411468217-18130-1-git-send-email-mst@redhat.com>
 <1411522047.3659.10.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411522047.3659.10.camel@decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 02:27:27AM +0100, Ben Hutchings wrote:
> On Tue, 2014-09-23 at 13:32 +0300, Michael S. Tsirkin wrote:
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
> > Cc: stable@vger.kernel.org
> > Cc: Amit Shah <amit.shah@redhat.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> [...]
> 
> What concrete problem does this fix, such that it should be applied to
> stable branches?
> 
> Ben.

It will break with hypervisors that assume spec compliant behaviour.
I would like this applied to stable branches so hypervisors don't
need to support broken behaviour forever.

-- 
MST
