Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbaIXLoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:44:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36808 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750725AbaIXLoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:44:37 -0400
Date: Wed, 24 Sep 2014 12:44:36 +0100
From: Will Deacon <will.deacon@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>,
        Alex Williamson <Alex.Williamson@redhat.com>
Subject: Re: [PATCH] kvm-vfio: do not use module_init
Message-ID: <20140924114435.GD28823@arm.com>
References: <1411558149-3609-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411558149-3609-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:29:09PM +0100, Paolo Bonzini wrote:
> /me got confused between the kernel and QEMU.  In the kernel, you can
> only have one module_init function, and it will prevent unloading the
> module unless you also have the corresponding module_exit function.

Happy for you to take the blame, but I think this one's my fault!

> So, commit 80ce1639727e (KVM: VFIO: register kvm_device_ops dynamically,
> 2014-09-02) broke unloading of the kvm module, by adding a module_init
> function and no module_exit.

I forget kvm builds as a module for other architectures (ie. not arm/arm64).

> Repair it by making kvm_vfio_ops_init weak, and checking it in
> kvm_init.

Hehe, if only there was a kconfig option for kvm-vfio.c...

Will
