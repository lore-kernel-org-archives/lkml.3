Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab3COH7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 03:59:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48096 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551Ab3COH7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 03:59:13 -0400
Date: Fri, 15 Mar 2013 08:59:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, Thomas Meyer <thomas@m3y3r.de>,
        Shawn Starr <shawn.starr@rogers.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [3.9-rc1] irq 16: nobody cared  (was [3.9-rc1] very poor interrupt
 responses)
In-Reply-To: <5657408.cYX6iimiA4@vostro.rjw.lan>
Message-ID: <alpine.LNX.2.00.1303150851020.9529@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1303141050310.1983-100000@iolanthe.rowland.org> <1460519.ejNFI1DrGk@vostro.rjw.lan> <1363280764.26318.4.camel@thor.lan> <5657408.cYX6iimiA4@vostro.rjw.lan>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Mar 2013, Rafael J. Wysocki wrote:

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

With either 4f535093cf or 181380b702 I do *not* see the problem, i.e. 
these commits are not the culprit and it was caused by some later change.

I will proceed with bisect now, hopefully it'll produce a meaningful 
result.

-- 
Jiri Kosina
SUSE Labs
