Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaIXLqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:46:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbaIXLqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:46:04 -0400
Message-ID: <5422AEF1.8010008@redhat.com>
Date: Wed, 24 Sep 2014 13:45:53 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>,
        Alex Williamson <Alex.Williamson@redhat.com>
Subject: Re: [PATCH] kvm-vfio: do not use module_init
References: <1411558149-3609-1-git-send-email-pbonzini@redhat.com> <20140924114435.GD28823@arm.com>
In-Reply-To: <20140924114435.GD28823@arm.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/09/2014 13:44, Will Deacon ha scritto:
> On Wed, Sep 24, 2014 at 12:29:09PM +0100, Paolo Bonzini wrote:
>> /me got confused between the kernel and QEMU.  In the kernel, you can
>> only have one module_init function, and it will prevent unloading the
>> module unless you also have the corresponding module_exit function.
> 
> Happy for you to take the blame, but I think this one's my fault!

That's why you were CCed! ;)

>> So, commit 80ce1639727e (KVM: VFIO: register kvm_device_ops dynamically,
>> 2014-09-02) broke unloading of the kvm module, by adding a module_init
>> function and no module_exit.
> 
> I forget kvm builds as a module for other architectures (ie. not arm/arm64).
> 
>> Repair it by making kvm_vfio_ops_init weak, and checking it in
>> kvm_init.
> 
> Hehe, if only there was a kconfig option for kvm-vfio.c...

Yeah, I was tempted to put it back.  What do you think?

Paolo

