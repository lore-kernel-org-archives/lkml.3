Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaAPBwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:52:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbaAPBwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:52:12 -0500
Date: Thu, 16 Jan 2014 09:52:33 +0800
From: Dave Young <dyoung@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, wim@iguana.be,
        dzickus@redhat.com, bhe@redhat.com, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: add a parameter for stop wdt before register
Message-ID: <20140116015233.GC3807@dhcp-16-126.nay.redhat.com>
References: <20140114082323.GA4485@dhcp-16-126.nay.redhat.com>
 <20140114121639.77fe75ec@alan.etchedpixels.co.uk>
 <20140115005931.GB23767@dhcp-16-126.nay.redhat.com>
 <20140115121556.0407a099@alan.etchedpixels.co.uk>
 <20140115165512.GD3180@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115165512.GD3180@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/14 at 11:55am, Vivek Goyal wrote:
> On Wed, Jan 15, 2014 at 12:15:56PM +0000, One Thousand Gnomes wrote:
> > > watchdog and crash dump really conflicts to some degree, from the watchdog
> > > point of view it can reboot system whhen kdump kernel hangs. But from kdump
> > > point of view it want ensure saving the vmcore for later debugging.
> > > 
> > > Maybe we can only select only one in this case.
> > 
> > You want to be able to make a decision at runtime which to use.
> > 
> > > > - if it can be stopped, you can open and stop it
> > > 
> > > For the last one since crashing happens we have no chance to open and stop.
> > 
> > When you decide you need to set up to catch a core rather than just
> > crash you can open and stop the watchdog (if supported), and you can then
> > set up for a kdump and then at some point later if it crashes capture the
> > dump.
> 
> Disabling watchdog if kdump serice starts will not make many happy. If
> kernel hangs, we don't have a functionality to reboot it.
> 
> What about other idea of keeping watchdog interval long enough that new
> kernel can boot, driver can load and then new driver/user space can
> continue to kick the watchdog. And if second kernel hangs, watchdog will
> reboot the system.

I would agree this way.

Thanks
Dave
