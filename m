Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaKFRVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:21:47 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:33443 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaKFRVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:21:43 -0500
MIME-Version: 1.0
In-Reply-To: <1415237402-24665-1-git-send-email-kever.yang@rock-chips.com>
References: <1415237402-24665-1-git-send-email-kever.yang@rock-chips.com>
Date: Thu, 6 Nov 2014 18:21:42 +0100
Message-ID: <CABgxDo+9aZJ8BP3h=3sUUbSBD5R_FQmWF9f8kbzDbZrVG01n1A@mail.gmail.com>
Subject: Re: [PATCH v2] usb: dwc2: add bus suspend/resume for dwc2
From: Romain Perier <romain.perier@gmail.com>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Paul Zimmerman <paulz@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Heiko Stuebner <heiko@sntech.de>, dianders@chromium.org,
        sonnyrao@chromium.org, addy.ke@rock-chips.com,
        Eddie Cai <cf@rock-chips.com>, xjq@rock-chips.com, hj@rock-chips.com,
        dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kever,


2014-11-06 2:30 GMT+01:00 Kever Yang <kever.yang@rock-chips.com>:
>
> +static int _dwc2_hcd_suspend(struct usb_hcd *hcd)
> +{
> +       struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
> +       u32 hprt0;
> +
> +       if (!((hsotg->op_state == OTG_STATE_B_HOST) ||
> +               (hsotg->op_state == OTG_STATE_A_HOST)))
> +               return 0;
> +
> +       if (hsotg->lx_state != DWC2_L0)
> +               return 0;
> +
> +       hprt0 = dwc2_read_hprt0(hsotg);
> +       if (hprt0 & HPRT0_CONNSTS)
> +               dwc2_port_suspend(hsotg, 1);
> +
> +       return 0;
> +}
> +
> +static int _dwc2_hcd_resume(struct usb_hcd *hcd)
> +{
> +       struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
> +       u32 hprt0;
> +
> +       if (!((hsotg->op_state == OTG_STATE_B_HOST) ||
> +               (hsotg->op_state == OTG_STATE_A_HOST)))
> +               return 0;
> +
> +       if (hsotg->lx_state != DWC2_L2)
> +               return 0;
> +
> +       hprt0 = dwc2_read_hprt0(hsotg);
> +       if ((hprt0 & HPRT0_CONNSTS) && (hprt0 & HPRT0_SUSP))
> +               dwc2_port_resume(hsotg);
> +
> +       return 0;
> +}

Could you also define these functions under #ifdef CONFIG_PM ?

Thanks.
