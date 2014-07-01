Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbaGAPj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:39:57 -0400
Received: from mail1.skidata.com ([91.230.2.99]:31499 "EHLO mail1.skidata.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbaGAPj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:39:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtQFAG7VslOsEApK/2dsb2JhbABahCwBAQvGAQGBI3WEAwEBBAEnEz8FCwsNCAMJJQ9IBg4FG4gfDchzF48fB4RDAQSaZIczkBWCLg
X-IPAS-Result: AtQFAG7VslOsEApK/2dsb2JhbABahCwBAQvGAQGBI3WEAwEBBAEnEz8FCwsNCAMJJQ9IBg4FG4gfDchzF48fB4RDAQSaZIczkBWCLg
Date: Tue, 1 Jul 2014 17:39:51 +0200
From: Richard Leitner <richard.leitner@skidata.com>
To: Richard Leitner <richard.leitner@skidata.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Laight <David.Laight@ACULAB.COM>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] usb: gadget: serial: replace hardcoded ttyGS with
 PREFIX
Message-ID: <20140701173951.410af386@lxbuild.skidata.net>
In-Reply-To: <20140701093149.7bc71ff5@lxbuild.skidata.net>
References: <20140627133721.10ca6cab@lxbuild.skidata.net>
	<20140627174628.GA1449@kroah.com>
	<20140630083205.596557f1@lxbuild.skidata.net>
	<20140630103616.620a13a2@lxbuild.skidata.net>
	<063D6719AE5E284EB5DD2968C1650D6D1726930B@AcuExch.aculab.com>
	<20140630105609.66d4be83@lxbuild.skidata.net>
	<063D6719AE5E284EB5DD2968C1650D6D1726935E@AcuExch.aculab.com>
	<20140630132327.39b9d4d2@lxbuild.skidata.net>
	<20140630144543.GA23566@kroah.com>
	<20140701093149.7bc71ff5@lxbuild.skidata.net>
Organization: SKIDATA AG
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.60.30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2014 09:31:49 +0200
Richard Leitner <richard.leitner@skidata.com> wrote:

> On Mon, 30 Jun 2014 07:45:43 -0700
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > > > > > From: Of Richard Leitner
> > > > > > > Replaces all hardcoded ttyGS strings with the PREFIX macro.
> > > > > > > Due to the fact the strings are spread over different source files the
> > > > > > > PREFIX definition is moved to u_serial.h
> > > > > >
> > > > > > Lots of changes like:
> > > > > > > -		DBG(cdev, "acm ttyGS%d completion, err %d\n",
> > > > > > > -				acm->port_num, req->status);
> > > > > > > +		DBG(cdev, "acm %s%d completion, err %d\n",
> > > > > > > +				PREFIX, acm->port_num, req->status);
> > > > > >
> > 
> > Use the "proper" debug macros that the kernel provides you (i.e.
> > dev_dbg() and family) and then you don't need to put the string in there
> > at all, the kernel will do it automatically for you, in the correct
> > format, so that all userspace tools can properly track what is going on.
> > 
> > So please remove the horrid DBG() macro entirely.
I'll prepare a patch for that...

But that doesn't solve my original problem with the hardcoded "ttyGS"...

>
> [...] where do I get the device struct for the ttyGS from?

In u_serial with something like:

-	pr_debug("gs_open: ttyGS%d (%p,%p)\n", port->port_num, tty, file);
+	pr_debug("gs_open: %s (%p,%p)\n", dev_name(tty->dev), tty, file);

Or is there a better approach?

What will be a good solution for f_acm/f_obex instead of PREFIX? Or should PREFIX be renamed and used?

Thanks for your help and patience!

regards,
richard
