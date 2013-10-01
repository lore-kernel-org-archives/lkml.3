Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3JAJ57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 05:57:59 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36845 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3JAJ55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:57:57 -0400
Message-ID: <524A9CB3.6030103@redhat.com>
Date: Tue, 01 Oct 2013 11:58:11 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, gleb@redhat.com, agraf@suse.de,
        mpm@selenic.com, herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au> <1380177066-3835-3-git-send-email-michael@ellerman.id.au> <5243F933.7000907@redhat.com> <20131001083426.GB27484@concordia>
In-Reply-To: <20131001083426.GB27484@concordia>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/10/2013 10:34, Michael Ellerman ha scritto:
>> If you really want to have the hypercall, implementing it in QEMU means
>> that you can support it on all systems, in fact even when running
>> without KVM.  
> 
> Sure, I can add a fallback to /dev/hwrng for full emulation.
> 
>> The QEMU command line would be something like "-object
>> rng-random,filename=/dev/random,id=rng0 -device spapr-rng,rng=rng0".
> 
> We can't use /dev/random like that. The PAPR specification, which is
> what we're implementing, implies that H_RANDOM provides data from a
> hardware source.

Then use /dev/hwrng.

I don't have POWER machines, but I still want to be able to test as much
as possible using emulation.

Paolo
