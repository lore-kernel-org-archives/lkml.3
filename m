Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab3CNR1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:27:25 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:58671 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab3CNR1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:27:23 -0400
Message-ID: <1363282018.26318.10.camel@thor.lan>
Subject: Re: [3.9-rc1] irq 16: nobody cared  (was [3.9-rc1] very poor
 interrupt responses)
From: Peter Hurley <peter@hurleysoftware.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Kosina <jkosina@suse.cz>, Alan Stern <stern@rowland.harvard.edu>,
        Thomas Meyer <thomas@m3y3r.de>, Shawn Starr <shawn.starr@rogers.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Date: Thu, 14 Mar 2013 13:26:58 -0400
In-Reply-To: <5657408.cYX6iimiA4@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1303141050310.1983-100000@iolanthe.rowland.org>
	 <1460519.ejNFI1DrGk@vostro.rjw.lan> <1363280764.26318.4.camel@thor.lan>
	 <5657408.cYX6iimiA4@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-14 at 18:22 +0100, Rafael J. Wysocki wrote:
> On Thursday, March 14, 2013 01:06:04 PM Peter Hurley wrote:
> > On Thu, 2013-03-14 at 17:46 +0100, Rafael J. Wysocki wrote:
> > > On Thursday, March 14, 2013 05:09:59 PM Jiri Kosina wrote:
> > > > On Thu, 14 Mar 2013, Jiri Kosina wrote:
> > > > 
> > > > > > > I don't think I have seen this message on rc1+ (8343bce, to be precise), 
> > > > > > > but I have definitely seen sluggish system response on that kernel as 
> > > > > > > well.
> > > > > > > 
> > > > > > > Attaching lspci, /proc/interrupts and dmesg. 
> > > > > > 
> > > > > > Can you try to do a git bisect for this?  Is the sluggish system 
> > > > > > response clear enough that you can tell reliably when it is present and 
> > > > > > when it isn't?
> > > > > 
> > > > > That was my first thought, but unfortunately I am afraid there will be 
> > > > > point at which I will easily make a bisection mistake, as the 
> > > > > responsiveness of the system varies over time, so it's not really a 
> > > > > 100% objective measure.
> > > > 
> > > > So I will try a bisect, but it'll take some time so that I could claim it 
> > > > to be trustworthy.
> > > > 
> > > > Therefore in case anyone has any idea in parallel, I am all ears.
> > > 
> > > This one is a candidate to focus on I think:
> > > 
> > > commit 181380b702eee1a9aca51354d7b87c7b08541fcf
> > > Author: Yinghai Lu <yinghai@kernel.org>
> > > Date:   Sat Feb 16 11:58:34 2013 -0700
> > > 
> > >     PCI/ACPI: Don't cache _PRT, and don't associate them with bus numbers
> > 
> > This patch __fixed__ this problem for me in linux-next back in February.
> > 
> > Rafael, did you hold back some ACPI patches from 3.9 that would have
> > made fix no longer applicable?
> 
> No, I didn't.
> 
> I'm afraid, though, that the fix might not be effective on some systems for a
> reason that's unclear at the moment.
> 
> So in fact the one to check is commit 4f535093cf ("PCI: Put pci_dev in device
> tree as early as possible") and if the problem doesn't appear before that, we
> need to figure out why the fix may not be sufficient.

I agree. 

Commit 4f535093cf ("PCI: Put pci_dev in device tree as early as
possible") is the likely culprit, and "Don't cache _PRT..." is probably
an insufficient fix.

Not so sure about the other reporters though because they had active
devices on those USB ports.

Regards,
Peter Hurley


