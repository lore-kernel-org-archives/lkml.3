Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbaKFTHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 14:07:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:43962 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaKFTHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 14:07:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,327,1413270000"; 
   d="scan'208";a="632842421"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next V3] mei: add reference counting for me clients
Thread-Topic: [char-misc-next V3] mei: add reference counting for me clients
Thread-Index: AQHP98GSdwWugMUfYUCeAzEHcOfoj5xP6kKwgALVFACAAHVl8IAAbzwAgABShkA=
Date: Thu, 6 Nov 2014 19:05:57 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1C496DAE@HASMSX106.ger.corp.intel.com>
References: <1415004125-5467-1-git-send-email-tomas.winkler@intel.com>
 <20141103235439.GA26158@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1C493153@HASMSX106.ger.corp.intel.com>
 <20141106022010.GD17253@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1C49677F@HASMSX106.ger.corp.intel.com>
 <20141106155828.GA20182@kroah.com>
In-Reply-To: <20141106155828.GA20182@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, November 06, 2014 17:58
> To: Winkler, Tomas
> Cc: arnd@arndb.de; linux-kernel@vger.kernel.org
> Subject: Re: [char-misc-next V3] mei: add reference counting for me clients
> 
> On Thu, Nov 06, 2014 at 08:40:21AM +0000, Winkler, Tomas wrote:
> > >
> > > On Tue, Nov 04, 2014 at 05:22:51AM +0000, Winkler, Tomas wrote:
> > > > >
> > > > > On Mon, Nov 03, 2014 at 10:42:05AM +0200, Tomas Winkler wrote:
> > > > > > To support dynamic addition/remove we add reference
> > > > > > counter.
> > > > >
> > > > > What is keeping two different threads / cpus from grabbing a reference
> > > > > at the same time the other one is dropping it?
> > > > >
> > > > > You have a list here, with no locking, right?  You also don't have any
> > > > > locking for your kref, which isn't good at all...
> > > > >
> > > > > Please audit and fix up.
> > > >
> > > > Of course there is a lock, it wouldn't work at all. It is not explicit
> > > > but we run under device_lock mutex.
> > >
> > > Please make it explicit :)
> >
> > Not sure what you mean by that? There is a lot of options in this laconic
> sentence.
> 
> In looking at that patch, it was not obvious to me that any locking was
> happening at all, so that needs to be addressed somehow before I can
> accept the change.

I understand the concern though we are using a BIG driver mutex so no additional locking is required, we are already locked. 
Currently we didn't hit any performance issue that required more fine grained locking but let say this is something we aware and that might  happen in the future. 

Thanks
Tomas

