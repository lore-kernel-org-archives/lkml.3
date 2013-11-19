Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283Ab3KSF5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 00:57:30 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:42536 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3KSF50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 00:57:26 -0500
Date: Tue, 19 Nov 2013 13:57:14 +0800
From: Adam Lee <adam.lee@canonical.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Amos Kong <kongjianjun@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>, Thomas Renninger <trenn@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] pci: check PCI_EXP_FLAGS_SLOT before setting hotplug
 bridge
Message-ID: <20131119055714.GA3451@adam-laptop>
References: <1384767652-20567-1-git-send-email-adam.lee@canonical.com>
 <CAErSpo7bERHRbBNOzb6g+666jMmFXQvv2T2U6dv82fVh1dU5kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7bERHRbBNOzb6g+666jMmFXQvv2T2U6dv82fVh1dU5kA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 10:38:17AM -0700, Bjorn Helgaas wrote:
> [+cc Myron, Amos, Thomas, Ben]
> 
> On Mon, Nov 18, 2013 at 2:40 AM, Adam Lee <adam.lee@canonical.com> wrote:
> > This patch adds the PCI_EXP_FLAGS_SLOT check back before setting
> > hotplug bridge, which is omitted by an API switching commit,
> > 59875ae489609b2267548dc85160c5f0f0c6f9d4 "PCI/core: Use PCI Express
> > Capability accessors".
> >
> > Some Lenovo laptops hang in booting without this fix.
> 
> What kernel version hangs?  I suspect you might be missing 6d3a1741f1
> ("PCI: Support PCIe Capability Slot registers only for ports with
> slots"), because it *looks* like the current kernel should work
> correctly even without your patch.

No, patching 6d3a1741f1 and d3694d4fa3 doesn't fix the hang.

It hangs in acpi_evaluate_integer() from
59875ae489609b2267548dc85160c5f0f0c6f9d4 "PCI/core: Use PCI Express
Capability accessors" and before
ac212b6980d8d5eda705864fc5a8ecddc6d6eacc "ACPI / processor: Use common
hotplug infrastructure", 3.4~3.11. (double confirmed)

I didn't mention this because:
1, that check is omitted obviously, an API switching patch should not
remove things like that.
2, have run some tests, adding the check back is harmless.
3, I believe ac212b6 just workarounds the hang unexpectedly, bug still
exists.

-- 
Adam Lee
