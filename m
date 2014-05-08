Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbaEHO7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:59:36 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56055 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbaEHO7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:59:34 -0400
Message-ID: <1399561124.8165.13.camel@iivanov-dev>
Subject: Re: [PATCH 5/8] usb: phy: msm: reset controller is mandatory now
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Date: Thu, 08 May 2014 17:58:44 +0300
In-Reply-To: <63604204.8DeBUXOvCl@wuerfel>
References: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
	 <1399557141-1346645-6-git-send-email-arnd@arndb.de>
	 <1399558909.8165.8.camel@iivanov-dev> <63604204.8DeBUXOvCl@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-08 at 16:27 +0200, Arnd Bergmann wrote:
> On Thursday 08 May 2014 17:21:49 Ivan T. Ivanov wrote:
> > > @@ -168,7 +168,7 @@ config USB_EHCI_HCD_AT91
> > >  
> > >  config USB_EHCI_MSM
> > >       tristate "Support for Qualcomm QSD/MSM on-chip EHCI USB controller"
> > > -     depends on ARCH_MSM
> > > +     depends on ARCH_MSM && RESET_CONTROLLER
> > 
> > This driver did not use reset controller API.
> > 
> > >       select USB_EHCI_ROOT_HUB_TT
> > >       select USB_MSM_OTG
> 
> It does select USB_MSM_OTG though, which uses it:
> 
> Maybe that 'select' is wrong?

Driver have run time dependency to USB_PHY framework.
Probably just removing  select line will be fine?

Regards,
Ivan



