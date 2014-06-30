Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbaF3Op6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:45:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaF3Op4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:45:56 -0400
Date: Mon, 30 Jun 2014 07:45:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Richard Leitner <richard.leitner@skidata.com>
Cc: David Laight <David.Laight@ACULAB.COM>, Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] usb: gadget: serial: replace hardcoded ttyGS with
 PREFIX
Message-ID: <20140630144543.GA23566@kroah.com>
References: <20140627133721.10ca6cab@lxbuild.skidata.net>
 <20140627174628.GA1449@kroah.com>
 <20140630083205.596557f1@lxbuild.skidata.net>
 <20140630103616.620a13a2@lxbuild.skidata.net>
 <063D6719AE5E284EB5DD2968C1650D6D1726930B@AcuExch.aculab.com>
 <20140630105609.66d4be83@lxbuild.skidata.net>
 <063D6719AE5E284EB5DD2968C1650D6D1726935E@AcuExch.aculab.com>
 <20140630132327.39b9d4d2@lxbuild.skidata.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630132327.39b9d4d2@lxbuild.skidata.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 01:23:27PM +0200, Richard Leitner wrote:
> Hi,
> 
> On Mon, 30 Jun 2014 09:08:01 +0000
> David Laight <David.Laight@ACULAB.COM> wrote:
> 
> > > > From: Of Richard Leitner
> > > > > Replaces all hardcoded ttyGS strings with the PREFIX macro.
> > > > > Due to the fact the strings are spread over different source files the
> > > > > PREFIX definition is moved to u_serial.h
> > > >
> > > > Lots of changes like:
> > > > > -		DBG(cdev, "acm ttyGS%d completion, err %d\n",
> > > > > -				acm->port_num, req->status);
> > > > > +		DBG(cdev, "acm %s%d completion, err %d\n",
> > > > > +				PREFIX, acm->port_num, req->status);
> > > >
> > > > I'm not sure this improves the code.
> > > 
> > > Maybe you're right, the readability of the code wouldn't be better afterwards,
> 
> but as I already mentioned IMHO if there is such a macro it should be used everywhere or nowhere...
> 	
> > 
> > Indeed it will make most attempts to grep for the error message fail.
> 
> So your thought is to carve it out completely?
> 
> Are there any other opinions/ideas on that?

Use the "proper" debug macros that the kernel provides you (i.e.
dev_dbg() and family) and then you don't need to put the string in there
at all, the kernel will do it automatically for you, in the correct
format, so that all userspace tools can properly track what is going on.

So please remove the horrid DBG() macro entirely.

thanks,

greg k-h
