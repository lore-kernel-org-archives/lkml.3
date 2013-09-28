Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab3I1KtN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 06:49:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50028 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab3I1KtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 06:49:08 -0400
Date: Sat, 28 Sep 2013 12:49:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Eduardo Habkost <ehabkost@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre@andrep.de>,
        Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        KVM <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        libvir-list@redhat.com, Jiri Denemark <jdenemar@redhat.com>
Subject: Re: [PATCH 1/6] kvm: Add KVM_GET_EMULATED_CPUID
Message-ID: <20130928104903.GB5956@pd.tnic>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
 <1379861095-628-2-git-send-email-bp@alien8.de>
 <20130923162856.GC7264@otherpad.lan.raisama.net>
 <2f5d83d4d90ba9c5930f099d6f73e61b.squirrel@www.skyhub.de>
 <20130924100414.GE17294@redhat.com>
 <20130926141915.GV2840@otherpad.lan.raisama.net>
 <20130926185524.GA10123@pd.tnic>
 <20130926192059.GD10924@otherpad.lan.raisama.net>
 <20130926203206.GB10123@pd.tnic>
 <20130927142100.GB2840@otherpad.lan.raisama.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130927142100.GB2840@otherpad.lan.raisama.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 11:21:34AM -0300, Eduardo Habkost wrote:
> The problem here is that "requested_features" doesn't include just
> the explicit "+flag" flags, but any flag included in the CPU model
> definition. See the "-cpu n270" example below.

Oh, you mean if requested_features would contain a flag included from
the CPU model definition - a flag which we haven't requested explicitly
- and if kvm emulates that flag, then it will get enabled?

Hmm.

> It should, but your patch will make it stop failing because of MOVBE, as
> now it can be emulated[1].

Right.

> "enforce" makes sure all features are really being enabled. It makes
> QEMU abort if there's any feature that can't be enabled on that host.

Ok.

> [1] Maybe one source of confusion is that the existing code have two
> feature-filtering functions doing basically the same thing:
> filter_features_for_kvm() and kvm_check_features_against_host().  That's

Yes, and the first gets executed unconditionally and does the feature
filtering,  right after the second has run in the kvm_enabled() branch.

> something we must clean up, and they should be unified. "enforce" should
> become synonymous to "make sure filtered_features is all zeroes".  This
> way, libvirt can emulate what 'enforce" does while being able to collect
> detailed error information (which is not easy to do if QEMU simply
> aborts).

Ok, maybe someone who's more knowledgeable with this code should do it -
not me :)

Also, there's another aspect, while we're here: now that QEMU emulates
MOVBE with TCG too, how do we specify on the command line, which
emulation should be used - kvm.ko or QEMU?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
