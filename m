Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaIXKbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:31:32 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:38087 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaIXKb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:31:27 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 24 Sep 2014 12:28:53 +0200
From: Johan Hovold <johan@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Octavian Purdila <octavian.purdila@intel.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        johan@kernel.org
Subject: Re: [PATCH v2 1/2] mfd: viperboard: allocate I/O buffer separately
Message-ID: <20140924102853.GA17019@localhost>
References: <1411414759-7056-1-git-send-email-octavian.purdila@intel.com>
 <1411414759-7056-2-git-send-email-octavian.purdila@intel.com>
 <20140924101206.GD19999@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924101206.GD19999@lee--X1>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:12:06AM +0100, Lee Jones wrote:
> On Mon, 22 Sep 2014, Octavian Purdila wrote:
> 
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
> 
> Can you obtain the 'struct device' first then use managed resources
> (devm_*)?

I think any devres conversion should be done in a follow-up patch and
not be included in the fix (e.g. in order to facilitate backporting). We
also don't want to mix allocation schemes.

Johan
