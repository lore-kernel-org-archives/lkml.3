Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaIEV0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:26:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42299 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaIEV0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:26:08 -0400
Date: Fri, 5 Sep 2014 14:26:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Enable interrupt driven flow
 control
Message-ID: <20140905212607.GA29137@kroah.com>
References: <1409941402-486-1-git-send-email-kys@microsoft.com>
 <20140905191148.GA24879@kroah.com>
 <af50b440e57a455e810242b83a2462ad@BY2PR0301MB0711.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af50b440e57a455e810242b83a2462ad@BY2PR0301MB0711.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 08:53:01PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Friday, September 5, 2014 12:12 PM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com
> > Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Enable interrupt driven flow
> > control
> > 
> > On Fri, Sep 05, 2014 at 11:23:22AM -0700, K. Y. Srinivasan wrote:
> > > This is a win8 feature that has been implemented. Turn on the feature
> > > bit to enable the feature.
> > 
> > What does those two sentances even mean?
> Greg,
> 
> The feature has been implemented and has been in the tree for a while.

What feature?  What is "This" in the first sentance?

> However, the feature was not advertised to the host and this patch does just that.
> > 
> > > With this feature turned on,
> > 
> > What is "this"?
> "this" refers to the feature bit.
> > 
> > > when the host is waiting
> > > for space to become available on the ringbuffer (host to guest), the
> > > guest will interrupt the host when space becomes available (as part of
> > > draining the ring buffer).
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > ---
> > >  drivers/hv/ring_buffer.c |    5 +++++
> > >  1 files changed, 5 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c index
> > > 15db66b..6361d12 100644
> > > --- a/drivers/hv/ring_buffer.c
> > > +++ b/drivers/hv/ring_buffer.c
> > > @@ -361,6 +361,11 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info
> > *ring_info,
> > >  	ring_info->ring_buffer->read_index =
> > >  		ring_info->ring_buffer->write_index = 0;
> > >
> > > +	/*
> > > +	 * Set the feature bit for enabling flow control.
> > > +	 */
> > > +	ring_info->ring_buffer->feature_bits.value = 1;
> > 
> > What happens if you are running on an old system that doesn't support this
> > new "feature"?
> The control structure for the ring buffer (where this feature bit is) has not changed and so, for
> hosts that don't understand this, it does not matter.
> 
> Hope this helps. Let me know if you want me to rewrite comment and resend this patch.

Please do, it's confusing :)

thanks,

greg k-h
