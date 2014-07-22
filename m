Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaGVIGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:06:33 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:53927 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaGVIGb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:06:31 -0400
Date: Tue, 22 Jul 2014 10:06:13 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 8/9] usb: phy: am335x: call
 usb_gen_phy_init()/usb_gen_phy_shutdown() in
 am335x_init()/am335x_shutdown()
Message-ID: <20140722100613.779a3e11@ipc1.ka-ro>
In-Reply-To: <20140721151043.GF6852@saruman.home>
References: <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
	<1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
	<1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
	<1405675890-8802-5-git-send-email-LW@KARO-electronics.de>
	<1405675890-8802-6-git-send-email-LW@KARO-electronics.de>
	<1405675890-8802-7-git-send-email-LW@KARO-electronics.de>
	<1405675890-8802-8-git-send-email-LW@KARO-electronics.de>
	<1405675890-8802-9-git-send-email-LW@KARO-electronics.de>
	<20140718135713.GH24914@saruman.home>
	<20140721100307.21172b65@ipc1.ka-ro>
	<20140721151043.GF6852@saruman.home>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Felipe Balbi wrote:
> Hi,,
> 
> On Mon, Jul 21, 2014 at 10:03:07AM +0200, Lothar Waßmann wrote:
> > Hi,
> > 
> > > On Fri, Jul 18, 2014 at 11:31:29AM +0200, Lothar Waßmann wrote:
> > > > This patch makes it possible to use the musb driver with HW that
> > > > requires external regulators or clocks.
> > > 
> > > can you provide an example of such HW ? Are you not using the internal
> > > PHYs ?
> > > 
> > The Ka-Ro electronics TX48 module uses the mmc0_clk pin as VBUSEN
> > rathern than usb0_drvvbus. This patch makes it possible to use an
> > external regulator to handle the VBUS switch through the 'vcc-supply'
> > property of the underlying generic_phy device.
> 
> OK, I get it now. But why would not use usb0_drvvbus ? You could still
> route usb0_drvvbus to the regulator enable pin and the regulator would
> be enabled for you once correct values are written to the IP's mailbox.
> 
> I suppose this has something to do with layout constraints ?
> 
Yes. The usb0_drvvbus is used for a different purpose.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
