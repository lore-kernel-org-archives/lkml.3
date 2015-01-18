Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbbAROQd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 09:16:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:29889 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbbAROQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 09:16:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,421,1418112000"; 
   d="scan'208";a="652830739"
From: "Jamet, Michael" <michael.jamet@intel.com>
To: Andreas Noever <andreas.noever@gmail.com>
CC: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Levy, Amir (Jer)" <amir.jer.levy@intel.com>,
        "Alloun, Dan" <dan.alloun@intel.com>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: RE: [PATCH] pci: support Thunderbolt requirements for I/O resources.
Thread-Topic: [PATCH] pci: support Thunderbolt requirements for I/O
 resources.
Thread-Index: AQHP/ohLgY5RjnqrwESQUJmb1M7dNZxdHb+AgAARQQCAAB44gIAIxgYwgABcG4CAX+SOMA==
Date: Sun, 18 Jan 2015 14:16:26 +0000
Message-ID: <BC567D27D6B7384F84318942321624DE269180F9@hasmsx109.ger.corp.intel.com>
References: <1415847123-15558-1-git-send-email-michael.jamet@intel.com>
 <CAErSpo7Z5x=U3vSnxrFpwYUDrUrnrrBCe1F9_GQNYqWWQFWNpQ@mail.gmail.com>
 <CAHp75VcZ0XjcFxjrSgr5-XnWZZa-eZfPH_Fa1Hzb=f+qtE3z9w@mail.gmail.com>
 <CAMxnaaXOa_GAFwK+tUrO8DBjENqdd9uaQHKqEMm+i4754Ch3gQ@mail.gmail.com>
 <BC567D27D6B7384F84318942321624DE16179F2A@hasmsx109.ger.corp.intel.com>
 <CAMxnaaV41H-bzw2kp=HXd0aicRJbtNJuNE4aPf=EvQPMKiPQ6g@mail.gmail.com>
In-Reply-To: <CAMxnaaV41H-bzw2kp=HXd0aicRJbtNJuNE4aPf=EvQPMKiPQ6g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0IEGbgR031061

> -----Original Message-----
> From: Andreas Noever [mailto:andreas.noever@gmail.com]
> Sent: Tuesday, November 18, 2014 17:48
> To: Jamet, Michael
> Cc: Andy Shevchenko; Bjorn Helgaas; linux-pci@vger.kernel.org; linux-
> kernel@vger.kernel.org; Levy, Amir (Jer); Alloun, Dan; Rafael Wysocki
> Subject: Re: [PATCH] pci: support Thunderbolt requirements for I/O resources.
> 
> On Tue, Nov 18, 2014 at 9:20 AM, Jamet, Michael <michael.jamet@intel.com>
> wrote:
> >> -----Original Message-----
> >> From: Andreas Noever [mailto:andreas.noever@gmail.com]
> >> Sent: Wednesday, November 12, 2014 22:19
> >> To: Andy Shevchenko
> >> Cc: Bjorn Helgaas; Jamet, Michael; linux-pci@vger.kernel.org; linux-
> >> kernel@vger.kernel.org; Levy, Amir (Jer); Alloun, Dan; Rafael Wysocki
> >> Subject: Re: [PATCH] pci: support Thunderbolt requirements for I/O
> >> resources.
> >>
> >> On Wed, Nov 12, 2014 at 7:30 PM, Andy Shevchenko
> >> <andy.shevchenko@gmail.com> wrote:
> >> > On Wed, Nov 12, 2014 at 7:29 PM, Bjorn Helgaas
> >> > <bhelgaas@google.com>
> >> wrote:
> >> >
> >> > []
> >> >
> >> >>> To prevent this, we detect a chain contains a Thunderbolt device
> >> >>> by checking the Thunderbolt PCI device id.
> >> >>
> >> >> I'm really not happy about checking a list of device IDs to
> >> >> identify Thunderbolt devices.  Surely there's a better way,
> >> >> because a list like this has to be updated regularly.
> >> >
> >> > I recently proposed internally to use quirks (pci_fixup_early) for
> >> > that, but apparently Michael didn't have time to answer. It might
> >> > be he can just comment here since the patch already public.
> >>
> >> In any case: this will interfere with thunderbolt hotplug on Apple
> >> systems, where we do not have BIOS support and have to handle hotplug
> >> events and assign resources ourselves. So please add a DMI check for
> >> Apple (the reverse of what we do in
> >> http://lxr.free-
> >> electrons.com/source/drivers/thunderbolt/nhi.c?v=3.17#L664
> >> ).
> >>
> >> Thanks,
> >> Andreas
> >
> > This is correct that the hotplug handling mechanism and interaction with
> BIOS is different.
> > However, this patch also applies for any case, since the I/O space is
> > limited and need to be preserved, so we must prevent allocation of I/O
> > resources from the devices and avoiding exhaustion while chaining them.
> 
> Now I am slightly confused. Does the BIOS (on non Apple hardware) leave I/O
> resources always unassigned? Your first post seemed to imply that it does
> assign some and that we should not interfere. In that case we would have to
> assign them on Apple systems ourselves. On the other hand if no TB device uses
> I/O resources and the BIOS never assigns them, then why do devices fail if we
> exhaust them?
> 
> Andreas

Correct. The BIOS may play a role in allocation of memory and I/O 
resources but most of the case will leave the I/O  resources unassigned.
Some legacy Thunderbolt devices are designed with I/O BARs, so they 
need to be handled with care as written in the other email thread to Bjorn.

/Michael
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
