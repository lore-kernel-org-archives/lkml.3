Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3KXPGA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 10:06:00 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:52564 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab3KXPF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 10:05:56 -0500
Date: Sun, 24 Nov 2013 10:05:52 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Gwendal Grignou <gwendal@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH] sysfs: handle duplicate removal attempts in
 sysfs_remove_group()
Message-ID: <20131124150552.GB22740@htj.dyndns.org>
References: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com>
 <20131123230701.GA6183@kroah.com>
 <2196420.QNWb3mfseF@vostro.rjw.lan>
 <3805095.rqdZNnA0Ng@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3805095.rqdZNnA0Ng@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Gwendal, hi!)

On Sun, Nov 24, 2013 at 02:09:09AM +0100, Rafael J. Wysocki wrote:
> On Sunday, November 24, 2013 12:36:03 AM Rafael J. Wysocki wrote:
> > On Saturday, November 23, 2013 03:07:01 PM Greg Kroah-Hartman wrote:
> > > On Sun, Nov 24, 2013 at 12:12:59AM +0100, Rafael J. Wysocki wrote:
> > > > On Saturday, November 23, 2013 02:53:58 PM Greg Kroah-Hartman wrote:
> 
> [...]
> 
> > > > > 
> > > > > I can revert Mika's patch, as it would be good to catch these kinds of
> > > > > errors.
> > > > 
> > > > Then we'll need to untangle the SATA/SCSI mess triggered by Bjorn in
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=65281. ;-)
> > > 
> > > I have no objection to fixing that, the scsi sysfs handling is "odd" to
> > > say the least...
> > > 
> > > If someone can unwind it, that would be great to see happen...
> > 
> > Well, if I'm bored to death during the xmas holidays, I may look into that.
> 
> In fact, I'm not exactly sure why ata_port_detach() calls ata_tport_delete()
> before scsi_remove_host()?  Is there any particular reason?  Because that
> doesn't seem to be exactly right ...

No idea.  Gwendal?

Thanks.

-- 
tejun
