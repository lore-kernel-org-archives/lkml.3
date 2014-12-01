Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaLARzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:55:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbaLARzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:55:16 -0500
Date: Mon, 1 Dec 2014 18:55:06 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>, Nadav Amit <namit@cs.technion.ac.il>
Subject: Re: [PATCH 0/4] KVM: x86: APIC fixes
Message-ID: <20141201175505.GA22851@potion.brq.redhat.com>
References: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com>
 <547C95B8.7020300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547C95B8.7020300@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-01 17:22+0100, Paolo Bonzini:
> On 27/11/2014 20:03, Radim Krčmář wrote:
> > The interesting one is [3/4], which improves upon a previous CVE fix;
> > we also handle logical destination wrapping in it, so [2/4] does the
> > same for physical;  and to make it nicer, [1/4] removes a condition.
> > [4/4] makes our fast path return true when the message was handled.
> > 
> > Radim Krčmář (4):
> >   KVM: x86: deliver phys lowest-prio
> >   KVM: x86: fix APIC physical destination wrapping
> >   KVM: x86: allow 256 logical x2APICs again
> >   KVM: x86: don't retry hopeless APIC delivery
> > 
> >  arch/x86/kvm/lapic.c | 20 +++++++++++---------
> >  arch/x86/kvm/lapic.h |  2 --
> >  2 files changed, 11 insertions(+), 11 deletions(-)
> > 
> 
> So the order should be 1/2/5/3/4, right?

It would be safer, thank you.

(And when I look at it now, [4/4] would be better as 1st.)
