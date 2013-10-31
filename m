Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab3JaOtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 10:49:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab3JaOtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:49:08 -0400
Message-ID: <52726DE0.3060207@redhat.com>
Date: Thu, 31 Oct 2013 15:49:04 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: emulate SAHF instruction
References: <1383215382-10072-1-git-send-email-pbonzini@redhat.com> <20131031142119.GS4651@redhat.com> <527268E4.2070505@redhat.com> <20131031143405.GT4651@redhat.com>
In-Reply-To: <20131031143405.GT4651@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 31/10/2013 15:34, Gleb Natapov ha scritto:
> I haven't checked AMD doc, but if it is documented that lahf/sahf #UDs at 64
> bit we should emulate it correctly.

It says "The LAHF instruction can only be executed in 64-bit mode if
supported by the processor implementation. Check the status of ECX bit 0
returned by CPUID function 8000_0001h to verify that the processor
supports LAHF in 64-bit mode".  Same as Intel---in fact 80000001h is an
"AMD leaf" so to speak.

I found "AMD introduced support for the instructions with their Athlon
64, Opteron and Turion 64 revision D processors in March 2005 and Intel
introduced support for the instructions with the Pentium 4 G1 stepping
in December 2005".  I think we can for all practical purposes ignore the
lahf_lm CPUID flag.

> Who knows what code depends on it.
> Of course I pretty much doubt we will ever emulate sahf in 64 bit mode

Yep.

Paolo

