Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaJBQSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:18:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:54763 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519AbaJBQSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:18:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,639,1406617200"; 
   d="scan'208";a="612201056"
Message-ID: <542D7DC7.90300@linux.intel.com>
Date: Thu, 02 Oct 2014 19:31:03 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Julius Werner <jwerner@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3 0/4] Allow xHCI drivers to be built as separate modules
References: <1408467712-27497-1-git-send-email-abrestic@chromium.org> <CAL1qeaFwGYgzL=n0My4eBQMhvtNQfHpU5d1tif0twtYyjw5yqg@mail.gmail.com> <540F0E53.4050106@linux.intel.com>
In-Reply-To: <540F0E53.4050106@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 05:27 PM, Mathias Nyman wrote:
> On 09/03/2014 10:51 PM, Andrew Bresticker wrote:
>> Mathias,
>>
>> On Tue, Aug 19, 2014 at 10:01 AM, Andrew Bresticker
>> <abrestic@chromium.org> wrote:
>>> It was suggested in the review of the Tegra xHCI driver [1] that we
>>> allow xHCI drivers to be built as individual modules (like EHCI) instead
>>> of building them all into the single xhci-hcd module as they are today.
>>>
>>> Patches 1-3 prepare for making the xHCI PCI and platform drivers able
>>> to be built as individual modules and patch 4 actually creates the 3
>>> separate modules (core, platform, PCI).
>>>
>>> Based on 3.17-rc1.
>>>
>>> Changes from v2:
>>>  - fixed typo in xhci_register_plat
>>>  - exported another symbol needed by xhci-pci module
>>> Changes from v1:
>>>  - rebased on changes introduced by xhci-rcar driver
>>>
>>> [1] http://patchwork.ozlabs.org/patch/361265/
>>>
>>> Andrew Bresticker (4):
>>>   xhci: Introduce xhci_init_driver()
>>>   xhci: Check for XHCI_COMP_MODE_QUIRK when disabling D3cold
>>>   xhci: Export symbols used by host-controller drivers
>>>   xhci: Allow xHCI drivers to be built as separate modules
>>
>> Any thoughts/comments on this series?
>>
>>
> 
> Sorry about the delay.
> When I start looking at this I always get interrupted by some fire that needs to be put out.
> 
> I still need some more time to go through it
> 
> -Mathias
> 
> --
>

Ok, finally found the time to look through it. Sorry about the long wait

The whole series look good, and its now more in line with how ehci does things (like using *hci_init_driver())

Series still apply nicely on usb-next.

Greg, any chance this still can get to your usb-next and to the 3.18 merge window?
Tegra developers seem eager to get it in, and I feel bad for not reviewing it earlier. 

-Mathias
