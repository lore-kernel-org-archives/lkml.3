Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab3H0Lwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 07:52:36 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43775 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab3H0Lwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 07:52:34 -0400
MIME-Version: 1.0
In-Reply-To: <32637.1376969314@ale.ozlabs.ibm.com>
References: <32637.1376969314@ale.ozlabs.ibm.com>
Date: Tue, 27 Aug 2013 14:52:32 +0300
X-Google-Sender-Auth: fw4_86AMA40InLunggrIE0y9u4A
Message-ID: <CAOJsxLH_Mp=sp4kC04Ov2zYpZE6hU8abwxuxwai=V5pqBHCsVA@mail.gmail.com>
Subject: Re: [PATCH] kvm tools: powerpc: Fix init order for xics
From: Pekka Enberg <penberg@kernel.org>
To: Michael Neuling <mikey@neuling.org>
Cc: KVM General <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Ian Munsie <ianmunsi@au1.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 6:28 AM, Michael Neuling <mikey@neuling.org> wrote:
> xics_init() assumes kvm->nrcpus is already setup.  kvm->nrcpus is setup
> in kvm_cpu_init()
>
> Unfortunately xics_init() and kvm_cpu_init() both use base_init().  So
> depending on the order randomly determined by the compiler, xics_init()
> may initialised see kvm->nrcpus as 0 and not setup any of the icp VCPU
> pointers.  This manifests itself later in boot when trying to raise an
> IRQ resulting in a null pointer deference/segv.
>
> This moves xics_init() to use dev_base_init() to ensure it happens after
> kvm_cpu_init().
>
> Signed-off-by: Michael Neuling <mikey@neuling.org>

Applied, thanks a lot!
