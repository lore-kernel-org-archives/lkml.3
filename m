Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab3JVJbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 05:31:25 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:56742 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3JVJbX convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Tue, 22 Oct 2013 05:31:23 -0400
Message-Id: <5266620602000078000FCA48@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 22 Oct 2013 10:31:18 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ian Campbell" <ian.campbell@citrix.com>
Cc: <ross.philipson@citrix.com>, <stefano.stabellini@eu.citrix.com>,
        <grub-devel@gnu.org>, <david.woodhouse@intel.com>,
        <richard.l.maliszewski@intel.com>, <xen-devel@lists.xen.org>,
        <boris.ostrovsky@oracle.com>, "Daniel Kiper" <daniel.kiper@oracle.com>,
        <konrad.wilk@oracle.com>, "Peter Jones" <pjones@redhat.com>,
        <linux-kernel@vger.kernel.org>, <keir@xen.org>
Subject: Re: EFI and multiboot2 devlopment work for Xen
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
 <1382433990.1657.66.camel@hastur.hellion.org.uk>
In-Reply-To: <1382433990.1657.66.camel@hastur.hellion.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.10.13 at 11:26, Ian Campbell <ian.campbell@citrix.com> wrote:
> AIUI "efilinux" is somewhat badly named and does not use the Linux Boot
> Protocol (i.e. the (b)zImage stuff with real mode entry point) either.
> It actually loads and executes the kernel binary as a PE/COFF executable
> (the native UEFI binary executable format). xen.efi is a PE/COFF binary
> too and could equally well be launched by linuxefi in this way.

Except that unless I'm mistaken "linuxefi" still expects to find certain
Linux-specific internal data structures inside the PE image, which I
don't see us wanting to be emulating. That's the main difference to
"chainloader" afaict.

Jan

