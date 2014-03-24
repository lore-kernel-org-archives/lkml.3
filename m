Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaCXTau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:30:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbaCXTas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:30:48 -0400
Date: Mon, 24 Mar 2014 20:28:27 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gleb@kernel.org,
        mtosatti@redhat.com, alex.williamson@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 4/4] KVM: ioapic: reinject pending interrupts on
 KVM_SET_IRQCHIP
Message-ID: <20140324192826.GB9440@potion.brq.redhat.com>
References: <1395394081-16252-1-git-send-email-pbonzini@redhat.com>
 <1395394081-16252-5-git-send-email-pbonzini@redhat.com>
 <20140324175830.GA8721@potion.brq.redhat.com>
 <533075F9.3050007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <533075F9.3050007@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-24 19:14+0100, Paolo Bonzini:
> Il 24/03/2014 18:58, Radim Krčmář ha scritto:
> > I'd prefer 'ioapic->irr = 0' here ...)
> 
> The point is that "ioapic->irr = 0" is overriding the previous
> memcpy, because state->irr is used as argument to
> kvm_ioapic_inject_all instead.  So I think "iopic->irr = 0" should
> stay close to the memcpy.

Yeah, I was just spouting ... my reasoning was that we clear irr only
because it's going to be recomputed, so that code is more related.
(The function name would need to change though.)
