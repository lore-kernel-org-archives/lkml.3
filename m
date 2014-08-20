Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbaHTMqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:46:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbaHTMqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:46:19 -0400
Date: Wed, 20 Aug 2014 14:46:08 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: Re: [PATCH 5/9] KVM: VMX: clamp PLE window
Message-ID: <20140820124607.GD28873@potion.brq.redhat.com>
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
 <1408480536-8240-6-git-send-email-rkrcmar@redhat.com>
 <53F44BAE.9040405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F44BAE.9040405@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-20 09:18+0200, Paolo Bonzini:
> Il 19/08/2014 22:35, Radim Krčmář ha scritto:
> > Modifications could get unwanted values of PLE window. (low or negative)
> > Use ple_window and the maximal value that cannot overflow as bounds.
> > 
> > ple_window_max defaults to a very high value, but it would make sense to
> > set it to some fraction of the scheduler tick.
> > 
> > Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> > ---
> Please introduce a dynamic overflow-avoiding ple_window_max (like what
> you have in patch 9) already in patch 4...
> 
> >  static void shrink_ple_window(struct kvm_vcpu *vcpu)
> > @@ -5720,7 +5724,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
> >  	else
> >  		new = old - ple_window_shrink;
> >  
> > -	vmx->ple_window = new;
> > +	vmx->ple_window = max(new, ple_window);
> 
> ... and also squash this in patch 4.
> 
> This patch can then introduce the ple_window_max module parameter (using
> module_param_cb to avoid overflows).

Will do.

---
It is going to make the patches slightly harder to review;
Are we doing it because git doesn't bisect on series boundaries?
