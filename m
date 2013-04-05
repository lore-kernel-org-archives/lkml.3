Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765679Ab3DEAYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 20:24:40 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34736 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765169Ab3DEAYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 20:24:38 -0400
Date: Thu, 4 Apr 2013 20:24:05 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v4] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
Message-ID: <20130405002405.GA24109@hmsreliant.think-freely.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1365088091-10862-1-git-send-email-nhorman@tuxdriver.com>
 <CAE9FiQUq8m_2fpyRrLweCZwR7cqFBfbZrt9ZeK-PVL3Puxjp0g@mail.gmail.com>
 <515DB7F6.8010502@redhat.com>
 <CAE9FiQVXG+ns00sCAKGY5Xs3BT3Cc=LRyEkZzHP9DQXS+4KCKg@mail.gmail.com>
 <20130404200455.GB19354@hmsreliant.think-freely.org>
 <CAErSpo5sW-uibP=TNnfSq4u8phm5NdmNkapcF+UUVgW9LiAMZA@mail.gmail.com>
 <CAE9FiQUL1wQFSO_47nc4dbZ5GseSBOXvrW8OhduZ3w3gjj8pJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUL1wQFSO_47nc4dbZ5GseSBOXvrW8OhduZ3w3gjj8pJw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 02:11:54PM -0700, Yinghai Lu wrote:
> On Thu, Apr 4, 2013 at 1:33 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >> See my last email to Bjorn.  Doing this in early-quirks in such a way that we
> >> can detect an iommu that has interrupt remapping enabled (so we don't just
> >> unilaterally print this quirk all the time) requires that we be able to parse
> >> acpi tables very early in the boot.  If you know of how to do that, I can make
> >> this happen.  If not, I suppose another alternative would be to have the early
> >> quirk set a flag that tells us this is a bogus chip, and if we try to enable irq
> >> remapping with that flag set, we should fail, and report the error at that time,
> >> but I'm not sure I like that solution.
> >
> > I like that solution :)  It seems very simple -- you don't have to
> > parse any tables or anything.
> 
> You are right, we don't need to parse any acpi tables.
> 
> just add one quirk in early-quirk.c to set
>    disable_irq_remap = 1;
> 
Well, I can't just do that.  We need to issue a warning to the user as well, and
to do so conditionally (we don't want to warn users who have prorperly updated
BIOSes), I would need to know if irq remapping is actually on or not, which
would require parsing ACPI tables

But, as noted above, I can just set a flag, and defer the printing of the
warning until later in the boot process, when we know that information already.
Bjorn seems on board with that idea, so I'll spin up a patch for it in the AM.

Thanks!
Neil

> Thanks
> 
> Yinghai
> 
