Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbaJGMHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:07:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45408 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbaJGMHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:07:09 -0400
Date: Tue, 7 Oct 2014 13:06:59 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Message-ID: <20141007120659.GA30590@e102568-lin.cambridge.arm.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
 <2430078.s4snyh5OoF@wuerfel>
 <20141001084626.GZ841@e106497-lin.cambridge.arm.com>
 <3256560.C0cZnIlnAv@wuerfel>
MIME-Version: 1.0
In-Reply-To: <3256560.C0cZnIlnAv@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 07 Oct 2014 12:07:02.0896 (UTC) FILETIME=[3478AF00:01CFE227]
X-MC-Unique: 114100713070300201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:38:45AM +0100, Arnd Bergmann wrote:

[...]

> pci_mmap_page_range could either get generalized some more in an attempt
> to have a __weak default implementation that works on ARM, or it could
> be changed to lose the dependency on pci_sys_data instead. In either
> case, the change would involve using the generic pci_host_bridge_window
> list.

On ARM pci_mmap_page_range requires pci_sys_data to retrieve its
mem_offset parameter. I had a look, and I do not understand *why*
it is required in that function, so I am asking. That function
is basically used to map PCI resources to userspace, IIUC, through
/proc or /sysfs file mappings. As far as I understand those mappings
expect VMA pgoff to be the CPU address when files representing resources
are mmapped from /proc and 0 when mmapped from /sys (I mean from
userspace, then VMA pgoff should be updated by the kernel to map the
resource).

Question is: why pci_mmap_page_range() should apply an additional
shift to the VMA pgoff based on pci_sys_data.mem_offset, which represents
the offset from cpu->bus offset. I do not understand that. PowerPC
does not seem to apply that fix-up (in PowerPC __pci_mmap_make_offset there
is commented out code which prevents the pci_mem_offset shift to be
applied). I think it all boils down to what the userspace interface is
expecting when the memory areas are mmapped, if anyone has comments on
this that is appreciated.

Thanks,
Lorenzo

