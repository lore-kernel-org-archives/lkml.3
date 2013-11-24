Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab3KXA42 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 19:56:28 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58489 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755583Ab3KXA40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 19:56:26 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH] sysfs: handle duplicate removal attempts in sysfs_remove_group()
Date: Sun, 24 Nov 2013 02:09:09 +0100
Message-ID: <3805095.rqdZNnA0Ng@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2196420.QNWb3mfseF@vostro.rjw.lan>
References: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com> <20131123230701.GA6183@kroah.com> <2196420.QNWb3mfseF@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 24, 2013 12:36:03 AM Rafael J. Wysocki wrote:
> On Saturday, November 23, 2013 03:07:01 PM Greg Kroah-Hartman wrote:
> > On Sun, Nov 24, 2013 at 12:12:59AM +0100, Rafael J. Wysocki wrote:
> > > On Saturday, November 23, 2013 02:53:58 PM Greg Kroah-Hartman wrote:

[...]

> > > > 
> > > > I can revert Mika's patch, as it would be good to catch these kinds of
> > > > errors.
> > > 
> > > Then we'll need to untangle the SATA/SCSI mess triggered by Bjorn in
> > > https://bugzilla.kernel.org/show_bug.cgi?id=65281. ;-)
> > 
> > I have no objection to fixing that, the scsi sysfs handling is "odd" to
> > say the least...
> > 
> > If someone can unwind it, that would be great to see happen...
> 
> Well, if I'm bored to death during the xmas holidays, I may look into that.

In fact, I'm not exactly sure why ata_port_detach() calls ata_tport_delete()
before scsi_remove_host()?  Is there any particular reason?  Because that
doesn't seem to be exactly right ...

Rafael

