Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761223Ab3BLAoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:44:12 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:53436 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761084Ab3BLAoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:44:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo6wG78ptk5kR0CuG99MN1YiC2KrEmEFfKLG_oZjiNGoBA@mail.gmail.com>
References: <20130204115246.5569.85829.stgit@zurg> <2306912.u6v1yvkaml@vostro.rjw.lan>
 <CAErSpo6wG78ptk5kR0CuG99MN1YiC2KrEmEFfKLG_oZjiNGoBA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 11 Feb 2013 17:43:50 -0700
Message-ID: <CAErSpo7G-31WjR8S6iR9KRyRVxaW5NrNupxhbRAemCASY2fSRA@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] pci/e1000e: return runtime-pm back to work
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 5:34 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Feb 4, 2013 at 1:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Monday, February 04, 2013 03:55:47 PM Konstantin Khlebnikov wrote:
>>> This patchset contains some fixes for e1000e diver (broken since v2.6.35)
>>> and some related fixes and useful debug for PCI code.
>>>
>>> All together this fixes my regression report for v3.8-rc1:
>>> https://lkml.org/lkml/2013/1/1/25
>>>
>>> patchset was seriously reworked since v1:
>>> http://lkml.org/lkml/2013/1/18/147
>>>
>>> ---
>>>
>>> Konstantin Khlebnikov (6):
>>>       e1000e: fix pci-device enable-counter balance
>>>       PCI: don't touch enable_cnt in pci_device_shutdown()
>>>       PCI: catch enable-counter underflows
>>>       e1000e: fix runtime power management transitions
>>>       PCI/PM: warn about incomplete actions in ->runtime_suspend() callback
>>>       e1000e: fix accessing to suspended device
>>>
>>> Rafael J. Wysocki (1):
>>>       PCI/PM: clear state_saved during suspend
>>>
>>>
>>>  drivers/net/ethernet/intel/e1000e/ethtool.c |   13 ++++
>>>  drivers/net/ethernet/intel/e1000e/netdev.c  |   82 +++++++--------------------
>>>  drivers/pci/pci-driver.c                    |   21 +++++--
>>>  drivers/pci/pci.c                           |    3 +
>>>  4 files changed, 53 insertions(+), 66 deletions(-)
>>
>> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>> for all patches except for [6/7].
>
> I added Rafael's acks and applied patches
>   [2/7] PCI: don't touch enable_cnt in pci_device_shutdown()
>   [3/7] PCI: catch enable-counter underflows
> to my pci/konstantin-runtime-pm branch for v3.9.

Oops, I missed
  [4/7] PCI/PM: Clear state_saved during suspend

I applied that one, too.

Bjorn
