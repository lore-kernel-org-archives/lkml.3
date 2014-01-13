Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaAMRjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:39:19 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:37248 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaAMRjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:39:05 -0500
MIME-Version: 1.0
In-Reply-To: <CAA93t1pwLNeCXPXOO1yTPiREVP=sos1bwpob=VnLhSm_zocEkw@mail.gmail.com>
References: <52B0AEAD.6050604@gmail.com> <20131218010207.GC15119@google.com>
 <CAA93t1qh2Wn2uPKUGvbqrOJxDfqAqTNFSqOryC36Wm=gnygUog@mail.gmail.com>
 <CAErSpo6A0=0Ph22vMZ1_eC1L7ndoi5S6162zRDYkMoPf53Fhcg@mail.gmail.com>
 <4b24688d857e432eb7ecf9095c95b742@DM2PR05MB671.namprd05.prod.outlook.com>
 <bfe1b6a0b2494c71be43fea45f413575@DM2PR05MB671.namprd05.prod.outlook.com>
 <CAErSpo4gGW2r4X7UuefwcYTX=c4irWc60w2UCT0e_U-uSaujow@mail.gmail.com> <CAA93t1pwLNeCXPXOO1yTPiREVP=sos1bwpob=VnLhSm_zocEkw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 13 Jan 2014 10:38:44 -0700
Message-ID: <CAErSpo72KZ-a2OSQLWoK71GCgwBt676XZdGt4tEYm-6UYnLmPw@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] pciehp: Don't disable the link permanently, during removal
To: Rajat Jain <rajatxjain@gmail.com>
Cc: Rajat Jain <rajatjain@juniper.net>, Rajat Jain <rajatjain.linux@gmail.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, Guenter Roeck <groeck@juniper.net>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 1:30 AM, Rajat Jain <rajatxjain@gmail.com> wrote:

> Yinghai: I am trying to understand what exactly is this platform bug
> and how to add a quirk such that this platform remains unaffected. Can
> you please help me by suggesting how to decide if this is _the_
> platform that has the bug (the pcie repeater).
>
> Bjorn: It seems to be that identification of this platform will be out
> PCI code (since the bug seems to be in a pcie repeater chip which is
> not a PCI device visible to SW). So even if we find a way to identify
> this platform (e.g DMI) , I doubt if you'd want me to add that in the
> pciehp code (which is platform independent so far). At best, the only
> way out I can see is to provide a knob from the pciehp, that can be
> use by the platform code to either enable or disable the link state
> hotplug. It could go back towards using a module parameter like
> pciehp_use_link_events. Please suggest.
>
> The only other way I can think of, is that I can remove the debug
> message altogether (Link up / Link down). (Or the user can change the
> verbosity).

I think it's perfectly fine to add a DMI-based quirk in pciehp.  Yes,
it's a bit ugly, but that's just the nature of working around hardware
defects.  Identify the platform, emit a diagnostic ("disabling link
state because platform may be buggy"), enable the workaround.  That
seems better than requiring the user to figure out what hardware he
has and whether it has a defect.

I would also be OK with adding a pciehp module parameter to explicitly
enable or disable the workaround if that seems necessary.  I just want
the common case of correctly working hardware to work without any
switches.

Removing or rate-limiting the link up/down debug message is also fine with me.

Bjorn
