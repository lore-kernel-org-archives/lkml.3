Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab3JBOgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:36:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab3JBOgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:36:11 -0400
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on some powernv systems
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <524C2EAE.7090209@redhat.com>
Date: Wed, 2 Oct 2013 16:36:05 +0200
Cc: Michael Ellerman <michael@ellerman.id.au>, Gleb Natapov <gleb@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        mpm@selenic.com, herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Content-Transfer-Encoding: 7BIT
Message-Id: <C4834CF8-F81C-4B82-B1A7-1751D50AADB7@suse.de>
References: <5243F933.7000907@redhat.com> <20131001083426.GB27484@concordia> <20131001083908.GA17294@redhat.com> <1380620338.645.22.camel@pasglop> <524AAFAA.3010801@redhat.com> <20131002050940.GA25363@drongo> <524BDD73.3020106@redhat.com> <1380704789.645.57.camel@pasglop> <668E4650-BC22-4CBF-A282-E7875DF29DB6@suse.de> <3CBF5732-E7EE-4C96-8132-6D7B77270DAF@suse.de> <20131002100224.GF17294@redhat.com> <1380722275.12149.28.camel@concordia> <029A8D6C-C23C-42B2-8C26-D76B59E2C9DD@suse.de> <524C2EAE.7090209@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02.10.2013, at 16:33, Paolo Bonzini wrote:

> Il 02/10/2013 16:08, Alexander Graf ha scritto:
>>> The hwrng is accessible by host userspace via /dev/mem.
>> 
>> A guest should live on the same permission level as a user space
>> application. If you run QEMU as UID 1000 without access to /dev/mem, why
>> should the guest suddenly be able to directly access a memory location
>> (MMIO) it couldn't access directly through a normal user space interface.
>> 
>> It's basically a layering violation.
> 
> With Michael's earlier patch in this series, the hwrng is accessible by
> host userspace via /dev/hwrng, no?

Yes, but there's not token from user space that gets passed into the kernel to check whether access is ok or not. So while QEMU may not have permission to open /dev/hwrng it could spawn a guest that opens it, drains all entropy out of it and thus stall other processes which try to fetch entropy, no?

Maybe I haven't fully grasped the interface yet though :).


Alex

