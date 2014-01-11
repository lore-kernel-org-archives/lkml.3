Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaAKQ0G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 11:26:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:32510 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbaAKQ0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 11:26:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,643,1384329600"; 
   d="scan'208";a="465181682"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>
Subject: RE: [char-misc 3/4] mei: revamp mei reset state machine
Thread-Topic: [char-misc 3/4] mei: revamp mei reset state machine
Thread-Index: AQHPDMkabu4aCRSzYUCkCb9zx5saRJp/uVag
Date: Sat, 11 Jan 2014 16:25:52 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF40E2C@HASMSX106.ger.corp.intel.com>
References: <1389205164-13553-1-git-send-email-tomas.winkler@intel.com>
 <1389205164-13553-4-git-send-email-tomas.winkler@intel.com>
 <20140108232649.GA21386@kroah.com>
In-Reply-To: <20140108232649.GA21386@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On Wed, Jan 08, 2014 at 08:19:23PM +0200, Tomas Winkler wrote:
> > 1. MEI_DEV_RESETTING device state spans only hardware reset flow
> > while starting dev state is saved into a local variable for further
> > reference, this let us to reduce big if statements in case we
> > are trying to avoid nested resets
> >
> > 2. During initializations if the reset ended in MEI_DEV_DISABLED device
> > state we bail out with -ENODEV
> >
> > 3. Remove redundant interrupts_enabled parameter as this
> >  can be deduced from the starting dev_state
> >
> > 4. mei_reset propagates error code to the caller
> >
> > 5. Add mei_restart function to wrap the pci resume
> >
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> > ---
> >  drivers/misc/mei/hbm.c       |   2 +-
> >  drivers/misc/mei/hw-me.c     |  10 +--
> >  drivers/misc/mei/init.c      | 210 ++++++++++++++++++++++++++-----------------
> >  drivers/misc/mei/interrupt.c |  13 +--
> >  drivers/misc/mei/mei_dev.h   |   3 +-
> >  drivers/misc/mei/pci-me.c    |  10 +--
> >  6 files changed, 143 insertions(+), 105 deletions(-)
> 
> This patch fails to apply to my tree:

Hmm, this is due to the blank line that was dropped (https://lkml.org/lkml/2013/7/29/668) , forgot to adjust it in my tree. 

> 
> Care to fix it up and resend?

On the way.

