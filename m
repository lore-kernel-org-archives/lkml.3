Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaGZVMl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 17:12:41 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:40862 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaGZVMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 17:12:39 -0400
Date: Sat, 26 Jul 2014 14:12:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@bitmath.org>
Cc: linux-input@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benson Leung <bleung@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: synaptics - properly initialize slots for semi-MT
Message-ID: <20140726211235.GB11800@core.coreip.homeip.net>
References: <20140726002751.GA16660@core.coreip.homeip.net>
 <53D3CE2E.3040103@bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D3CE2E.3040103@bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 05:50:06PM +0200, Henrik Rydberg wrote:
> Hi Dmitry,
> 
> On 07/26/2014 02:27 AM, Dmitry Torokhov wrote:
> > Semi-MT devices are pointers too, so let's tell that to
> > input_mt_init_slots(), as well as let it set up the devices as semi-MT,
> > instead of us doing it manually.
> > 
> > Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>
> > Reviewed-by: Benson Leung <bleung@chromium.org>
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > ---
> >  drivers/input/mouse/synaptics.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> > index ef9e0b8..fe607e9 100644
> > --- a/drivers/input/mouse/synaptics.c
> > +++ b/drivers/input/mouse/synaptics.c
> > @@ -1371,11 +1371,11 @@ static void set_input_params(struct psmouse *psmouse,
> >  		__set_bit(BTN_TOOL_QUADTAP, dev->keybit);
> >  		__set_bit(BTN_TOOL_QUINTTAP, dev->keybit);
> >  	} else if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)) {
> > -		/* Non-image sensors with AGM use semi-mt */
> > -		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
> > -		input_mt_init_slots(dev, 2, 0);
> >  		set_abs_position_params(dev, priv, ABS_MT_POSITION_X,
> >  					ABS_MT_POSITION_Y);
> > +		/* Non-image sensors with AGM use semi-mt */
> > +		input_mt_init_slots(dev, 2,
> > +				    INPUT_MT_POINTER | INPUT_MT_SEMI_MT);
> >  	}
> 
> As long as DOUBLE_TAP is set unconditionally in this path anyways, it should be
> ok. I have a vague memory of refraining from this exact change at some point,
> because of the many branches of settings.

Yes, it is, as we should be hitting the multi-finger capability check
below.

Thanks.

-- 
Dmitry
