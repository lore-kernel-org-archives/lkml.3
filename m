Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3IZSzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:55:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47784 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab3IZSzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:55:39 -0400
Date: Thu, 26 Sep 2013 20:55:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Eduardo Habkost <ehabkost@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre@andrep.de>,
        Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        KVM <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        libvir-list@redhat.com, Jiri Denemark <jdenemar@redhat.com>
Subject: Re: [PATCH 1/6] kvm: Add KVM_GET_EMULATED_CPUID
Message-ID: <20130926185524.GA10123@pd.tnic>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
 <1379861095-628-2-git-send-email-bp@alien8.de>
 <20130923162856.GC7264@otherpad.lan.raisama.net>
 <2f5d83d4d90ba9c5930f099d6f73e61b.squirrel@www.skyhub.de>
 <20130924100414.GE17294@redhat.com>
 <20130926141915.GV2840@otherpad.lan.raisama.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130926141915.GV2840@otherpad.lan.raisama.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 11:19:15AM -0300, Eduardo Habkost wrote:
> Then we may have a problem: some CPU models already have "movbe"
> included (e.g. Haswell), and patch 6/6 will make "-cpu Haswell" get
> movbe enabled even if it is being emulated.

Huh? HSW has MOVBE so we won't #UD on it and MOVBE will get executed in
hardware when executing the guest. IOW, we'll never get to the emulation
path of piggybacking on the #UD.

> So if we really want to avoid enabling emulated features by mistake,
> we may need a new CPU flag in addition to "enforce" to tell QEMU that
> it is OK to enable emulated features (maybe "-cpu ...,emulate"?).

EMULATED_CPUID are off by default and only if you request them
specifically, they get enabled. If you start with "-cpu Haswell", MOVBE
will be already set in the host CPUID.

Or am I missing something?

> But my question still stands: suppose we had x2apic emulation
> implemented but for some reason it was painfully slow, we wouldn't
> want to enable it by mistake. In this case, it would end up on
> EMULATED_CPUID and not on SUPPORTED_CPUID, right?

IMHO we want to enable emulation only when explicitly requested...
regardless of the emulation performance.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
