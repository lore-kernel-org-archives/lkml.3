Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaHOUF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 16:05:27 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:50972 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaHOUF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 16:05:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: location for new bus driver-- drivers/bus? drivers/misc?
Date: Fri, 15 Aug 2014 22:05:18 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Stuart Yoder <stuart.yoder@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Rivera <German.Rivera@freescale.com>,
        Olof Johansson <olof@lixom.net>
References: <9953b08b77224e738a1a1672dcf209c5@BY2PR0301MB0743.namprd03.prod.outlook.com> <20140811183720.GC32566@kroah.com>
In-Reply-To: <20140811183720.GC32566@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201408152205.18871.arnd@arndb.de>
X-Provags-ID: V02:K0:awEXJDjut4PyGjRQ5eMnAjKodzqmP5youA04SuCipHS
 LE9tbUNpopMSsixE7KVchEI5CByI1aFRnjJQb3jpykvNlYlzVm
 +XaiGIgwTSRKhqapo3t+u+Jz47rq0keSXBD5vF60Hw/W4dmSWV
 jjfwSQO/YxiB3nHojRDpOq0OycnBYOm9sfDV0ghrcXOSdaW34z
 R2RjrMOZdMJHi2vZ13eYyp8OXmX19jcrAgeMqfKbhMPZopVL4v
 2RXPHNBOq+0paxukRGrbjx0f98yyxCEwfwnWQZgzsSgK/3kX5K
 mw1/ZL8NyJGKlGt0zE99LB7nFhHOrB20c8lwyjxqDV29D4Xkv6
 ja515bhJ6ApeAlzcTH04=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 August 2014, gregkh@linuxfoundation.org wrote:
> On Mon, Aug 11, 2014 at 04:25:49PM +0000, Stuart Yoder wrote:
> > Greg,
> > 
> > We (Freescale) have a patch series nearly ready to send out
> > for a new bus driver.  It's for a block we call the Freescale
> > 'Management Complex' which manages discoverable hardware objects.
> > The Linux bus driver enumerates these objects, binds discovered
> > objects to drivers just like PCI or any normal bus driver.
> 
> Sounds good.
> 
> > Question is-- where should this go in the kernel and who would
> > the maintainer be to cc: the RFC?  I don't think it warrants
> > a top level driver directory beside pci, usb, etc.  Most likely
> > place is drivers/bus or drivers/misc (?).
> > 
> > We currently have it in drivers/bus, but as far as I can see
> > there is no maintainer per se for that directory.  You and 
> > Arnd manage misc so thought I would ask.
> 
> I don't remember why drivers/bus/ came about, Arnd, you created it,
> should we be putting random bus controllers in this directory?

I think it would be good to have this new driver in drivers/bus.

So far, I think all code in there has been merged through the
arm-soc tree, mainly because there is no other maintainer for it
yet. The drivers we have in there are not all the same kind,
the commonality ends at the point of being something that can
be considered a bus (so it fits here better than into MFD or misc)
and not being large enough to justify its own top-level directory.

I initially suggested actually moving some of the existing top-level
directories with simple bus drivers here too, but that was a bit
controversial, so I never followed up on that.

> And if so, sure, I can maintain drivers/bus/ along with the misc/char
> drivers, it's not a big deal.

Sounds good, I'd be glad to have you listed as the official maintainer
so we can hand it off from the inofficial arm-soc adoption, and if it's
listed as part of the char/misc section, I will also be listed by
scripts/get_maintainer.pl to do reviews.

	Arnd
