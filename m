Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab3JWHoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:44:03 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22674 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3JWHoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:44:01 -0400
Date: Wed, 23 Oct 2013 09:43:34 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>
Cc: The development of GNU GRUB <grub-devel@gnu.org>,
        boris.ostrovsky@oracle.com, david.woodhouse@intel.com,
        ian.campbell@citrix.com, jbeulich@suse.com, keir@xen.org,
        konrad.wilk@oracle.com, pjones@redhat.com,
        richard.l.maliszewski@intel.com, ross.philipson@citrix.com,
        stefano.stabellini@eu.citrix.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131023074334.GS3626@debian70-amd64.local.net-space.pl>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <526599A8.9090501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <526599A8.9090501@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 11:16:24PM +0200, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> Mail is big, I think I got your essential points but I didn't read it whole.
> On 21.10.2013 14:57, Daniel Kiper wrote:
> > Hi,
> >
> > During work on multiboot2 protocol support for Xen it was discovered
> > that memory map passed via relevant tag could not represent wide range
> > of memory types available on EFI platforms. Additionally, GRUB2
> > implementation calls ExitBootServices() on them just before jumping
> > into loaded image. In this situation loaded system could not clearly
> > identify reserved memory regions, EFI runtime services regions and others.
> >
> Will a multiboot2 tag with whole EFI memory map solve your problem?
> > Additionally, it should be mentioned that there is no possibility or it could
> > be very difficult to implement secure boot on EFI platforms using GRUB2 as boot
> > loader because, as it was mentioned earlier, it calls ExitBootServices().
> >
> GRUB has generic support for signing kernels/modules/whatsoever using
> GnuPG signatures. You'd just have to ship xen.sig and kernel.sig. This
> method doesn't have any controversy associated with EFI stuff but at
> this particular case does exactly the same thing: verify signature.
> multiboot2 is mainly memory structure specification so probably how the
> files are checked is outside of its scope. But it's possible to add
> specification on how to embed signatures in kernel.

I think that EFI signatures should be supported because they are quite
common right now. However, I think that it is also worth to support
GnuPG signatures. This way anybody will be able to choose good solution
for a given case.

Daniel
