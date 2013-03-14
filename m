Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934440Ab3CNQjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:39:12 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42588 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932487Ab3CNQjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:39:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Meyer <thomas@m3y3r.de>, Shawn Starr <shawn.starr@rogers.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [3.9-rc1] irq 16: nobody cared  (was [3.9-rc1] very poor interrupt responses)
Date: Thu, 14 Mar 2013 17:46:10 +0100
Message-ID: <1460519.ejNFI1DrGk@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc1+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <alpine.LNX.2.00.1303141709000.30118@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1303141050310.1983-100000@iolanthe.rowland.org> <alpine.LNX.2.00.1303141555090.30118@pobox.suse.cz> <alpine.LNX.2.00.1303141709000.30118@pobox.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 14, 2013 05:09:59 PM Jiri Kosina wrote:
> On Thu, 14 Mar 2013, Jiri Kosina wrote:
> 
> > > > I don't think I have seen this message on rc1+ (8343bce, to be precise), 
> > > > but I have definitely seen sluggish system response on that kernel as 
> > > > well.
> > > > 
> > > > Attaching lspci, /proc/interrupts and dmesg. 
> > > 
> > > Can you try to do a git bisect for this?  Is the sluggish system 
> > > response clear enough that you can tell reliably when it is present and 
> > > when it isn't?
> > 
> > That was my first thought, but unfortunately I am afraid there will be 
> > point at which I will easily make a bisection mistake, as the 
> > responsiveness of the system varies over time, so it's not really a 
> > 100% objective measure.
> 
> So I will try a bisect, but it'll take some time so that I could claim it 
> to be trustworthy.
> 
> Therefore in case anyone has any idea in parallel, I am all ears.

This one is a candidate to focus on I think:

commit 181380b702eee1a9aca51354d7b87c7b08541fcf
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Sat Feb 16 11:58:34 2013 -0700

    PCI/ACPI: Don't cache _PRT, and don't associate them with bus numbers

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
