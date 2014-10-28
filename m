Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaJ1SqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:46:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:51698 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaJ1SqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:46:16 -0400
Date: Tue, 28 Oct 2014 19:45:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Bjorn Helgaas <bhelgaas@google.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [Patch v7 01/18] ACPI, irq: fix regression casued by
 6b9fb7082409
In-Reply-To: <CAErSpo5Dh8rx42HkS3cPoJ1=oQq2qsFAut5LK83obbghy+OsFA@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1410281943100.5308@nanos>
References: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com> <1414387308-27148-2-git-send-email-jiang.liu@linux.intel.com> <CAErSpo5Dh8rx42HkS3cPoJ1=oQq2qsFAut5LK83obbghy+OsFA@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014, Bjorn Helgaas wrote:
> The subject should describe the change you're making.  "Fix regression
> caused by xxx" doesn't say anything about what the patch does.
> 
> On Sun, Oct 26, 2014 at 11:21 PM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> > When IOAPIC is disabled, acpi_gsi_to_irq() should return gsi directly
> > instead of calling mp_map_gsi_to_irq() to translate gsi to IRQ by IOAPIC.
> 
> I don't know what the convention is or if there even is one, but "GSI"
> is even more of an acronym than "IRQ", so I'd capitalize it.
> 
> > It fixes https://bugzilla.kernel.org/show_bug.cgi?id=84381.
> 
> A line like the following may be useful to those who have to backport this.
> 
> Fixes: 6b9fb7082409 ("x86, ACPI, irq: Consolidate algorithm of mapping
> (ioapic, pin) to IRQ number")

The patch is already queued in tip x86/urgent with a proper changelog.

http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=961b6a7003acec4f9d70dabc1a253b783cb74272

Thanks,

	tglx
