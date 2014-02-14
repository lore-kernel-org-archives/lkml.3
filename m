Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaBNWRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 17:17:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:5483 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbaBNWR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 17:17:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,847,1384329600"; 
   d="scan'208";a="483706174"
From: "Dugger, Donald D" <donald.d.dugger@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 0/3] Quirk Intel PCH root ports for ACS-like features
Thread-Topic: [PATCH v2 0/3] Quirk Intel PCH root ports for ACS-like features
Thread-Index: AQHPKc4fLt21Vk+Fj0iazmGjRXcegJq1TzKg
Date: Fri, 14 Feb 2014 22:17:02 +0000
Message-ID: <6AF484C0160C61439DE06F17668F3BCB5285C7EC@ORSMSX102.amr.corp.intel.com>
References: <20140203212216.8607.68273.stgit@bling.home>
 <CAErSpo5D55RcaSASGrU8hEcg+BYvGKOQHFjor8k1gSzfZKWy2g@mail.gmail.com>
In-Reply-To: <CAErSpo5D55RcaSASGrU8hEcg+BYvGKOQHFjor8k1gSzfZKWy2g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1EMHbbi006124

In re: Feature vs. bug fix

At the risk of trying to arguing about the meaning of `is' I would argue that this is more a bug fix than a feature.  We're not adding a new capability, we are trying to work around deficient HW (no argument that we should have implemented ACS on all platforms).

Having said that, although I would obviously prefer to see this in v3.14 we can live with this hitting v3.15.

--
Don Dugger
"Censeo Toto nos in Kansa esse decisse." - D. Gale
Ph: 303/443-3786

-----Original Message-----
From: Bjorn Helgaas [mailto:bhelgaas@google.com] 
Sent: Friday, February 14, 2014 2:43 PM
To: Alex Williamson
Cc: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; Dugger, Donald D
Subject: Re: [PATCH v2 0/3] Quirk Intel PCH root ports for ACS-like features

[+cc Don]

On Mon, Feb 03, 2014 at 02:27:27PM -0700, Alex Williamson wrote:
> v2:
>  - Remove bus #0 bug in filtering matching
>  - Add 2/3 introducing PCI_DEV_FLAGS_ACS_ENABLED_QUIRK, this gives
>    is better tracking and addresses the theoretical hotplug issue
>  - Update 3/3 for PCI_DEV_FLAGS_ACS_ENABLED_QUIRK
>  - Add dev_info to print regardless of whether we changes bits
>  - Add Intel cc
>
> As described in 3/3 many Intel root ports lack PCIe ACS capabilities 
> which results in excessively large IOMMU groups.  Many of these root 
> ports do provide isolation capabilities, we just need to use device 
> specific mechanisms to enable and verify.  Long term, I hope we can 
> round out this list (particularly to include X79 root ports) and more 
> importantly, encourage proper PCIe ACS support in future products.  
> I'm really hoping we can get this in during the 3.14 cycle.
> Thanks,
>
> Alex
> ---
>
> Alex Williamson (3):
>       pci: Add device specific PCI ACS enable
>       pci: Add pci_dev_flag for ACS enable quirks
>       pci/quirks: Enable quirks for PCIe ACS on Intel PCH root ports

I applied these (with Don's ack for 3/3) to pci/virtualization.

I tried to figure out how to handle post-merge window patches.  Per Documentation/development-process/2.Process, "[after -rc1], only patches which fix problems should be submitted to the mainline," so one might conclude that a fix for any sort of problem is allowed.  However, Documentation/networking/netdev-FAQ.txt says "No new features get mainlined after this [-rc1] -- only fixes to the rc1 content are expected," which is how I've been operating.

In any case, these patches look more like new functionality (enabling a non-standard ACS feature) than a bug fix to me, so my preference is to merge them during the v3.15 merge window.

I understand the desire for v3.14, namely, "lots of Intel devices don't support ACS, and that makes it hard for users to expose devices to userspace with fine granularity, and waiting for v3.15 will mean another two months."  But this problem is really of Intel's own making: if they'd used standard ACS, or if they'd documented their non-standard mechanism, this wouldn't be an issue.

Bjorn
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
