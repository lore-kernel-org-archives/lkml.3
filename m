Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbaIITOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:14:04 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:36354 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaIITOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:14:01 -0400
Date: Tue, 9 Sep 2014 21:13:57 +0200
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: Bill Pemberton <wfp5p@worldbroken.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        lidza.louina@gmail.com, cascardo@linux.vnet.ibm.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v2 0/2] Move Digi Neo card support from dgnc to jsm
Message-ID: <20140909191357.GA13118@t400>
References: <1409430958-2692-1-git-send-email-wfp5p@worldbroken.com>
 <20140908201700.GA28282@kroah.com>
 <540E10C3.2080805@worldbroken.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540E10C3.2080805@worldbroken.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08, Bill Pemberton wrote:
> On 09/08/2014 04:17 PM, Greg KH wrote:
> >On Sat, Aug 30, 2014 at 04:35:56PM -0400, wfp5p@worldbroken.com wrote:
> >>From: Bill Pemberton <wfp5p@worldbroken.com>
> >>
> >>The jsm driver (drivers/tty/serial/jsm) already supports the Digi Neo
> >>cards that dgnc (staging) supports.  In fact, it appears that jsm was
> >>based on dgnc.  The dgnc driver has PCI ids for more cards than jsm,
> >>this patch moves support for all the Neo cards to jsm.
> >>
> >>The result of this will be that dgnc will only support the Classic
> >>cards since the jsm driver doesn't support those cards yet.
> >>
> >>
> >>Bill Pemberton (2):
> >>   jsm: add support for additional Neo cards
> >>   staging: dgnc: remove Neo card ids from device table
> >>
> >>  drivers/staging/dgnc/dgnc_driver.c  | 13 -------------
> >>  drivers/tty/serial/jsm/jsm.h        | 10 ++++++++++
> >>  drivers/tty/serial/jsm/jsm_driver.c | 38 +++++++++++++++++++++++++++++++++----
> >>  3 files changed, 44 insertions(+), 17 deletions(-)
> >
> >These are now applied, thanks.
> >
> >Do you think we can delete the dgnc driver now, or are there still some
> >odd cards out there that it only supports?  What would it take to move
> >that support to the jsm driver instead?
> >
> 
> The jsm driver still doesn't support the Classic cards, just the Neo
> cards so dgnc would still be needed to support those cards.
> 
> I think the right thing would be to put the Classic support into
> jsm. I've started looking at that.  Dgnc and jsm are obviously from
> the same base, so dgnc can be used as guide on what to do.  However,
> I don't have a Classic card so I wouldn't be able to test any of the
> Classic support.

I have been working on the dgnc driver for a while now so I add what I
know to this thread.

Bill is right that the jsm and dgnc drivers have the same base, in fact
it seems that the jsm driver is the dgnc driver modified in 2005 by the
kernel folks to be good enough to be accepted. The scope of changes was
to adjust the code to use proper coding style and proper Kernel APIs
plus the ioctls and sysfs stuff was removed as not needed. The dgnc
which is a direct import from the Digi has this features as they are
needed by the Digi folks and their customers (old scripts like the old
APIs).

>From what I know so far about these drivers adding support for the
Classic boards to the jsm driver should not be a big issue. It [more or
less] boils down to adding jsm_cls [aka dgnc_cls] files and having the
logic to assign the proper structure during board discovery.

Would be great to find someone with the Classic card to test it. I tried
to find one but it is damn hard to get.

Hope this helps.

/Konrad
 
> -- 
> Bill
> 
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
