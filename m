Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaFMUsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:48:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669AbaFMUsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:48:38 -0400
Date: Fri, 13 Jun 2014 16:48:26 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input - wacom: remove phys field in struct wacom
Message-ID: <20140613204826.GA30355@mail.corp.redhat.com>
References: <1402691344-26196-1-git-send-email-benjamin.tissoires@redhat.com>
 <20140613203545.GA31651@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140613203545.GA31651@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 13 2014 or thereabouts, Dmitry Torokhov wrote:
> On Fri, Jun 13, 2014 at 04:29:04PM -0400, Benjamin Tissoires wrote:
> > This field is not used, remove it.
> 
> We must have lost the assignment, but it should be assigned to phys of
> corresponding input device. 

hehe. Even in 2007, when the files moved under drivers/input/tablet,
there is no mention of assigning input_dev->phys :)

I can send a patch to fix the other way around if you prefer (add
input_dev->phys).

Cheers,
Benjamin

> 
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > ---
> >  drivers/input/tablet/wacom.h     | 1 -
> >  drivers/input/tablet/wacom_sys.c | 2 --
> >  2 files changed, 3 deletions(-)
> > 
> > diff --git a/drivers/input/tablet/wacom.h b/drivers/input/tablet/wacom.h
> > index 9ebf0ed..70b1e71 100644
> > --- a/drivers/input/tablet/wacom.h
> > +++ b/drivers/input/tablet/wacom.h
> > @@ -114,7 +114,6 @@ struct wacom {
> >  	struct mutex lock;
> >  	struct work_struct work;
> >  	bool open;
> > -	char phys[32];
> >  	struct wacom_led {
> >  		u8 select[2]; /* status led selector (0..3) */
> >  		u8 llv;       /* status led brightness no button (1..127) */
> > diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
> > index 2c613cd..94096fd 100644
> > --- a/drivers/input/tablet/wacom_sys.c
> > +++ b/drivers/input/tablet/wacom_sys.c
> > @@ -1323,8 +1323,6 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
> >  	wacom->intf = intf;
> >  	mutex_init(&wacom->lock);
> >  	INIT_WORK(&wacom->work, wacom_wireless_work);
> > -	usb_make_path(dev, wacom->phys, sizeof(wacom->phys));
> > -	strlcat(wacom->phys, "/input0", sizeof(wacom->phys));
> >  
> >  	endpoint = &intf->cur_altsetting->endpoint[0].desc;
> >  
> > -- 
> > 1.9.0
> > 
> 
> -- 
> Dmitry
