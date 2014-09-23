Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaIWHlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:41:15 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:48258 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaIWHlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:41:14 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 23 Sep 2014 09:38:40 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, johan@kernel.org
Subject: Re: [PATCH v2 1/2] mfd: viperboard: allocate I/O buffer separately
Message-ID: <20140923073840.GN5237@localhost>
References: <1411414759-7056-1-git-send-email-octavian.purdila@intel.com>
 <1411414759-7056-2-git-send-email-octavian.purdila@intel.com>
 <20140923073541.GM5237@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923073541.GM5237@localhost>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 09:35:41AM +0200, Johan Hovold wrote:
> On Mon, Sep 22, 2014 at 10:39:18PM +0300, Octavian Purdila wrote:
> > Currently the I/O buffer is allocated part of the device status
> > structure, potentially sharing the same cache line with other members
> > in this structure.
> > 
> > Allocate the buffer separately, to avoid the I/O operations corrupting
> > the device status structure due to cache line sharing.
> > 
> > Compiled tested only as I don't have access to hardware.
> > 
> > Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> > ---
> >  drivers/mfd/viperboard.c       | 8 ++++++++
> >  include/linux/mfd/viperboard.h | 2 +-
> >  2 files changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
> > index e00f534..5f62f4e 100644
> > --- a/drivers/mfd/viperboard.c
> > +++ b/drivers/mfd/viperboard.c
> > @@ -64,6 +64,12 @@ static int vprbrd_probe(struct usb_interface *interface,
> >  		return -ENOMEM;
> >  	}
> >  
> > +	vb->buf = kzalloc(sizeof(struct vprbrd_i2c_write_msg), GFP_KERNEL);
> > +	if (vb->buf == NULL) {
> > +		ret = -ENOMEM;
> > +		goto error;
> 
> This will cause a kref imbalance as you have a usb_put_dev in error,
> but haven't done the get yet.

Nevermind. This isn't problem as the usb device is null.

Haven't had my morning coffee yet. ;)

Johan
