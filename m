Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab3JWQOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 12:14:23 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:51837 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab3JWQOV convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Wed, 23 Oct 2013 12:14:21 -0400
Message-Id: <526803E902000078000A56D3@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 23 Oct 2013 17:14:17 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <ian.campbell@citrix.com>, <konrad.wilk@oracle.com>
Cc: <ross.philipson@citrix.com>, <stefano.stabellini@eu.citrix.com>,
        <grub-devel@gnu.org>, <david.woodhouse@intel.com>,
        <richard.l.maliszewski@intel.com>, <xen-devel@lists.xen.org>,
        <boris.ostrovsky@oracle.com>, <daniel.kiper@oracle.com>,
        <pjones@redhat.com>, <mjg59@srcf.ucam.org>,
        <linux-kernel@vger.kernel.org>, <keir@xen.org>
Subject: Re: [Xen-devel] EFI and multiboot2 devlopment work for Xen
References: <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
 <1382433990.1657.66.camel@hastur.hellion.org.uk>
 <5266620602000078000FCA48@nat28.tlf.novell.com>
 <1382435127.1657.70.camel@hastur.hellion.org.uk>
 <526668A502000078000FCA7B@nat28.tlf.novell.com>
 <20131022134252.GA27302@phenom.dumpdata.com>
 <1382449985.18283.12.camel@hastur.hellion.org.uk>
 <20131022140947.GA17829@phenom.dumpdata.com>
 <1382451868.18283.21.camel@hastur.hellion.org.uk>
 <1382455358.18283.31.camel@hastur.hellion.org.uk>
 <20131022162632.GB19189@phenom.dumpdata.com>
 <1382517150.22417.21.camel@hastur.hellion.org.uk>
In-Reply-To: <1382517150.22417.21.camel@hastur.hellion.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ian Campbell <ian.campbell@citrix.com> 10/23/13 10:32 AM >>>
>The second (standard PE/COFF entry point) can be launched using the UEFI
>chainloader call. AIUI this should work with xen.efi today. There are
>some limitations however, firstly there is no way to pass additional
>blobs and so the launched image must load e.g. dom0 and initrd itself,
>which Linux does by processing the initrd= option in the command line
>and using UEFI functionality to load the blobs from disk. Xen does by
>reading its own config file and loading dom0 + initrd based on that. I
>assume this means that chainload doesn't call ExitBootServices (anyone
>can confirm?). Another limitation of this is that the UEFI functionality
>to load stuff from disk can only read from FAT partitions.

Again that's only a pseudo limitation: Rather than implementing support
for other file systems in GrUB, it should be implemented as EFI module.
Then any subsequent EFI binary would benefit from this. (Obviously, as
a half hearted intermediate solution, GrUB - which iiuc stays in memory
after transferring control - could export its file system support to its
descendants).

> It's not
>clear to me if this mechanism limits only the loading of additional
>blobs from FAT or if that applies to the kernel image itself.

Only the additional blobs would be affected.

> The
>kernel is PIC on entry so no relocations are actually needed. In theory
>the Linux EFI stub could instead have included a NULL relocation table
>but doesn't. (I expect Xen is in the same boat WRT relocations).

No, Xen definitely needs its relocations processed.

Jan

