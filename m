Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732AbaAaR70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:59:26 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:38847 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaAaR7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:59:23 -0500
MIME-Version: 1.0
In-Reply-To: <309B89C4C689E141A5FF6A0C5FB2118B7314C430@ORSMSX101.amr.corp.intel.com>
References: <20140130192011.25426.45702.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <309B89C4C689E141A5FF6A0C5FB2118B7314C430@ORSMSX101.amr.corp.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 31 Jan 2014 10:59:02 -0700
Message-ID: <CAErSpo627wEtBypSrX8QGLW=QAnpa0q-g2z+kSM9hBdRcFNv-Q@mail.gmail.com>
Subject: Re: [E1000-devel] [PATCH 0/2] Remove dead code
To: "Brown, Aaron F" <aaron.f.brown@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 2:10 AM, Brown, Aaron F <aaron.f.brown@intel.com> wrote:
>> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
>> Sent: Thursday, January 30, 2014 11:21 AM
>> To: linux-pci@vger.kernel.org
>> Cc: e1000-devel@lists.sourceforge.net; Arjan van de Ven; linux-
>> kernel@vger.kernel.org
>> Subject: [E1000-devel] [PATCH 0/2] Remove dead code
>>
>> This is a rework of part of Stephen's patch [1].
>>
>> This removes the MMIO exclusivity support that was added as part of an
>> e1000e bug hunt.
>>
>> The e1000e driver still uses pci_request_selected_regions_exclusive(), but
>> there are no callers of pci_request_region_exclusive() and
>> pci_request_regions_exclusive().  I thought it was cleaner to remove the
>> whole thing than to leave parts of it in place.  But I could easily be
>> convinced to leave part or all of this in place if people think it's still
>> useful.
>
> Thanks Bjorn, I have added these to Jeff's queue.

Let's wait for a bit more discussion on this.

For one thing, Fengguang's autobuilder found a handful of issues,
including a couple more users of the exclusive mappings.  For another,
Arjan reminded me that the e1000e bug hung was for a problem that
bricked the device, requiring replacement of the part or significant
effort to fix the EEPROM.  I *suspect* this is a potential issue for
many devices, but if the e1000e is particularly susceptible for some
reason, we might want to keep the exclusive mappings for it.

If you want to apply just the e1000e part that removes its use of
pci_request_selected_regions_exclusive(), I would have no complaints
about that, of course.  But we can't apply the whole thing as-is
without at least fixing the build issues.

>> It also removes SR-IOV migration support, which is completely unused, as
>> far as I can tell.
>>
>> [1]
>> http://lkml.kernel.org/r/20131227132710.7190647c@nehalam.linuxnetplumber.n
>> et
>>
>> ---
>>
>> Bjorn Helgaas (2):
>>       PCI: Remove unused MMIO exclusivity support
>>       PCI: Remove unused SR-IOV VF Migration support
>>
>>
>>  Documentation/PCI/pci-iov-howto.txt        |    4 -
>>  Documentation/kernel-parameters.txt        |    4 -
>>  arch/x86/mm/init.c                         |    2
>>  drivers/net/ethernet/intel/e1000e/netdev.c |    3 -
>>  drivers/pci/iov.c                          |  119 -----------------------
>> -----
>>  drivers/pci/pci-sysfs.c                    |    3 -
>>  drivers/pci/pci.c                          |  112 +++--------------------
>> ---
>>  drivers/pci/pci.h                          |    4 -
>>  include/linux/ioport.h                     |    5 -
>>  include/linux/pci.h                        |    7 --
>>  kernel/resource.c                          |   54 -------------
>>  11 files changed, 14 insertions(+), 303 deletions(-)
>>
>> --------------------------------------------------------------------------
>> ----
>> WatchGuard Dimension instantly turns raw network data into actionable
>> security intelligence. It gives you real-time visual feedback on key
>> security issues and trends.  Skip the complicated setup - simply import a
>> virtual appliance and go from zero to informed in seconds.
>> http://pubads.g.doubleclick.net/gampad/clk?id=123612991&iu=/4140/ostg.clkt
>> rk
>> _______________________________________________
>> E1000-devel mailing list
>> E1000-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/e1000-devel
>> To learn more about Intel&#174; Ethernet, visit
>> http://communities.intel.com/community/wired
