Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaIKW0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:26:46 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:56588 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbaIKW0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:26:43 -0400
MIME-Version: 1.0
In-Reply-To: <2354837.kuMZPK0Y1Q@segfault>
References: <2354837.kuMZPK0Y1Q@segfault>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 11 Sep 2014 16:26:21 -0600
Message-ID: <CAErSpo6zLY8RVAHnLe81jjOE8cxGzskjPq3HL7eZVOtC-WF6=w@mail.gmail.com>
Subject: Re: [3.16-rcX][pciehp][radeon] PCIe HotPlug conflicts with radeon GPU
To: Shawn Starr <shawn.starr@rogers.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci]

On Sat, Aug 2, 2014 at 10:02 AM, Shawn Starr <shawn.starr@rogers.com> wrote:
> Hello devs,
>
> There are two issues I am encountering with the PCIe Hotplug driver on my Lenovo Laptop (W500). I note this goes back further than 3.15.
>
> It is noted here:
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=f244d8b623dae7a7bc695b0336f67729b95a9736
> https://bugzilla.kernel.org/show_bug.cgi?id=79701
>
> And my open bug here:
> https://bugzilla.kernel.org/show_bug.cgi?id=77261
>
> 1) If I enable the device to use both the integrated and discrete GPU, pciehp will decide to force unload radeon because it puts itself into a power saving state, fails back to the Intel integrated GPU in this case unless I tell radeon.ko to runpm=0 (no power management, then pciehp wont touch it).
>
> 2) If the Radeon GPU resets and you use pci_reset=1 for kernel module option, pciehp decides to force unload radeon even though the GPU is trying to setup after failing.
>
> Kernel I am using right now: 3.16.0-0.rc7.git3.1.fc21.x86_64 (about to boot into snapshot kernel-core-3.16.0-0.rc7.git4.1.fc21.x86_64)

Hi Shawn,

Thanks for the report and sorry that it got dropped.  But I see you're
cc'd on https://bugzilla.kernel.org/show_bug.cgi?id=79701, so you've
probably seen the work there.  If you can try out the patches I just
posted, that would be great.

Bjorn
