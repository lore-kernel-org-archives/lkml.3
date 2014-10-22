Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbaJVU1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:27:13 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:63545 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932336AbaJVU1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:27:11 -0400
Message-ID: <1414009627.17121.15.camel@x220>
Subject: Re: [PATCHv5 7/7] usb: dwc2: Update Kconfig to support dual-role
From: Paul Bolle <pebolle@tiscali.nl>
To: Dinh Nguyen <dinguyen@opensource.altera.com>
Cc: paulz@synopsys.com, balbi@ti.com, dinh.linux@gmail.com,
        linux-kernel@vger.kernel.org, swarren@wwwdotorg.org,
        b.zolnierkie@samsung.com, matthijs@stdin.nl, r.baldyga@samsung.com,
        jg1.han@samsung.com, sachin.kamat@linaro.org, ben-linux@fluff.org,
        dianders@chromium.org, kever.yang@rock-chips.com,
        linux-usb@vger.kernel.org
Date: Wed, 22 Oct 2014 22:27:07 +0200
In-Reply-To: <5446C668.3020609@opensource.altera.com>
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
		 <1413831126-24193-8-git-send-email-dinguyen@opensource.altera.com>
	 <1413834151.2010.19.camel@x41> <5446C668.3020609@opensource.altera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2014 20:27:08.0314 (UTC) FILETIME=[8D4A5FA0:01CFEE36]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 15:47 -0500, Dinh Nguyen wrote:
> On 10/20/2014 02:42 PM, Paul Bolle wrote:
> > (Side note: drivers/usb/dwc2/Kconfig is sourced (in drivers/usb/Kconfig)
> > even if USB is _not_ set. But USB_DCW2 still depends on USB. Why is
> > that?)
> 
> Because USB is for Host-Side support. DWC2 driver should only get built
> for when USB is enabled. I think you're getting USB and USB_SUPPORT
> mixed up.

No, I don't think I did. Because in drivers/usb/Kconfig we see  
    if USB

    [...]

    endif

    [...]

    source "drivers/usb/dwc2/Kconfig"

    [...]

> In addition, thanks to your comment, I realized that DWC2 should also be
> available to build when USB_GADGET is enabled. A patch has been sent:
> 
> http://marc.info/?l=linux-usb&m=141392377124818&w=2

I haven't checked, but doesn't this mean USB_DWC2 could just depend on
USB_SUPPORT?


Paul Bolle

