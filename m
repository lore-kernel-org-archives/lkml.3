Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbaJVUyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:54:05 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:49404 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbaJVUyD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:54:03 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "dinh.linux@gmail.com" <dinh.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "matthijs@stdin.nl" <matthijs@stdin.nl>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCHv5 2/7] usb: dwc2: Move gadget probe function into
 platform code
Thread-Topic: [PATCHv5 2/7] usb: dwc2: Move gadget probe function into
 platform code
Thread-Index: AQHP7JeWxo/v/FWZ+k2pyxdK5fFixZw8b0uAgAAqwDA=
Date: Wed, 22 Oct 2014 20:54:00 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844E4FDC@US01WEMBX2.internal.synopsys.com>
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
 <1413831126-24193-3-git-send-email-dinguyen@opensource.altera.com>
 <29460399.4PyRbDpEzA@amdc1032>
In-Reply-To: <29460399.4PyRbDpEzA@amdc1032>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Bartlomiej Zolnierkiewicz [mailto:b.zolnierkie@samsung.com]
> Sent: Wednesday, October 22, 2014 4:16 AM
> 
> On Monday, October 20, 2014 01:52:01 PM dinguyen@opensource.altera.com wrote:
> > From: Dinh Nguyen <dinguyen@opensource.altera.com>
> >
> > This patch will aggregate the probing of gadget/hcd driver into platform.c.
> > The gadget probe funtion is converted into gadget_init that is now only
> > responsible for gadget only initialization. All the gadget resources is now
> > handled by platform.c
> >
> > Since the host workqueue will not get initialized if the driver is configured
> > for peripheral mode only. Thus we need to check for wq_otg before calling
> > queue_work().
> >
> > Also, we move spin_lock_init to common location for both host and gadget that
> > is either in platform.c or pci.c.
> >
> > We also ove suspend/resume code to common platform code, and update it to use
> > the new PM API (struct dev_pm_ops).
> >
> > Lastly, move the "samsung,s3c6400-hsotg" binding into dwc2_of_match_table.
> 
> This patch seems to break bisectability.  It moves all the gadget probing
> to platform.c but Kconfig/Makefile are not updated (platform.c will be
> compiled only for CONFIG_USB_DWC2_PLATFORM=y which in turn depends on
> CONFIG_USB_DWC2_HOST).  IMO patch #7 should be merged into this one (#2).

It doesn't break the compile, I already tested it. It does break the
operation of the driver until patch #7 is applied, but I think that's
OK in the middle of a patch series. I think it's a bit much to expect
the driver to keep working at each step of a patch series like this.

-- 
Paul

