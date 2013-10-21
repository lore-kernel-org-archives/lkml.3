Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab3JUS6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 14:58:49 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22392 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3JUS6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 14:58:48 -0400
Date: Mon, 21 Oct 2013 20:57:58 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Peter Jones <pjones@redhat.com>
Cc: boris.ostrovsky@oracle.com, david.woodhouse@intel.com,
        ian.campbell@citrix.com, jbeulich@suse.com, keir@xen.org,
        konrad.wilk@oracle.com, richard.l.maliszewski@intel.com,
        ross.philipson@citrix.com, stefano.stabellini@eu.citrix.com,
        xen-devel@lists.xen.org, grub-devel@gnu.org,
        linux-kernel@vger.kernel.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131021135437.GD1283@fenchurch.internal.datastacks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 09:54:38AM -0400, Peter Jones wrote:
> On Mon, Oct 21, 2013 at 02:57:56PM +0200, Daniel Kiper wrote:
> > Hi,
> >
> > During work on multiboot2 protocol support for Xen it was discovered
> > that memory map passed via relevant tag could not represent wide range
> > of memory types available on EFI platforms. Additionally, GRUB2
> > implementation calls ExitBootServices() on them just before jumping
> > into loaded image. In this situation loaded system could not clearly
> > identify reserved memory regions, EFI runtime services regions and others.
>
> I think you'll find that many distros are shipping patches to grub2 to
> add a "linuxefi" command that starts the kernel through its EFISTUB
> code.  You may want to look in to that.

I am referring to that patches in my initial email. However, I think that
we are not able to use them directly (correct me if I am wrong) because
Xen does not use Linux Boot protocol. I thought that it is worth to
migrate to multiboot2 protocol if Xen supports earlier multiboot protocol
version. As I understood you are suggesting to drop multiboot2 idea and
prepare something similar to linuxefi. It should pass only needed things
to Xen and later Xen itself should get required stuff from EFI directly.
Finally it should call ExitBootSerices(). Is it correct?

Daniel
