Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab3JUNgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 09:36:46 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49394 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab3JUNgp convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Mon, 21 Oct 2013 09:36:45 -0400
Message-Id: <52654A0602000078000FC611@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 21 Oct 2013 14:36:38 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Kiper" <daniel.kiper@oracle.com>
Cc: <ian.campbell@citrix.com>, <ross.philipson@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <grub-devel@gnu.org>,
        <david.woodhouse@intel.com>, <richard.l.maliszewski@intel.com>,
        "xen-devel" <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <konrad.wilk@oracle.com>,
        <pjones@redhat.com>, <linux-kernel@vger.kernel.org>, <keir@xen.org>
Subject: Re: EFI and multiboot2 devlopment work for Xen
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
In-Reply-To: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.10.13 at 14:57, Daniel Kiper <daniel.kiper@oracle.com> wrote:

(Looking at the Cc list it's quite interesting that you copied a
whole lot of people, but not me as the maintainer of the EFI
bits in Xen.)

> Separate multiboot2efi module should be established. It should verify system
> kernel and all loaded modules using shim on EFI platforms with enabled 
> secure boot

Each involved component verifies only the next image. I.e. the
shim verifies the Xen image, and Xen verifies the Dom0 kernel
binary. The Dom0 kernel (assuming it to be Linux) will then be
responsible for dealing with its initrd. (One open question is how
Xen ought to deal with an eventual XSM module; I take it that
the CPUs themselves take care of the microcode blob.) This can't
be different because the shim provided verification protocol
assumes that it's being handed a PE image (hence the need for
Linux to package itself as a fake PE image), and hence can't be
used for verifying other than the Xen and Dom0 kernel binaries.

> At first I am going to prepare multiboot2 protocol implementation for Xen 
> (there
> is about 80% of code ready) with above mentioned workaround.

Is that really worthwhile as long as it's not clear whether ...

> Later I am going to work on multiboot2efi module.

... is going to be accepted?

> What do you think about that?
> Any comments, suggestions, objections?

The complications here make it pretty clear to me that the
GrUB2-less solution (or, if GruB2 absolutely has to be involved,
its chain loading capability) I have been advocating continues
to be the better (and, as said before, conceptually correct)
model.

Jan

