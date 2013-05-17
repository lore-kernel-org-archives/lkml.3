Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3EQFtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 01:49:07 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:64395 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab3EQFtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 01:49:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130516225535.GA27962@google.com>
References: <CANUX_P2Hy02SnyYS24dyUGLv3wB3L5xkXt8Y1s+8_RG9d5ReAw@mail.gmail.com>
	<CAErSpo6OCyTy19u6Xaf=xr0TSDriwCD3n-oMc7eJyLzuJ9d60g@mail.gmail.com>
	<20130510225257.GA10847@google.com>
	<1725435.3DlCxYF2FV@vostro.rjw.lan>
	<1368303730.2425.47.camel@x230>
	<20130516225535.GA27962@google.com>
Date: Fri, 17 May 2013 08:49:01 +0300
Message-ID: <CANUX_P2YJC+dULEpa0SJ8Ug+ROZ+RVGNg0FS5b_eYD260mAC=Q@mail.gmail.com>
Subject: Re: is L1 really disabled in iwlwifi
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        John Linville <linville@tuxdriver.com>,
        Roman Yepishev <roman.yepishev@gmail.com>,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Mike Miller <mike.miller@hp.com>,
        "iss_storagedev@hp.com" <iss_storagedev@hp.com>,
        Guo-Fu Tseng <cooldavid@cooldavid.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "nic_swsd@realtek.com" <nic_swsd@realtek.com>,
        "aacraid@adaptec.com" <aacraid@adaptec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I couldn't imagine that silently ignoring the request to disable ASPM
> would be the right thing, but I spent a long time experimenting with
> Windows on qemu, and I think you're right.  Windows 7 also seems to
> ignore the "PciASPMOptOut" directive when we don't have permission
> to manage ASPM.  All the gory details are at
> https://bugzilla.kernel.org/show_bug.cgi?id=57331
>
> The current behavior is definitely confusing.  I hate to rename or change
> pci_disable_link_state() because it's exported and we'd have to maintain
> the old interface for a while anyway.  And I don't really want to return
> failure to drivers, because I think that would encourage people to fiddle
> with the Link Control register directly in the driver, which doesn't seem
> like a good idea.
>
> And you're also right that (as far as I know) there's not an actual
> problem with the current behavior other than the confusion it causes.
>
> So, how about something like the following patch, which just prints a
> warning when we can't do what the driver requested?  I suppose this may
> also be a nuisance, because users will be worried, but they can't actually
> *do* anything about it.  Maybe it should be dev_info() instead.
>

Good for me - now I would be notified that something wrong happened.
