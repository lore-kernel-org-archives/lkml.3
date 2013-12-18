Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3LRDkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 22:40:09 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44323 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3LRDkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 22:40:07 -0500
Date: Tue, 17 Dec 2013 19:40:04 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Rajat Jain <rajatjain@juniper.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Rajat Jain <rajatjain.linux@gmail.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Y@jasper.es
Subject: Re: [PATCH v3 4/8] pciehp: Don't disable the link permanently,
 during removal
Message-ID: <20131218034004.GA22858@roeck-us.net>
References: <52B0AEAD.6050604@gmail.com>
 <20131218010207.GC15119@google.com>
 <41c1723da4454cdca6503418746a5ca7@DM2PR05MB671.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41c1723da4454cdca6503418746a5ca7@DM2PR05MB671.namprd05.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 03:20:58AM +0000, Rajat Jain wrote:
> 
> 
> > -----Original Message-----
> > From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> > 
> > [+cc yinghai@kernel.org (seems to be Yinghai's preferred email]
> > 
> > On Tue, Dec 17, 2013 at 12:06:05PM -0800, Rajat Jain wrote:
> > > We need future link up events for hot-add, thus don't disable the link
> > > permanently during device removal. Also, remove the static functions
> > > that are now left unused.
> > 
> > The changelog should mention that this reverts part of 2debd9289997
> > ("PCI:
> > pciehp: Disable/enable link during slot power off/on").
> 
> Sure, I'll add that. 
> 
> > 
> > Yinghai, can you tell us whether this is an issue on your systems?
> >
> 
> Thanks in advance Yinghai. 
> 
> Actually I did not understand the original problem and the solution in the first
> place (so I also do not understand how might disabling of presence detect notification
> help). If you can give more details on the original problem that shall be great. Here
> is what I understood from the commit log:
> 
> The believe the HW looks like this:
> 
> PCIe port <----> Repeater <----> Device.
> 
> An in addition there is the presence detect pin that is connected directly from
> The port to the device. Now, when the device is plugged out, the pin indicates
> No presence. But are you saying the PCIe link from port to repeater is still up?
> 
> Part of log:
> ====================================
>     ...
>     It turns out the root complex is continually trying to train the link to
>     the repeater because the repeater has not been reset.
> 
>     This patch will disable the link at removal time to allow the repeater
>     to be reset properly.
>     ...
> ====================================
> 
> 1) I did not understand why would port try to retrain to the link in either cases -
> Whether the link to the repeater is up or not?
> 
> 2) When no link is seen, is THAT what causes repeater to go down and hence solve the
> Problem?
> 
> 3) I'd expect you'd continuously get "adapter not present" messages if some how
> The driver was trying to add the device. But I did not understand where did
> "adapter present" messages came from?
> 
> Sorry, but I guess I am totally confused now. I'll probably go to sleep :-) 
> 

What, that early ? :-)

I think we may have a similar setup on some of our boards. Maybe we can
reproduce the situation (after we understand what exactly it is and how to
trigger it).

Related to this patch set, I learned today that our Space product uses mpt2sas.
Just in case we need one for testing reset functionality.

Guenter
