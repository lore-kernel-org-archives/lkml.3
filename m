Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab3JVJ0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 05:26:35 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25593 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3JVJ0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 05:26:34 -0400
X-IronPort-AV: E=Sophos;i="4.93,547,1378857600"; 
   d="scan'208";a="63266803"
Message-ID: <1382433990.1657.66.camel@hastur.hellion.org.uk>
Subject: Re: EFI and multiboot2 devlopment work for Xen
From: Ian Campbell <ian.campbell@citrix.com>
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: Peter Jones <pjones@redhat.com>, <boris.ostrovsky@oracle.com>,
        <david.woodhouse@intel.com>, <jbeulich@suse.com>, <keir@xen.org>,
        <konrad.wilk@oracle.com>, <richard.l.maliszewski@intel.com>,
        <ross.philipson@citrix.com>, <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xen.org>, <grub-devel@gnu.org>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 22 Oct 2013 10:26:30 +0100
In-Reply-To: <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
	 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
	 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-21 at 20:57 +0200, Daniel Kiper wrote:
> On Mon, Oct 21, 2013 at 09:54:38AM -0400, Peter Jones wrote:
> > On Mon, Oct 21, 2013 at 02:57:56PM +0200, Daniel Kiper wrote:
> > > Hi,
> > >
> > > During work on multiboot2 protocol support for Xen it was discovered
> > > that memory map passed via relevant tag could not represent wide range
> > > of memory types available on EFI platforms. Additionally, GRUB2
> > > implementation calls ExitBootServices() on them just before jumping
> > > into loaded image. In this situation loaded system could not clearly
> > > identify reserved memory regions, EFI runtime services regions and others.
> >
> > I think you'll find that many distros are shipping patches to grub2 to
> > add a "linuxefi" command that starts the kernel through its EFISTUB
> > code.  You may want to look in to that.
> 
> I am referring to that patches in my initial email. However, I think that
> we are not able to use them directly (correct me if I am wrong) because
> Xen does not use Linux Boot protocol.

AIUI "efilinux" is somewhat badly named and does not use the Linux Boot
Protocol (i.e. the (b)zImage stuff with real mode entry point) either.
It actually loads and executes the kernel binary as a PE/COFF executable
(the native UEFI binary executable format). xen.efi is a PE/COFF binary
too and could equally well be launched by linuxefi in this way.

Ian.

