Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbaD3HAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 03:00:51 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:45714 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaD3HAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 03:00:48 -0400
Date: Wed, 30 Apr 2014 09:00:42 +0200
From: Robert Richter <rric@kernel.org>
To: Myron Stowe <myron.stowe@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>, kim.naru@amd.com,
        Daniel J Blueman <daniel@numascale.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Steffen Persvold <sp@numascale.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2 2/5] x86/PCI: Support additional MMIO range
 capabilities
Message-ID: <20140430070042.GN32718@rric.localhost>
References: <20140420075936.GA19672@pd.tnic>
 <CAL-B5D1rJmf9vLSnV2izsXcbCu1idXsTsnSwoFRKFNTM7BnyfA@mail.gmail.com>
 <20140426091031.GA10166@pd.tnic>
 <CAErSpo4Jqo_opj=QqjcquS_6HqckZfP5-oQHkmY5FSAyyLNYMg@mail.gmail.com>
 <20140428214036.GA32143@pd.tnic>
 <20140429073309.GE10997@alberich>
 <20140429102013.GA4726@pd.tnic>
 <535FC269.2000808@amd.com>
 <20140429191454.GB4726@pd.tnic>
 <CAL-B5D2Z7AvJZ3G2JLY6ZOZBRe4DGgO27RVJ_HHotGrnKL7Y1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL-B5D2Z7AvJZ3G2JLY6ZOZBRe4DGgO27RVJ_HHotGrnKL7Y1A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.04.14 15:40:28, Myron Stowe wrote:
> On Tue, Apr 29, 2014 at 1:14 PM, Borislav Petkov <bp@alien8.de> wrote:
> > So sounds to me like we want to get rid of the whole IO ECS deal
> > altogether then.
> >
> > Now, I'm wondering whether we should kill it completely since I don't
> > think anyone cares about numa node info being correct on K8, or? I'm
> > specifically turning to our numascale friends who love to have a lot of
> > nodes. :-)

Maybe I did get you wrong, but IO ECS was introduced with fam10h and
is not related to k8.

> I think we need to be careful here as there are two unrelated topics
> being discussed together.  What started this whole thread was the need
> for sysfs related numa_node information with respect to PCI devices
> (1).  Without patch 1, platforms with newer AMD CPUs end up having
> '-1' numa_node values for all PCI devices.
> 
> IO ECS has no bearing on patch 1, it only comes into play with patch 2
> which is concerned with MMIO resource information when MCFG doesn't
> exist.  For the particular issue I'm trying to get resolved, patch 2
> is not needed.  However, since we have expended time and effort on
> this subject, perhaps we should get this cleaned up while it has our
> attention.
> 
> I'm all for deleting as much of amd_bus.c as possible due to its
> "perennial maintenance headache".  The obvious choices seem to be all,
> or some combination, of:
>   o removing IO ECS logic,
>   o removing IO/MMIO logic (assuming MCFG issues were long enough ago
> to no longer be a concern),
>   o start deprecating amd_bus.c by adding logic to skip if BIOS >= 2015

I don't see any reason for big changes actually. Just bind the IO ECS
logic to fam10h (either with fam check or pci device depending on the
implementation, xen's flavor would be pci). This is something stricter
than 'if BIOS >= 2015'. It leaves code as it is which is maintainable.

You implement the new logic for for newer families. No need for one
implementation that fits all.

-Robert
