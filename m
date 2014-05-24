Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaEXONP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 10:13:15 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:56266 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaEXONN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 10:13:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140524063945.GA14727@xiaoyu.lan>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
	<1399566363-25837-3-git-send-email-mathias.nyman@linux.intel.com>
	<20140520010137.GA8146@kroah.com>
	<537B24B8.9050303@linux.intel.com>
	<s5ha9acbwwo.wl%tiwai@suse.de>
	<CAPcyv4gg164u8Dz0RtV4KjXkDyCMvuC92j6VopqTbA1Shp_3QA@mail.gmail.com>
	<20140520203432.GB30178@kroah.com>
	<CAPcyv4i4jTMMbZWWdb79bJ2f5OUaSin4BN_ukWmVcv7JCiup3g@mail.gmail.com>
	<20140524063945.GA14727@xiaoyu.lan>
Date: Sat, 24 May 2014 07:13:12 -0700
Message-ID: <CAPcyv4gwc7-keYsnLGBUkryPKSgK7AyLpTzjzmRXGaJ2ZVE=RA@mail.gmail.com>
Subject: Re: [PATCH 02/10] xhci: 'noxhci_port_switch' kernel parameter
From: Dan Williams <dan.j.williams@intel.com>
To: Holger Hans Peter Freyther <holger@freyther.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, Takashi Iwai <tiwai@suse.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Holger Hans Peter Freyther <holger@moiji-mobile.com>,
        Oliver Neukum <oneukum@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 11:39 PM, Holger Hans Peter Freyther
<holger@freyther.de> wrote:
> On Tue, May 20, 2014 at 03:40:16PM -0700, Dan Williams wrote:
>
> Dear Dan,
>
>> Sorry, I don't think it is fair to users to force them to re-compile
>> their kernel to get their device to work.  Granted, I'm new to USB
>> development, but the rate of reports of endpoint devices that mess up
>> and require quirks in the hcd-driver or usb-core seems un-ending to
>
> thank you very much for this statement. xhci-hcd is unusable for
> many people. On my laptop I can't scan more than one document, the
> laptop sometimes immediately wakes up after suspend and after almost
> two years all of these issues remain.

That's sad.  We (Sarah, Mathias, and I) really want to fix that.

> I am running kernels with a hacked up pci-quirks.c for months and
> scanning documents work, suspend/resume is working, no issues with
> USB serials. My job is not related to Linux kernel development so
> I would love to go back to a distribution kernel. Please make this
> possible. In the end "xhci" appears to be a "supported" driver?

Yes, there are presently 3 people hacking on the xhci bug report
backlog at Intel where it was just a solitary hero before.  To be fair
I believe the rate of discovery of non-spec compliant quirkiness is to
blame.  In the meantime, as we ramp to get back on top of the tidal
wave of weird device interactions with xhci, I believe it is fair to
offer a workaround.

Let me see if I can achieve this with a debugfs interface so that
'noxhci_port_switch' does not become a permanent ABI per Greg's
concern.

--
Dan
