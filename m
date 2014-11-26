Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaKZRbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:31:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaKZRbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:31:14 -0500
Date: Wed, 26 Nov 2014 18:31:02 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        wanpeng.li@linux.intel.com, namit@cs.technion.ac.il,
        hpa@linux.intel.com, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [CFT PATCH v2 2/2] KVM: x86: support XSAVES usage in the host
Message-ID: <20141126173102.GA7770@potion.brq.redhat.com>
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com>
 <1416847414-22253-3-git-send-email-pbonzini@redhat.com>
 <20141126120753.GA31982@potion.redhat.com>
 <5475D20A.90505@redhat.com>
 <20141126135322.GA4887@potion.brq.redhat.com>
 <5475DC30.4010104@redhat.com>
 <20141126144252.GB4887@potion.brq.redhat.com>
 <5475FF50.4030400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5475FF50.4030400@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-26 17:26+0100, Paolo Bonzini:
> On 26/11/2014 15:42, Radim Krčmář wrote:
> >> I'm not sure what is more future proof. :)  I wonder if native_xrstor
> >> could be a problem the day XRSTORS actually sets/restores MSRs as the
> >> processor documentation promises.
> > 
> > XRSTORS won't affect the guest in any way, we are just going to use it
> > to convert the xsave, so any side-effects are going to stay in the host.
> > (This could break the host though.)
> 
> Yes, that's the problem. :)

(It would be a bug in Linux's xsave API, if we were using it correctly.)

> > My main presumption is that XSAVE*->XRSTOR*->XSAVE->XRSTOR has the same
> > result as XSAVE->XRSTOR, because we are only interested in the state,
> > not in any metadata.
> > (If it isn't possible to combine intructions, like XSAVE after XRSTORS,
> >  this solution won't work.)
> 
> Yes, that should be right.  But actually what KVM would do it is
> XRSTOR->XSAVE*->XRSTOR*->XSAVE.  The problem here is the side effects of
> doing XRSTORS far from a guest entry...

The entry can be aborted after doing XRSTORS, so we are going to know if
this doesn't work :)

>                                         though that would likely be
> handled by load_guest_fpu/put_guest_fpu.

Yes, I don't see a principal difference between manipulating xsave for
vmentry and this conversion, it can be wrapped in the same way.
