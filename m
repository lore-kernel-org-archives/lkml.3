Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaJ0MSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:18:37 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37805 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaJ0MSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:18:36 -0400
Date: Mon, 27 Oct 2014 17:48:28 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: rtl8712: remove unused variables
Message-ID: <20141027121828.GB5369@sudip-PC>
References: <1414326813-21444-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20141027111312.GA6879@mwanda>
 <20141027115221.GA5369@sudip-PC>
 <20141027121256.GF6879@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027121256.GF6879@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 03:12:57PM +0300, Dan Carpenter wrote:
> On Mon, Oct 27, 2014 at 05:22:21PM +0530, Sudip Mukherjee wrote:
> > On Mon, Oct 27, 2014 at 02:13:12PM +0300, Dan Carpenter wrote:
> > > On Sun, Oct 26, 2014 at 06:03:33PM +0530, Sudip Mukherjee wrote:
> > > > @@ -262,7 +257,7 @@ static u8 rtl8712_dl_fw(struct _adapter *padapter)
> > > >  		if (tmp8_a != (tmp8|BIT(2)))
> > > >  			goto exit_fail;
> > > >  
> > > > -		tmp32 = r8712_read32(padapter, TCR);
> > > > +		r8712_read32(padapter, TCR);
> > > 
> > > I wonder if we actually need to call r8712_read32() here?  It's not
> > > clear.  The changelog should say one way or the other.  Maybe something
> > > like "I left a call to r8712_read32(padapter, TCR) because I didn't know
> > > if it had side effects".  When you note down questions you have in the
> > > changelog that helps reviewers.
> > sure. i will resend it with modified commit log.
> > r8712_read32() is ultimately calling usb_read32() which is again calling  r8712_usbctrl_vendorreq().
> > this r8712_usbctrl_vendorreq() is communicating through the usb bus and is sending and receiving the control msg.
> > that is why i didnot remove it.
> 
> Yeah.  I'm 95% sure it's not needed, but I suppose it's better to err
> on the side of caution.
i have already sent the v2 with modified commit log.

thanks
sudip

> 
> regards,
> dan carpenter
> 
