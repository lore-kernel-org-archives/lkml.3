Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaBXXSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 18:18:55 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52183 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752998AbaBXXSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 18:18:53 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/2] PCI / PM: Resume runtime-suspended devices later during system suspend
Date: Tue, 25 Feb 2014 00:33:51 +0100
Message-ID: <1759353.q92oO0bmJQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAErSpo5rX=1YnAR8QZYLsww-1c4_KvAgEZEkkQ5C26=+cEYqFw@mail.gmail.com>
References: <1853950.oxM3KDpyLu@vostro.rjw.lan> <3851541.s2776YTCMH@vostro.rjw.lan> <CAErSpo5rX=1YnAR8QZYLsww-1c4_KvAgEZEkkQ5C26=+cEYqFw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 24, 2014 01:58:05 PM Bjorn Helgaas wrote:
> On Sun, Feb 23, 2014 at 4:21 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Runtime-suspended devices are resumed during system suspend by
> > pci_pm_prepare() for two reasons: First, because they may need
> > to be reprogrammed in order to change their wakeup settings and,
> > second, because they may need to be operatonal for their children
> > to be successfully suspended.  That is a problem, though, if there
> > are many runtime-suspended devices that need to be resumed this
> > way during system suspend, because the .prepare() PM callbacks of
> > devices are executed sequentially and the times taken by them
> > accumulate, which may increase the total system suspend time quite
> > a bit.
> >
> > For this reason, move the resume of runtime-suspended devices up
> > to the next phase of device suspend (during system suspend), except
> > for the ones that have power.ignore_children set.  The exception is
> > made, because the devices with power.ignore_children set may still
> > be necessary for their children to be successfully suspended (during
> > system suspend) and they won't be resumed automatically as a result
> > of the runtime resume of their children.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> You can merge these two via your tree if you want.  I don't have any
> changes queued up for pci-driver.c.

I will, thanks!

Rafael

