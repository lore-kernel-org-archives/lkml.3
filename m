Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308Ab3DBMkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 08:40:40 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:36560 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759842Ab3DBMkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 08:40:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130402121048.GA9488@arwen.pp.htv.fi>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
	<1364824448-14732-2-git-send-email-gautam.vivek@samsung.com>
	<20130402082342.GF30286@arwen.pp.htv.fi>
	<CAFp+6iFW9-fOCgCfpfQzS9PZyjb9_NahjSxzbrS0AhVeNngyXw@mail.gmail.com>
	<20130402121048.GA9488@arwen.pp.htv.fi>
Date: Tue, 2 Apr 2013 18:10:35 +0530
Message-ID: <CAFp+6iEqHOc6G+4UpUGneQ43FGf11DOH_LignFiXJxVJnjry2w@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] usb: phy: Add APIs for runtime power management
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com, kishon@ti.com,
        dianders@chromium.org, t.figa@samsung.com, p.paneri@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Tue, Apr 2, 2013 at 5:40 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Apr 02, 2013 at 04:04:01PM +0530, Vivek Gautam wrote:
>> > On Mon, Apr 01, 2013 at 07:24:00PM +0530, Vivek Gautam wrote:
>> >> Adding  APIs to handle runtime power management on PHY
>> >> devices. PHY consumers may need to wake-up/suspend PHYs
>> >> when they work across autosuspend.
>> >>
>> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> >> ---
>> >>  include/linux/usb/phy.h |  141 +++++++++++++++++++++++++++++++++++++++++++++++
>> >>  1 files changed, 141 insertions(+), 0 deletions(-)
>> >>
>> >> diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
>> >> index 6b5978f..01bf9c1 100644
>> >> --- a/include/linux/usb/phy.h
>> >> +++ b/include/linux/usb/phy.h
>> >> @@ -297,4 +297,145 @@ static inline const char *usb_phy_type_string(enum usb_phy_type type)
>> >>               return "UNKNOWN PHY TYPE";
>> >>       }
>> >>  }
>> >> +
>> >> +static inline void usb_phy_autopm_enable(struct usb_phy *x)
>> >> +{
>> >> +     if (!x || !x->dev) {
>> >> +             dev_err(x->dev, "no PHY or attached device available\n");
>> >> +             return;
>> >> +             }
>> >
>> > wrong indentation, also, I'm not sure we should allow calls with NULL
>> > pointers. Perhaps a WARN() so we get API offenders early enough ?
>>
>> True, bad coding style :-(
>> We should be handling dev_err with a NULL pointer.
>> Will just keep here:
>> if (WARN_ON(!x->dev))
>>       return .... ;
>
> right, but I guess:
>
> if (WARN(!x || !x->dev, "Invalid parameters\n"))
>         return -EINVAL;
>
> would be better ??

Yea, better. Thanks
Will amend this accordingly.


-- 
Thanks & Regards
Vivek
