Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764240Ab3DDUFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:05:05 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59375 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763722Ab3DDUFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:05:03 -0400
Date: Thu, 4 Apr 2013 16:04:55 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Don Dutile <ddutile@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v4] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
Message-ID: <20130404200455.GB19354@hmsreliant.think-freely.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1365088091-10862-1-git-send-email-nhorman@tuxdriver.com>
 <CAE9FiQUq8m_2fpyRrLweCZwR7cqFBfbZrt9ZeK-PVL3Puxjp0g@mail.gmail.com>
 <515DB7F6.8010502@redhat.com>
 <CAE9FiQVXG+ns00sCAKGY5Xs3BT3Cc=LRyEkZzHP9DQXS+4KCKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVXG+ns00sCAKGY5Xs3BT3Cc=LRyEkZzHP9DQXS+4KCKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 10:40:07AM -0700, Yinghai Lu wrote:
> On Thu, Apr 4, 2013 at 10:27 AM, Don Dutile <ddutile@redhat.com> wrote:
> >> You need to move the quirk to early_quirk to append nointremap to
> >> avoid extra rebooting.
> >>
> > The pci-dev's of all the (minimally, root, 5500-chipset) pci-dev's are
> > known/scanned/created by that time?
> 
> in arch/x86/kernel/early-quirk.c
> 
> and on top of
> https://git.kernel.org/cgit/linux/kernel/git/yinghai/linux-yinghai.git/commit/?h=for-x86-early-quirk-usb&id=de38757e964cfee20e6da1977572a2191d7f4aa0
> 
> You could add one entry in early_qrk[].
> 
> Some one already try to use that path to disable x2apic on some thinkpad.
> 
> So it should work on nointrremap too.
> 
See my last email to Bjorn.  Doing this in early-quirks in such a way that we
can detect an iommu that has interrupt remapping enabled (so we don't just
unilaterally print this quirk all the time) requires that we be able to parse
acpi tables very early in the boot.  If you know of how to do that, I can make
this happen.  If not, I suppose another alternative would be to have the early
quirk set a flag that tells us this is a bogus chip, and if we try to enable irq
remapping with that flag set, we should fail, and report the error at that time,
but I'm not sure I like that solution.

Neil

> Thanks
> 
> Yinghai
> 
