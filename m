Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaKFSgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:36:03 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:58187 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaKFSgA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:36:00 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "balbi@ti.com" <balbi@ti.com>, Romain Perier <romain.perier@gmail.com>
CC: Kever Yang <kever.yang@rock-chips.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        "dkl@rock-chips.com" <dkl@rock-chips.com>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        "linux-rockchip@lists.infradead.org" 
	<linux-rockchip@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] usb: dwc2: add bus suspend/resume for dwc2
Thread-Topic: [PATCH v2] usb: dwc2: add bus suspend/resume for dwc2
Thread-Index: AQHP+WE66t1Wym4ZZ0eZMEU7TpKE25xUX50AgAAFKoD//4fjQA==
Date: Thu, 6 Nov 2014 18:35:53 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844E9C67@US01WEMBX2.internal.synopsys.com>
References: <1415237402-24665-1-git-send-email-kever.yang@rock-chips.com>
 <CABgxDo+9aZJ8BP3h=3sUUbSBD5R_FQmWF9f8kbzDbZrVG01n1A@mail.gmail.com>
 <20141106174011.GI16896@saruman>
In-Reply-To: <20141106174011.GI16896@saruman>
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

> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Thursday, November 06, 2014 9:40 AM
> 
> On Thu, Nov 06, 2014 at 06:21:42PM +0100, Romain Perier wrote:
> >
> > 2014-11-06 2:30 GMT+01:00 Kever Yang <kever.yang@rock-chips.com>:
> > >
> > > +static int _dwc2_hcd_suspend(struct usb_hcd *hcd)
> > > +{
> > > +       struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
> > > +       u32 hprt0;
> > > +
> > > +       if (!((hsotg->op_state == OTG_STATE_B_HOST) ||
> > > +               (hsotg->op_state == OTG_STATE_A_HOST)))
> > > +               return 0;
> > > +
> > > +       if (hsotg->lx_state != DWC2_L0)
> > > +               return 0;
> > > +
> > > +       hprt0 = dwc2_read_hprt0(hsotg);
> > > +       if (hprt0 & HPRT0_CONNSTS)
> > > +               dwc2_port_suspend(hsotg, 1);
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +static int _dwc2_hcd_resume(struct usb_hcd *hcd)
> > > +{
> > > +       struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
> > > +       u32 hprt0;
> > > +
> > > +       if (!((hsotg->op_state == OTG_STATE_B_HOST) ||
> > > +               (hsotg->op_state == OTG_STATE_A_HOST)))
> > > +               return 0;
> > > +
> > > +       if (hsotg->lx_state != DWC2_L2)
> > > +               return 0;
> > > +
> > > +       hprt0 = dwc2_read_hprt0(hsotg);
> > > +       if ((hprt0 & HPRT0_CONNSTS) && (hprt0 & HPRT0_SUSP))
> > > +               dwc2_port_resume(hsotg);
> > > +
> > > +       return 0;
> > > +}
> >
> > Could you also define these functions under #ifdef CONFIG_PM ?
> 
> please don't. I'm actually considering ripping all ifdefs from all these
> drivers and also stop using SIMPLE_DEV_PM_OPS or any of its friends.
> 
> There's really nobody today would would build a kernel with CONFIG_PM.

I'm sure Felipe meant *without* CONFIG_PM.

Kever, in that case you should remove the #ifdef CONFIG_PM around the
.bus_suspend and .bus_resume assignments also, otherwise there will be
compiler warnings when built without CONFIG_PM. After that, you can
add my acked-by.

-- 
Paul

