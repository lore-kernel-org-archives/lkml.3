Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaIXMAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:00:10 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:37755 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaIXMAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:00:08 -0400
Date: Wed, 24 Sep 2014 13:00:02 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Johan Hovold <johan@kernel.org>
Cc: Octavian Purdila <octavian.purdila@intel.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mfd: viperboard: allocate I/O buffer separately
Message-ID: <20140924120002.GA32069@lee--X1>
References: <1411414759-7056-1-git-send-email-octavian.purdila@intel.com>
 <1411414759-7056-2-git-send-email-octavian.purdila@intel.com>
 <20140924101206.GD19999@lee--X1>
 <20140924102853.GA17019@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140924102853.GA17019@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, Johan Hovold wrote:

> On Wed, Sep 24, 2014 at 11:12:06AM +0100, Lee Jones wrote:
> > On Mon, 22 Sep 2014, Octavian Purdila wrote:
> > 
> > > Currently the I/O buffer is allocated part of the device status
> > > structure, potentially sharing the same cache line with other members
> > > in this structure.
> > > 
> > > Allocate the buffer separately, to avoid the I/O operations corrupting
> > > the device status structure due to cache line sharing.
> > > 
> > > Compiled tested only as I don't have access to hardware.
> > > 
> > > Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> > > ---
> > >  drivers/mfd/viperboard.c       | 8 ++++++++
> > >  include/linux/mfd/viperboard.h | 2 +-
> > >  2 files changed, 9 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
> > > index e00f534..5f62f4e 100644
> > > --- a/drivers/mfd/viperboard.c
> > > +++ b/drivers/mfd/viperboard.c
> > > @@ -64,6 +64,12 @@ static int vprbrd_probe(struct usb_interface *interface,
> > >  		return -ENOMEM;
> > >  	}
> > >  
> > > +	vb->buf = kzalloc(sizeof(struct vprbrd_i2c_write_msg), GFP_KERNEL);
> > 
> > Can you obtain the 'struct device' first then use managed resources
> > (devm_*)?
> 
> I think any devres conversion should be done in a follow-up patch and
> not be included in the fix (e.g. in order to facilitate backporting). We
> also don't want to mix allocation schemes.

I agree, but equally I'm not keen on accepting this patch as I believe
it could be done better.

Please submit two patches, one converting to shared resources and this
being the subsequent one, fixed up to do the right thing.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
