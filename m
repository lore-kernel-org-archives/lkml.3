Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3BKM6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:58:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:5782 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab3BKM6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:58:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,643,1355126400"; 
   d="scan'208";a="284162406"
Date: Mon, 11 Feb 2013 13:58:36 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tomas Winkler <tomas.winkler@intel.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 03/11] mei: bus: Initial implementation for I/O
 routines
Message-ID: <20130211125836.GN20996@sortiz-mobl>
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com>
 <201302072234.44181.arnd@arndb.de>
 <20130207225510.GD5072@sortiz-mobl>
 <201302111152.42483.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302111152.42483.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Mon, Feb 11, 2013 at 11:52:42AM +0000, Arnd Bergmann wrote:
> On Thursday 07 February 2013, Samuel Ortiz wrote:
> > On Thu, Feb 07, 2013 at 10:34:44PM +0000, Arnd Bergmann wrote:
> > > On Thursday 07 February 2013, Tomas Winkler wrote:
> > > > +
> > > > +struct mei_bus_ops {
> > > > +       int (*send)(struct mei_bus_client *client, u8 *buf, size_t length);
> > > > +       int (*recv)(struct mei_bus_client *client, u8 *buf, size_t length);
> > > > +};
> > > > +
> > > 
> > > Can you have more than one set of mei_bus_ops in a driver? 
> > You can have at most one mei_bus_ops per mei_bus_client.
> > 
> > > If not, how about adding the callbacks to the mei_bus_driver structure
> > > directly as a simplification? 
> > I can add the ops directly to the mei_bus_client structure, yes.
> 
> I looked at the new version, and it's not what I assumed it would be.
> I thought the operations were specific to a client driver and should
> be part of the /mei_bus_driver/ structure, not the /mei_bus_client/.
The ops should be part of mei_bus_client as they're specific to the MEI
protocol for a given IP block on the ME. You need to have MEI and HECI
knowledge to implement those ops and drivers (defining their mei_bus_driver
structure) should not have that kind of knowledge but rather focus on the
technology they're driving.
If we take the NFC example again, the drivers/nfc/ code will send NFC payloads
to the bus I/O routines and this is where the mei_bus_client ops will add the
ME specific protocol (command and request id for the NFC block) on top of it.
In practice, this is an additional header which handles a transport layer that's
specific not only to the ME but to the NFC block of it. So each ME block can
have its own protocol to send and receive technology specific payloads, that's
what those ops implement.
That's why I think that those ops should not be defined by the drivers/nfc/ code
and in fact should be opaque to it.


> Did I misunderstand what these functions do, or did you misunderstand
> what I was asking for?
Probably both. I really thought you were looking for a structure cleanup by
directly putting the ops into the mei_bus_client structure.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
