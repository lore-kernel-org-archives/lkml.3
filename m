Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab3JVJpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 05:45:32 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:28655 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3JVJpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 05:45:31 -0400
X-IronPort-AV: E=Sophos;i="4.93,547,1378857600"; 
   d="scan'208";a="63272525"
Message-ID: <1382435127.1657.70.camel@hastur.hellion.org.uk>
Subject: Re: EFI and multiboot2 devlopment work for Xen
From: Ian Campbell <ian.campbell@citrix.com>
To: Jan Beulich <JBeulich@suse.com>
CC: <ross.philipson@citrix.com>, <stefano.stabellini@eu.citrix.com>,
        <grub-devel@gnu.org>, <david.woodhouse@intel.com>,
        <richard.l.maliszewski@intel.com>, <xen-devel@lists.xen.org>,
        <boris.ostrovsky@oracle.com>, Daniel Kiper <daniel.kiper@oracle.com>,
        <konrad.wilk@oracle.com>, Peter Jones <pjones@redhat.com>,
        <linux-kernel@vger.kernel.org>, <keir@xen.org>
Date: Tue, 22 Oct 2013 10:45:27 +0100
In-Reply-To: <5266620602000078000FCA48@nat28.tlf.novell.com>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
	 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
	 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
	 <1382433990.1657.66.camel@hastur.hellion.org.uk>
	 <5266620602000078000FCA48@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-22 at 10:31 +0100, Jan Beulich wrote:
> >>> On 22.10.13 at 11:26, Ian Campbell <ian.campbell@citrix.com> wrote:
> > AIUI "efilinux" is somewhat badly named and does not use the Linux Boot
> > Protocol (i.e. the (b)zImage stuff with real mode entry point) either.
> > It actually loads and executes the kernel binary as a PE/COFF executable
> > (the native UEFI binary executable format). xen.efi is a PE/COFF binary
> > too and could equally well be launched by linuxefi in this way.
> 
> Except that unless I'm mistaken "linuxefi" still expects to find certain
> Linux-specific internal data structures inside the PE image, which I
> don't see us wanting to be emulating. That's the main difference to
> "chainloader" afaict.

Ah, I'd been led to believe it was just the lack of a call to
ExitBootServices, but I didn't check. What you say sounds completely
plausible.

Do you know what sort of Linux specific data structures are we talking
about?

Ian.

