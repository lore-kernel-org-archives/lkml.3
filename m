Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaKRIPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:15:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:51702 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbaKRIPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:15:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,408,1413270000"; 
   d="scan'208";a="609621966"
From: "Jamet, Michael" <michael.jamet@intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Levy, Amir (Jer)" <amir.jer.levy@intel.com>,
        "Alloun, Dan" <dan.alloun@intel.com>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Andreas Noever <andreas.noever@gmail.com>
Subject: RE: [PATCH] pci: support Thunderbolt requirements for I/O resources.
Thread-Topic: [PATCH] pci: support Thunderbolt requirements for I/O
 resources.
Thread-Index: AQHP/ohLgY5RjnqrwESQUJmb1M7dNZxdHb+AgAARQQCACOBEIA==
Date: Tue, 18 Nov 2014 08:15:21 +0000
Message-ID: <BC567D27D6B7384F84318942321624DE16179EE6@hasmsx109.ger.corp.intel.com>
References: <1415847123-15558-1-git-send-email-michael.jamet@intel.com>
	<CAErSpo7Z5x=U3vSnxrFpwYUDrUrnrrBCe1F9_GQNYqWWQFWNpQ@mail.gmail.com>
 <CAHp75VcZ0XjcFxjrSgr5-XnWZZa-eZfPH_Fa1Hzb=f+qtE3z9w@mail.gmail.com>
In-Reply-To: <CAHp75VcZ0XjcFxjrSgr5-XnWZZa-eZfPH_Fa1Hzb=f+qtE3z9w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAI8FqJA018767

> -----Original Message-----
> From: Andy Shevchenko [mailto:andy.shevchenko@gmail.com]
> Sent: Wednesday, November 12, 2014 20:31
> To: Bjorn Helgaas
> Cc: Jamet, Michael; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org;
> Levy, Amir (Jer); Alloun, Dan; Rafael Wysocki; Andreas Noever
> Subject: Re: [PATCH] pci: support Thunderbolt requirements for I/O
> resources.
> 
> On Wed, Nov 12, 2014 at 7:29 PM, Bjorn Helgaas <bhelgaas@google.com>
> wrote:
> 
> []
> 
> >> To prevent this, we detect a chain contains a Thunderbolt device by
> >> checking the Thunderbolt PCI device id.
> >
> > I'm really not happy about checking a list of device IDs to identify
> > Thunderbolt devices.  Surely there's a better way, because a list like
> > this has to be updated regularly.
> 
> I recently proposed internally to use quirks (pci_fixup_early) for that, but
> apparently Michael didn't have time to answer. It might be he can just
> comment here since the patch already public.
> 
> --
> With Best Regards,
> Andy Shevchenko

Indeed, I've explored the quirks option.
Unfortunately the fixup hook seems to be called too late in the code 
since pci_enable_device()calls pcibios_enable_device() which actually 
send a PCI command with  CMD |=PCI_COMMAND_IO and configure the PCI HW. 
The IORESOURCE_MEM and IORESOURCE_IO flags are set at the time the
pci_enable_device(), pci_enable_device_mem() or pci_enable_device_io() 
is called during device initializations, so an early fixup call won't help either.
At this stage, the PCI HW is configured and a fixup call won't  resolve the issue
unless another PCI command is sent to revert it 
(generally not advised to execute again on hardware).

Michael 
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
