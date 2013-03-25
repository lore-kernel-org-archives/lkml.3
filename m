Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab3CYNEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:04:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65377 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab3CYNEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:04:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCH 3/3] serial: of_serial: Handle hw-flow-control property
Date: Mon, 25 Mar 2013 13:04:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Ley Foon Tan <lftan@altera.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
References: <1364211286-31611-1-git-send-email-heikki.krogerus@linux.intel.com> <201303251247.58823.arnd@arndb.de> <20130325125757.GA2847@xps8300>
In-Reply-To: <20130325125757.GA2847@xps8300>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303251304.47559.arnd@arndb.de>
X-Provags-ID: V02:K0:ePP0hAkzuzOT8qEib1bMKZk/hqGZw3IJ1y4E1QA625C
 X/zGgjZMoPDJ5q45UocDWnJw/YPediwLHYv/kVIghqruS8CzJk
 cb2Dyx0W3wTt49CVJYeIy8F4IniwAZz6n4qrl95KuQyDkmCY/x
 sCnJ/BmDDt/ljtShvtMvafdTEKf6XKqimT0V5riIRmF1f8LovW
 8iz00kkhgsJou9ExWAnrHJR89SJWnRibSB7zxgPjBLjocHoKUY
 hZ6jxK2Qr0PSZfatLBbgXQwcF2rYvzUc35YR9wcO55BXro4XF4
 aATaGrN4jpdODqEtejp+nlEqk84sxZFluxCuJRf1lNFMBHHBP0
 W9uwir/qWA+gVJiHfHgk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 March 2013, Heikki Krogerus wrote:
> On Mon, Mar 25, 2013 at 12:47:58PM +0000, Arnd Bergmann wrote:
> > On Monday 25 March 2013, Heikki Krogerus wrote:
> > > On Mon, Mar 25, 2013 at 11:40:31AM +0000, Arnd Bergmann wrote:
> > > > On Monday 25 March 2013, Heikki Krogerus wrote:
> > > > > This will add support for hardware flow control. It is
> > > > > limited to be used only with 8250 driver.
> > > > > 
> > > > > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > > > 
> > > > Does this imply that we can use hardware flow control only when this
> > > > flag is set in the device tree? I assumed that working flow control
> > > > would be the default. Is it not?
> > > 
> > > OK, the commit message is wrong. Is the patch otherwise OK?
> > 
> > I still find the text in the binding and the name of the property confusing,
> > because it seems to imply that you have no hardware flow control without this.
> > I think what you mean here is really "automatic flow control" rather than
> > "hardware flow control".
> 
> Ah, I understand. I'll change the property name to auto-flow-control.
> 

Ok, sounds good. I would also suggest rewording the description in the
binding so that the driver is allowed to detect the presence of the automatic
flow control capability even if the property is not set, because that's
what the driver does.

	Arnd
