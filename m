Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944AbaJWSra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:47:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888AbaJWSqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:46:16 -0400
Date: Thu, 23 Oct 2014 14:45:54 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Benson Leung <bleung@chromium.org>, jkosina@suse.cz, aduggan@synaptics.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, satoshi.noguchi@jp.synaptics.com
Subject: Re: [PATCH] HID: i2c-hid: Add hid-over-i2c name to i2c id table.
Message-ID: <20141023184554.GB18048@mail.corp.redhat.com>
References: <1413323041-19468-1-git-send-email-bleung@chromium.org>
 <20141014225935.GA22177@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141014225935.GA22177@dtor-ws>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 14 2014 or thereabouts, Dmitry Torokhov wrote:
> On Tue, Oct 14, 2014 at 02:44:01PM -0700, Benson Leung wrote:
> > When using the device tree binding of compatible = "hid-over-i2c"
> > the i2c id table also needs to have that name in order to
> > auto load this driver.
> > 
> > Signed-off-by: Benson Leung <bleung@chromium.org>
> > ---
> >  drivers/hid/i2c-hid/i2c-hid.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> > index 747d544..1a7605f 100644
> > --- a/drivers/hid/i2c-hid/i2c-hid.c
> > +++ b/drivers/hid/i2c-hid/i2c-hid.c
> > @@ -1123,6 +1123,7 @@ static const struct dev_pm_ops i2c_hid_pm = {
> >  
> >  static const struct i2c_device_id i2c_hid_id_table[] = {
> >  	{ "hid", 0 },
> > +	{ "hid-over-i2c", 0 },
> >  	{ },
> >  };
> >  MODULE_DEVICE_TABLE(i2c, i2c_hid_id_table);
> 
> So we already emit this string this as a module device table (OF one),
> why do we need to duplicate it in I2C? This seems like a generic problem
> and not an individual driver one.
> 

Correct me if I am wrong, but isn't it a chromium problem, rather than a
generic OF one?
IIRC, when I introduced the OF binding, the name did not need to be in
the i2c id table because udev was taking that in charge. At least I do
not remember having to manually modprobing the driver.

A quick check in the drivers/input/touchscreen shows that many OF
enumerated touchscreens do not have an exact duplicate of the of
compatible name and the i2c device id one. Most of them have a vendor
prefix in the of name.

I did not used this binding for a long time, so I can not guarantee I am
right, but this change seems weird to me.

Cheers,
Benjamin

