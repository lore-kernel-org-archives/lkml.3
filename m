Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbaKFP7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:59:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaKFP7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:59:38 -0500
Date: Thu, 6 Nov 2014 07:58:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [char-misc-next V3] mei: add reference counting for me clients
Message-ID: <20141106155828.GA20182@kroah.com>
References: <1415004125-5467-1-git-send-email-tomas.winkler@intel.com>
 <20141103235439.GA26158@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1C493153@HASMSX106.ger.corp.intel.com>
 <20141106022010.GD17253@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1C49677F@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1C49677F@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 08:40:21AM +0000, Winkler, Tomas wrote:
> > 
> > On Tue, Nov 04, 2014 at 05:22:51AM +0000, Winkler, Tomas wrote:
> > > >
> > > > On Mon, Nov 03, 2014 at 10:42:05AM +0200, Tomas Winkler wrote:
> > > > > To support dynamic addition/remove we add reference
> > > > > counter.
> > > >
> > > > What is keeping two different threads / cpus from grabbing a reference
> > > > at the same time the other one is dropping it?
> > > >
> > > > You have a list here, with no locking, right?  You also don't have any
> > > > locking for your kref, which isn't good at all...
> > > >
> > > > Please audit and fix up.
> > >
> > > Of course there is a lock, it wouldn't work at all. It is not explicit
> > > but we run under device_lock mutex.
> > 
> > Please make it explicit :)
> 
> Not sure what you mean by that? There is a lot of options in this laconic  sentence.

In looking at that patch, it was not obvious to me that any locking was
happening at all, so that needs to be addressed somehow before I can
accept the change.

thanks,

greg k-h
