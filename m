Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab3JVPdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:33:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45470 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab3JVPdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:33:35 -0400
Date: Tue, 22 Oct 2013 16:32:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@suse.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "ross.philipson@citrix.com" <ross.philipson@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>,
        "Maliszewski, Richard L" <richard.l.maliszewski@intel.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Peter Jones <pjones@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keir@xen.org" <keir@xen.org>
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131022153258.GA12260@srcf.ucam.org>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
 <1382433990.1657.66.camel@hastur.hellion.org.uk>
 <5266620602000078000FCA48@nat28.tlf.novell.com>
 <1382435127.1657.70.camel@hastur.hellion.org.uk>
 <526668A502000078000FCA7B@nat28.tlf.novell.com>
 <20131022134252.GA27302@phenom.dumpdata.com>
 <20131022144309.GA18547@phenom.dumpdata.com>
 <1382455537.8512.11.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382455537.8512.11.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 03:25:39PM +0000, Woodhouse, David wrote:

> Oh, ignore that. You want the *actual* PE executable entry point, as it
> would get invoked by a real UEFI firmware.

There are two problems with this:

1) The kernel will only boot if it's signed with a key in db, not a key 
in MOK.
2) grub will read the kernel, but the kernel will have to read the 
initramfs using EFI calls. That means your initramfs must be on a FAT 
partition.

If you're happy with those limitations then just use the chainloader 
command. If you're not, use the linuxefi command.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
