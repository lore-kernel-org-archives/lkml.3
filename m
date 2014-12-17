Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbaLQPce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:32:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbaLQPcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:32:33 -0500
Date: Wed, 17 Dec 2014 10:32:05 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Peter Wu <peter@lekensteyn.nl>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] HID: logitech-hidpp: avoid unintended fall-through
Message-ID: <20141217153205.GC16047@mail.corp.redhat.com>
References: <1418691016-30681-1-git-send-email-peter@lekensteyn.nl>
 <1418691016-30681-4-git-send-email-peter@lekensteyn.nl>
 <CAN+gG=E7i605bJEZT+-R+6Ek5qtLt2xQT1Vpnb9=JuT92O5wrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAN+gG=E7i605bJEZT+-R+6Ek5qtLt2xQT1Vpnb9=JuT92O5wrQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 16 2014 or thereabouts, Benjamin Tissoires wrote:
> On Mon, Dec 15, 2014 at 7:50 PM, Peter Wu <peter@lekensteyn.nl> wrote:
> > Add a return to avoid a fall-through. Introduced in commit
> > 57ac86cf52e903d9e3e0f12b34c814cce6b65550 ("HID: logitech-hidpp: add
> > support of the first Logitech Wireless Touchpad").
> >
> > Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> > ---
> 
> This one is reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Jiri, gentle ping on this one too :) 

Cheers,
Benjamin
> 
> >  drivers/hid/hid-logitech-hidpp.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> > index 2315358..09eee17 100644
> > --- a/drivers/hid/hid-logitech-hidpp.c
> > +++ b/drivers/hid/hid-logitech-hidpp.c
> > @@ -811,6 +811,7 @@ static int wtp_raw_event(struct hid_device *hdev, u8 *data, int size)
> >                         input_event(wd->input, EV_KEY, BTN_RIGHT,
> >                                         !!(data[1] & 0x02));
> >                         input_sync(wd->input);
> > +                       return 0;
> >                 } else {
> >                         if (size < 21)
> >                                 return 1;
> > --
> > 2.1.3
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-input" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
