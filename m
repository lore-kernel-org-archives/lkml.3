Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaCHV6r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 16:58:47 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56894 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaCHV6q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 16:58:46 -0500
Date: Sat, 8 Mar 2014 21:57:48 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: =?UTF-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-serial@vger.kernel.org>
Subject: Re: [PATCH RFC v2 04/11] tty: xuartps: Remove bogus comment and
 register write
Message-ID: <20140308215748.4889aed8@alan.etchedpixels.co.uk>
In-Reply-To: <e074f376-9565-422e-abee-fdaa031239a1@TX2EHSMHS043.ehs.local>
References: <1394219614-3197-1-git-send-email-soren.brinkmann@xilinx.com>
	<1394219614-3197-5-git-send-email-soren.brinkmann@xilinx.com>
	<20140307212816.715e5e19@alan.etchedpixels.co.uk>
	<e074f376-9565-422e-abee-fdaa031239a1@TX2EHSMHS043.ehs.local>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2014 15:08:00 -0800
Sören Brinkmann <soren.brinkmann@xilinx.com> wrote:

> On Fri, 2014-03-07 at 09:28PM +0000, One Thousand Gnomes wrote:
> > On Fri,  7 Mar 2014 11:13:27 -0800
> > Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:
> > 
> > > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > > ---
> > >  drivers/tty/serial/xilinx_uartps.c | 6 +-----
> > >  1 file changed, 1 insertion(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
> > > index a4bd6242e72d..a39c2d290902 100644
> > > --- a/drivers/tty/serial/xilinx_uartps.c
> > > +++ b/drivers/tty/serial/xilinx_uartps.c
> > > @@ -1082,11 +1082,7 @@ static void xuartps_console_write(struct console *co, const char *s,
> > >  
> > >  	xuartps_writel(ctrl, XUARTPS_CR_OFFSET);
> > >  
> > > -	/* restore interrupt state, it seems like there may be a h/w bug
> > > -	 * in that the interrupt enable register should not need to be
> > > -	 * written based on the data sheet
> > > -	 */
> > > -	xuartps_writel(~imr, XUARTPS_IDR_OFFSET);
> > > +	/* restore interrupt state */
> > 
> > It would be appropriate for the changelog at least to explain why the
> > note about the data sheet differing is going away !
> 
> I don't know why anybody ever thought things are broken. IMHO, the
> comment does not make any sense. Why would it not be required to write
> the enable register when you enable interrupts?
> I think someone read the data sheet wrong.

The comment reads very much like John Linn added it after trying to debug
a problem in real hardware. As such I think it warrants a bit more
calling out than a silent removal. That way if someone does find there is
a hardware bug (or some software race we don't understand) they will be
able to find the regression easily in the git log.

Alan
