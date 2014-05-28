Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbaE1NyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:54:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbaE1NyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:54:13 -0400
Date: Wed, 28 May 2014 13:53:58 +0000
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] HID: hid-sensor-hub: Set report quirk for Microsoft
 Surface
Message-ID: <20140528135358.GA27859@mail.corp.redhat.com>
References: <1401175750-3008-1-git-send-email-reyad.attiyat@gmail.com>
 <alpine.LNX.2.00.1405281541100.17241@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1405281541100.17241@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 28 2014 or thereabouts, Jiri Kosina wrote:
> On Tue, 27 May 2014, Reyad Attiyat wrote:
> 
> > Add the Microsoft Surface Pro 2 Type/Touch and default device hardware ID's
> > Set report quirk for the device in hid-sensor-hub
> > 
> > Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
> > ---
> >  drivers/hid/hid-ids.h        | 3 +++
> >  drivers/hid/hid-sensor-hub.c | 9 +++++++++
> >  2 files changed, 12 insertions(+)
> > 
> > diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> > index 34bb220..18e2099 100644
> > --- a/drivers/hid/hid-ids.h
> > +++ b/drivers/hid/hid-ids.h
> > @@ -633,6 +633,9 @@
> >  #define USB_DEVICE_ID_MS_PRESENTER_8K_USB	0x0713
> >  #define USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K	0x0730
> >  #define USB_DEVICE_ID_MS_COMFORT_MOUSE_4500	0x076c
> > +#define USB_DEVICE_ID_MS_SURFACE_PRO_2   0x0799
> > +#define USB_DEVICE_ID_MS_TOUCH_COVER_2   0x07a7
> > +#define USB_DEVICE_ID_MS_TYPE_COVER_2    0x07a9
> >  
> >  #define USB_VENDOR_ID_MOJO		0x8282
> >  #define USB_DEVICE_ID_RETRO_ADAPTER	0x3201
> > diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
> > index be14b56..eefaaf6 100644
> > --- a/drivers/hid/hid-sensor-hub.c
> > +++ b/drivers/hid/hid-sensor-hub.c
> > @@ -711,6 +711,15 @@ static const struct hid_device_id sensor_hub_devices[] = {
> >  	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, USB_VENDOR_ID_TEXAS_INSTRUMENTS,
> >  			USB_DEVICE_ID_TEXAS_INSTRUMENTS_LENOVO_YOGA),
> >  			.driver_data = HID_SENSOR_HUB_ENUM_QUIRK},
> > +	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, USB_VENDOR_ID_MICROSOFT,
> > +			USB_DEVICE_ID_MS_SURFACE_PRO_2),
> > +			.driver_data = HID_SENSOR_HUB_ENUM_QUIRK},
> > +	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, USB_VENDOR_ID_MICROSOFT,
> > +			USB_DEVICE_ID_MS_TOUCH_COVER_2),
> > +			.driver_data = HID_SENSOR_HUB_ENUM_QUIRK},
> > +	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, USB_VENDOR_ID_MICROSOFT,
> > +			USB_DEVICE_ID_MS_TYPE_COVER_2),
> > +			.driver_data = HID_SENSOR_HUB_ENUM_QUIRK},
> >  	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, HID_ANY_ID,
> >  		     HID_ANY_ID) },
> >  	{ }
> 
> [ Benjamin added to CC]
> 
> How does this combine with f3b0cbce01 and e24d0d399b2f in Linus' tree?

I guess this should be fine:
f3b0cbce01 has no more impact (there is no USB_DEVICE_ID_MS_*_2
anymore)

e24d0d399b2f will properly add the HID_GROUP_SENSOR_HUB to the sensors
if the report descriptor is properly set.

Given that the group SENSOR_HUB will be set, no other hid driver will
pick them, so this patch just adds the HID_SENSOR_HUB_ENUM_QUIRK to the
actual sensors in the surface 2.

So:

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin
