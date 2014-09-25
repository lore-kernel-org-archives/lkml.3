Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaIYN2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:28:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46098 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaIYN2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:28:36 -0400
Date: Thu, 25 Sep 2014 14:28:28 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Thomas Shao <huishao@microsoft.com>
Cc: Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: Time keeps on slipping... on Hyper-V
Message-ID: <20140925132055.GA13108@sucs.org>
References: <1411451081-13423-1-git-send-email-huishao@microsoft.com>
 <20140923075610.GA10933@aepfle.de>
 <20140925060745.GA9450@sucs.org>
 <CD2CABCB2C0A0D4682C5F8AD84014154094643@HKXPRD3002MB006.064d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CD2CABCB2C0A0D4682C5F8AD84014154094643@HKXPRD3002MB006.064d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 09:40:42AM +0000, Thomas Shao wrote:
> > > On Tue, Sep 23, Thomas Shao wrote:
> > >
> > > with the host clock using host time sample. By default it is
> > > disabled, because we still recommend user to configure NTP for time
> >
> > -----Original Message-----
> > From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> > Sent: Thursday, September 25, 2014 2:08 PM
> >
> > You [Microsoft?] do? Can you link to public sources where is this stated
> 
> As far as I know, currently the document about time sync in Hyper-V is
> only for Windows. Below is a doc from MSDN:
> http://blogs.msdn.com/b/virtual_pc_guy/archive/2010/11/19/time-synchronization-in-hyper-v.aspx

That post is problematic and not quite enough because it doesn't say "we
recommend you always configure an external time source for a guest" but
rather gives a more complicated statement saying "because guest time
drifts we have a time synchronisation service that will sort things out.
If you happen to be running a domain controller we recommend you
configure regular synchronisation to an external time source in
addition". This leads to questions like: if my (Linux) guest's sole
purpose is to run a web server am I in the domain controller situation
(domain controllers have to re-serve time so perhaps they are special)?
It also doesn't cover the "clock drift is so bad ntpd can't correct it"
issue.

Have you seen this document on TechNet -
http://blogs.technet.com/b/enterprise_admin/archive/2010/04/04/linux-on-hyper-v-timesync.aspx
"With the new Integration Services, Linux virtual machines can! 

TimeSync means that you don’t have to hassle with configur[ing]
network-based time sync for your Linux VMs on Hyper-V…they can get the
correct time from the host!"

This document gives simpler advice looks quite compelling at first
glance.

> We are working on the document about Time Sync on Hyper-V to cover
> both Linux and Windows.

The sooner you can get such an official document out the better. All
sources of guest time synchronisation information (including Microsoft
blogs and non-Microsoft Q&A sites) need updating so they say the same
(correct!) thing in a clear way.

For the meantime can you state what you believe the recommend practice
is for Linux Hyper-V guests with regards to time synchronisation?

-- 
Sitsofe | http://sucs.org/~sits/
