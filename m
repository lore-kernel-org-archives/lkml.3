Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaHWAYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 20:24:01 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:41146 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaHWAYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 20:24:00 -0400
MIME-Version: 1.0
In-Reply-To: <1408752502-4162-1-git-send-email-sojka@merica.cz>
References: <87ha149j2z.fsf@steelpick.2x.cz> <1408752502-4162-1-git-send-email-sojka@merica.cz>
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 22 Aug 2014 17:23:38 -0700
Message-ID: <CAK5ve-LY5+bTcBNYD72CEzGNontk+0D+y2cmtFu+pNkPNU9skA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] LED triggers for USB host and device
To: Michal Sojka <sojka@merica.cz>
Cc: linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, michal.vokac@comap.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 5:08 PM, Michal Sojka <sojka@merica.cz> wrote:
> This adds LED triggers for USB host and device.
>
> Changes from v1:
> - Moved from drivers/leds/ to drivers/usb/
> - Improved Kconfig help
> - Linked with other modules rather than being standalone modules
>
> Michal Sojka (3):
>   usb: Add missing #include
>   usb: Add LED trigger for USB host activity
>   usb: Add LED trigger for USB gadget activity
>
>  drivers/usb/core/Kconfig        |  9 +++++++++
>  drivers/usb/core/Makefile       |  1 +
>  drivers/usb/core/hcd.c          |  2 ++
>  drivers/usb/core/led.c          | 38 ++++++++++++++++++++++++++++++++++++++

I suggest put host trigger and gadget trigger together in
drivers/usb/core/led.c.

>  drivers/usb/gadget/Kconfig      | 12 ++++++++++++
>  drivers/usb/gadget/udc/Makefile |  5 ++++-
>  drivers/usb/gadget/udc/led.c    | 38 ++++++++++++++++++++++++++++++++++++++

We don't need a duplicated version for gadget.

>  drivers/usb/musb/musb_gadget.c  |  5 +++--
>  include/linux/usb/gadget.h      | 10 ++++++++++
>  include/linux/usb/hcd.h         |  7 +++++++
>  10 files changed, 124 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/usb/core/led.c
>  create mode 100644 drivers/usb/gadget/udc/led.c
>
> --
> 2.1.0
>
