Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaGUHen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 03:34:43 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:61930 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbaGUHem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 03:34:42 -0400
Date: Mon, 21 Jul 2014 09:34:30 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: <balbi@ti.com>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 0/9] usb: musb: several bugfixes for the musb driver
Message-ID: <20140721093430.3f528cc7@ipc1.ka-ro>
In-Reply-To: <20140718165044.GA30821@saruman.home>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
	<20140718161636.GA18460@arch.cereza>
	<20140718165044.GA30821@saruman.home>
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
> Hi,
> 
> On Fri, Jul 18, 2014 at 01:16:36PM -0300, Ezequiel Garcia wrote:
> > Hi Lothar,
> > 
> > On 18 Jul 11:31 AM, Lothar Waßmann wrote:
> > > The first three patches do some source code cleanup in the files that
> > > are modified in the subsequent patches.
> > > 
> > 
> > I've applied patches 4 and 9 on a recent -next, after fixing a conflict
> > due to patch 3 ("usb: musb_am335x: source cleanup"):
> > 
> > > Patch 4 carries the proper fix reported in commit:
> > >         7adb5c876e9c ("usb: musb: Fix panic upon musb_am335x module removal")
> > > 
> > > Patch 9 reinstates module unloading support for the musb_am335x driver
> > >         which was disabled due to a false failure analysis
> > > 
> > 
> > For these two patches, Tested-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> > 
> > Tested on a beaglebone with a mass storage USB device, module load/unload
> > works without issues. The module_get/put in the phy is now preventing the
> > musb_am335x driver unload, which seems to be the real cause of the issue
> > I reported. Thanks for providing a proper fix!
> 
> I don't that's a good fix. The problem is that even after am335x
> removing all its child, someone else tried to release the PHY. That
> ordering is the one that needs to be fixed. Doing a module_get on the
> parent device looks like a hack to me.
> 
No. It guarantees that the module cannot be unloaded when its resources
are still in use!


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
