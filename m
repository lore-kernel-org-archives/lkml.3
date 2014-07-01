Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbaGAHlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:41:52 -0400
Received: from mail1.skidata.com ([91.230.2.99]:49246 "EHLO mail1.skidata.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757397AbaGAHlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:41:51 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jul 2014 03:41:50 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqAEAEZjslOsEApK/2dsb2JhbABahDnFbAGBH3WEAwEBBScTPxALDQgMJQ9IBg4FiEfHYxePBweEQwEEmmCHMpASgi4
X-IPAS-Result: AqAEAEZjslOsEApK/2dsb2JhbABahDnFbAGBH3WEAwEBBScTPxALDQgMJQ9IBg4FiEfHYxePBweEQwEEmmCHMpASgi4
Date: Tue, 1 Jul 2014 09:31:49 +0200
From: Richard Leitner <richard.leitner@skidata.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: David Laight <David.Laight@ACULAB.COM>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] usb: gadget: serial: replace hardcoded ttyGS with
 PREFIX
Message-ID: <20140701093149.7bc71ff5@lxbuild.skidata.net>
In-Reply-To: <20140630144543.GA23566@kroah.com>
References: <20140627133721.10ca6cab@lxbuild.skidata.net>
	<20140627174628.GA1449@kroah.com>
	<20140630083205.596557f1@lxbuild.skidata.net>
	<20140630103616.620a13a2@lxbuild.skidata.net>
	<063D6719AE5E284EB5DD2968C1650D6D1726930B@AcuExch.aculab.com>
	<20140630105609.66d4be83@lxbuild.skidata.net>
	<063D6719AE5E284EB5DD2968C1650D6D1726935E@AcuExch.aculab.com>
	<20140630132327.39b9d4d2@lxbuild.skidata.net>
	<20140630144543.GA23566@kroah.com>
Organization: SKIDATA AG
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.60.30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 07:45:43 -0700
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> > > > > From: Of Richard Leitner
> > > > > > Replaces all hardcoded ttyGS strings with the PREFIX macro.
> > > > > > Due to the fact the strings are spread over different source files the
> > > > > > PREFIX definition is moved to u_serial.h
> > > > >
> > > > > Lots of changes like:
> > > > > > -		DBG(cdev, "acm ttyGS%d completion, err %d\n",
> > > > > > -				acm->port_num, req->status);
> > > > > > +		DBG(cdev, "acm %s%d completion, err %d\n",
> > > > > > +				PREFIX, acm->port_num, req->status);
> > > > >
> 
> Use the "proper" debug macros that the kernel provides you (i.e.
> dev_dbg() and family) and then you don't need to put the string in there
> at all, the kernel will do it automatically for you, in the correct
> format, so that all userspace tools can properly track what is going on.
> 
> So please remove the horrid DBG() macro entirely.
> 

It may be a clumsy question, but where do I get the device struct for the ttyGS from? (acm->port.ioport->port_tty ?!?)
The one for the USB gadget is cdev->gadget->dev if I've seen it correctly?

Thank you for your help!

regards,
richard
