Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934650AbaE3WVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 18:21:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35632 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934492AbaE3WVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 18:21:18 -0400
Date: Sat, 31 May 2014 00:21:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Doug Thompson <dougthompson@xmission.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-edac@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI, EDAC: fix ordering assign resource and bus_add
Message-ID: <20140530222108.GN28131@pd.tnic>
References: <1367969371-27414-1-git-send-email-yinghai@kernel.org>
 <20140530170103.GE4607@google.com>
 <20140530214643.GL28131@pd.tnic>
 <CAErSpo4kQViCtaG9Fs_Amyr0pp96fsmdX2puJueK6Jf_XXdm1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAErSpo4kQViCtaG9Fs_Amyr0pp96fsmdX2puJueK6Jf_XXdm1Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 04:00:17PM -0600, Bjorn Helgaas wrote:
> Thanks, I should have waited for you. I was assuming the merge window
> would open on Monday, and I hoped for a day or two in -next, but now
> it sounds like we might have an -rc8, so I needn't have been in such a
> hurry.

Bah, no worries. :-) The patch is simple enough and is requiring your
expertise so I wouldnt've said anything, except I wanted to ask about
that pci_bus* functions ordering situation, so... :-)

> Yeah, this is really a mess.  The pci_bus_*() functions (at least
> pci_bus_add_device() and pci_bus_assign_resources()) are not really
> intended to be called by drivers at all -- they should only be used by
> the arch code that drives PCI enumeration.  Eventually I'd like to
> even move them out of the arch code and into the PCI core.

Ah, ok. pci_bus_add_device is called also in some x86 platform drivers,
except the pci core itself, so yeah, it looks like you're trying to hide
it. :)

> In this i82875p case, it looks like this is basically a quirk that
> unhides a device.  I think it's sort of dubious to poke at things the
> BIOS has explicitly hidden from the OS, but apart from that, if we
> turned this into an actual DECLARE_PCI_FIXUP_CLASS_EARLY() quirk on
> the 82875_0 device, I think the normal PCI enumeration process would
> find the 82875_6 device, and we could get rid of the whole "if (dev ==
> NULL)" chunk.

Yeah, I don't think that's worth it - this driver is probably ancient
now, if I trust this:

http://ark.intel.com/products/27711/Intel-82875P-Memory-Controller

Launch Date: Q1'02 - that's a century ago in HW years. :-P

I guess we can leave it at that - even if we did a quirk, I'm at a loss
as to where or who could test it. :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
