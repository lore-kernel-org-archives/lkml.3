Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbaG1GJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:09:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaG1GJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:09:39 -0400
Date: Sun, 27 Jul 2014 23:09:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, robh@kernel.org,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: REVERT request for  patch "ARC: [arcfpga] stdout-path now
 suffices for earlycon/console" added to tty tree
Message-ID: <20140728060913.GA27827@kroah.com>
References: <14050323662165@kroah.com>
 <53D5D527.30501@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D5D527.30501@synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 10:14:23AM +0530, Vineet Gupta wrote:
> Hi Greg,
> 
> On Friday 11 July 2014 04:11 AM, gregkh@linuxfoundation.org wrote:
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     ARC: [arcfpga] stdout-path now suffices for earlycon/console
> > 
> > to my tty git tree which can be found at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
> > in the tty-next branch.
> > 
> > The patch will show up in the next release of the linux-next tree
> > (usually sometime within the next 24 hours during the week.)
> > 
> > The patch will also be merged in the next major kernel release
> > during the merge window.
> > 
> > If you have any questions about this process, please let me know.
> > 
> > 
> >>From 9da433c0a0b5f71ac92dc9dca778295649675f08 Mon Sep 17 00:00:00 2001
> > From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
> > Date: Tue, 24 Jun 2014 13:55:15 +0530
> > Subject: ARC: [arcfpga] stdout-path now suffices for earlycon/console
> > 
> > With recent improvements to serial/of core from Grant and Rob,
> > stdout-path alone suffices for setting up earlycon/console.
> > 
> > arc_uart driver is already equipped to handle that, switch the DT now.
> > 
> > Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> > Reviewed-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  arch/arc/boot/dts/angel4.dts | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arc/boot/dts/angel4.dts b/arch/arc/boot/dts/angel4.dts
> > index 6b57475967a6..298a46daa633 100644
> > --- a/arch/arc/boot/dts/angel4.dts
> > +++ b/arch/arc/boot/dts/angel4.dts
> > @@ -17,7 +17,8 @@
> >  	interrupt-parent = <&intc>;
> >  
> >  	chosen {
> > -		bootargs = "earlycon=arc_uart,mmio32,0xc0fc1000,115200n8 console=ttyARC0,115200n8";
> > +		bootargs = "earlycon";
> > +		stdout-path = &arcuart0;
> >  	};
> >  
> >  	aliases {
> > 
> 
> Could you please revert this single patch from tty-next for 3.17 as the needed
> core changes are not yet finalized.

Now reverted.
