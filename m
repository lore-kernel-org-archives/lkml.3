Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab3BLUUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:20:38 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:37596 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab3BLUUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:20:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] pci/e1000e: return runtime-pm back to work
Date: Tue, 12 Feb 2013 21:27:03 +0100
Message-ID: <3456892.TimRCtDbda@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo7G-31WjR8S6iR9KRyRVxaW5NrNupxhbRAemCASY2fSRA@mail.gmail.com>
References: <20130204115246.5569.85829.stgit@zurg> <CAErSpo6wG78ptk5kR0CuG99MN1YiC2KrEmEFfKLG_oZjiNGoBA@mail.gmail.com> <CAErSpo7G-31WjR8S6iR9KRyRVxaW5NrNupxhbRAemCASY2fSRA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 11, 2013 05:43:50 PM Bjorn Helgaas wrote:
> On Mon, Feb 11, 2013 at 5:34 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Mon, Feb 4, 2013 at 1:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> On Monday, February 04, 2013 03:55:47 PM Konstantin Khlebnikov wrote:
> >>> This patchset contains some fixes for e1000e diver (broken since v2.6.35)
> >>> and some related fixes and useful debug for PCI code.
> >>>
> >>> All together this fixes my regression report for v3.8-rc1:
> >>> https://lkml.org/lkml/2013/1/1/25
> >>>
> >>> patchset was seriously reworked since v1:
> >>> http://lkml.org/lkml/2013/1/18/147
> >>>
> >>> ---
> >>>
> >>> Konstantin Khlebnikov (6):
> >>>       e1000e: fix pci-device enable-counter balance
> >>>       PCI: don't touch enable_cnt in pci_device_shutdown()
> >>>       PCI: catch enable-counter underflows
> >>>       e1000e: fix runtime power management transitions
> >>>       PCI/PM: warn about incomplete actions in ->runtime_suspend() callback
> >>>       e1000e: fix accessing to suspended device
> >>>
> >>> Rafael J. Wysocki (1):
> >>>       PCI/PM: clear state_saved during suspend
> >>>
> >>>
> >>>  drivers/net/ethernet/intel/e1000e/ethtool.c |   13 ++++
> >>>  drivers/net/ethernet/intel/e1000e/netdev.c  |   82 +++++++--------------------
> >>>  drivers/pci/pci-driver.c                    |   21 +++++--
> >>>  drivers/pci/pci.c                           |    3 +
> >>>  4 files changed, 53 insertions(+), 66 deletions(-)
> >>
> >> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>
> >> for all patches except for [6/7].
> >
> > I added Rafael's acks and applied patches
> >   [2/7] PCI: don't touch enable_cnt in pci_device_shutdown()
> >   [3/7] PCI: catch enable-counter underflows
> > to my pci/konstantin-runtime-pm branch for v3.9.
> 
> Oops, I missed
>   [4/7] PCI/PM: Clear state_saved during suspend
> 
> I applied that one, too.

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
