Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbaKRIUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:20:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:48499 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbaKRIUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:20:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,408,1413270000"; 
   d="scan'208";a="609624168"
From: "Jamet, Michael" <michael.jamet@intel.com>
To: Andreas Noever <andreas.noever@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Levy, Amir (Jer)" <amir.jer.levy@intel.com>,
        "Alloun, Dan" <dan.alloun@intel.com>,
        Rafael Wysocki <rjw@rjwysocki.net>
Subject: RE: [PATCH] pci: support Thunderbolt requirements for I/O resources.
Thread-Topic: [PATCH] pci: support Thunderbolt requirements for I/O
 resources.
Thread-Index: AQHP/ohLgY5RjnqrwESQUJmb1M7dNZxdHb+AgAARQQCAAB44gIAIxgYw
Date: Tue, 18 Nov 2014 08:20:13 +0000
Message-ID: <BC567D27D6B7384F84318942321624DE16179F2A@hasmsx109.ger.corp.intel.com>
References: <1415847123-15558-1-git-send-email-michael.jamet@intel.com>
 <CAErSpo7Z5x=U3vSnxrFpwYUDrUrnrrBCe1F9_GQNYqWWQFWNpQ@mail.gmail.com>
 <CAHp75VcZ0XjcFxjrSgr5-XnWZZa-eZfPH_Fa1Hzb=f+qtE3z9w@mail.gmail.com>
 <CAMxnaaXOa_GAFwK+tUrO8DBjENqdd9uaQHKqEMm+i4754Ch3gQ@mail.gmail.com>
In-Reply-To: <CAMxnaaXOa_GAFwK+tUrO8DBjENqdd9uaQHKqEMm+i4754Ch3gQ@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAI8KTVn018791

> -----Original Message-----
> From: Andreas Noever [mailto:andreas.noever@gmail.com]
> Sent: Wednesday, November 12, 2014 22:19
> To: Andy Shevchenko
> Cc: Bjorn Helgaas; Jamet, Michael; linux-pci@vger.kernel.org; linux-
> kernel@vger.kernel.org; Levy, Amir (Jer); Alloun, Dan; Rafael Wysocki
> Subject: Re: [PATCH] pci: support Thunderbolt requirements for I/O
> resources.
> 
> On Wed, Nov 12, 2014 at 7:30 PM, Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> > On Wed, Nov 12, 2014 at 7:29 PM, Bjorn Helgaas <bhelgaas@google.com>
> wrote:
> >
> > []
> >
> >>> To prevent this, we detect a chain contains a Thunderbolt device by
> >>> checking the Thunderbolt PCI device id.
> >>
> >> I'm really not happy about checking a list of device IDs to identify
> >> Thunderbolt devices.  Surely there's a better way, because a list
> >> like this has to be updated regularly.
> >
> > I recently proposed internally to use quirks (pci_fixup_early) for
> > that, but apparently Michael didn't have time to answer. It might be
> > he can just comment here since the patch already public.
> 
> In any case: this will interfere with thunderbolt hotplug on Apple systems,
> where we do not have BIOS support and have to handle hotplug events and
> assign resources ourselves. So please add a DMI check for Apple (the reverse
> of what we do in
> http://lxr.free-
> electrons.com/source/drivers/thunderbolt/nhi.c?v=3.17#L664
> ).
> 
> Thanks,
> Andreas

This is correct that the hotplug handling mechanism and interaction with BIOS is different. 
However, this patch also applies for any case, since the I/O space is limited 
and need to be preserved, so we must prevent allocation of I/O resources 
from the devices and avoiding exhaustion while chaining them.

Michael 


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
