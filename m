Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab3BWAOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 19:14:14 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41776 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758341Ab3BWAOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 19:14:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Jones <davej@redhat.com>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        tianyu.lan@intel.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
Date: Sat, 23 Feb 2013 01:20:52 +0100
Message-ID: <1550501.km85QgikaX@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130222222304.GA19546@redhat.com>
References: <20130222085954.GA4352@redhat.com> <20130222215158.GA4723@balto.lan> <20130222222304.GA19546@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 22, 2013 05:23:04 PM Dave Jones wrote:
> On Fri, Feb 22, 2013 at 10:51:58PM +0100, Fabio Baltieri wrote:
>  > On Fri, Feb 22, 2013 at 03:59:54AM -0500, Dave Jones wrote:
>  > > On Thu, Feb 21, 2013 at 10:40:10AM -0800, Greg KH wrote:
>  > > 
>  > > It looks like every port on my laptop is powered down, as I can't
>  > > even charge devices with it.
>  > 
>  > I have the same problem (and almost the same laptop, Thinkpad T430
>  > here), all external USB ports without power - even the always-on one
>  > :-).
>  > 
>  > The bug seems to be ACPI related, I bisected it down to this patch:
>  > 
>  > f95988d ACPI / scan: Treat power resources in a special way
>  > 
>  > In the dmesg I have some error like these:
>  > 
>  > ACPI: Power Resource [PUBS] (on)
>  > ...
>  > pci 0000:00:14.0: System wakeup disabled by ACPI
>  > 
>  > for the USB controllers in the broken kernel, there are some in your
>  > dmesg too.  I'll try to come up with a fix for current mainline, but all
>  > the acpi stuff is quite obscure to me and the patch does not revert
>  > cleanly, maybe Rafael (in CC) has some idea!
> 
> Good find. I see the same thing.
> 
> [    0.930283] ACPI _OSC control for PCIe not granted, disabling ASPM
> [    0.933527] pci 0000:00:14.0: System wakeup disabled by ACPI
> [    0.935982] pci 0000:00:19.0: System wakeup disabled by ACPI
> [    0.937898] pci 0000:00:1a.0: System wakeup disabled by ACPI
> [    0.939835] pci 0000:00:1b.0: System wakeup disabled by ACPI
> [    0.940700] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
> [    0.942195] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
> [    0.943737] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
> [    0.944564] pci 0000:00:1c.2: System wakeup disabled by ACPI
> [    0.966491] pci 0000:00:1d.0: System wakeup disabled by ACPI
> 
> I must have pulled in the acpi bits the same time as the usb pull,
> because I don't recall seeing this problem before last night.

Can you please check if the problem is still there in the master branch of
the linux-pm.git tree alone?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
