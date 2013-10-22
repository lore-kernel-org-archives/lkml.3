Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3JVNxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 09:53:12 -0400
Received: from smtp.citrix.com ([66.165.176.89]:12950 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab3JVNxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 09:53:11 -0400
X-IronPort-AV: E=Sophos;i="4.93,548,1378857600"; 
   d="scan'208";a="66024250"
Message-ID: <1382449985.18283.12.camel@hastur.hellion.org.uk>
Subject: Re: EFI and multiboot2 devlopment work for Xen
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>, <ross.philipson@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <grub-devel@gnu.org>,
        <david.woodhouse@intel.com>, <richard.l.maliszewski@intel.com>,
        <xen-devel@lists.xen.org>, <boris.ostrovsky@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Peter Jones <pjones@redhat.com>, <linux-kernel@vger.kernel.org>,
        <keir@xen.org>
Date: Tue, 22 Oct 2013 14:53:05 +0100
In-Reply-To: <20131022134252.GA27302@phenom.dumpdata.com>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
	 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
	 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
	 <1382433990.1657.66.camel@hastur.hellion.org.uk>
	 <5266620602000078000FCA48@nat28.tlf.novell.com>
	 <1382435127.1657.70.camel@hastur.hellion.org.uk>
	 <526668A502000078000FCA7B@nat28.tlf.novell.com>
	 <20131022134252.GA27302@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-22 at 09:42 -0400, Konrad Rzeszutek Wilk wrote:

> Looking at the Fedora GRUB2 source, the 'struct linux_kernel_header' is defined
> in the linux/Documentation/x86/boot.txt and hpa is pretty strict
> about making it backwards compatible. It also seems to support Xen!
> 
> (Interestingly enough we do have this structure in the code: see
> setup_header in arch/x86/bzimage.c)

There will be another usage in tools/libxc/...bzimage too

FWIW I think we only use this stuff for the magic number/version and the
payload_offset/length fields, which we do in order to extract the
payload (ELF file) for booting dom0 and domU. It's not AFAIK used for
booting Xen itself or lets say, that's not why I added it ;-)).

> Which in the GRUB2 is being constructed by parsing the EFI
> data structures. But Linux concentrates on the EFI parts and mostly
> ignores the rest. So this is more about passing those EFI values
> downstream.

I wonder why Linux can't make the EFI calls to fetch them itself?

Ian.

