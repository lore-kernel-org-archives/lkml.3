Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaEOKSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:18:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbaEOKSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:18:22 -0400
Date: Thu, 15 May 2014 12:18:12 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kvm: increase max vcpu count
Message-ID: <20140515101811.GA16070@potion.brq.redhat.com>
References: <1400147417-22269-1-git-send-email-zhen-hual@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400147417-22269-1-git-send-email-zhen-hual@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-15 17:50+0800, Li, Zhen-Hua:
> This patch is trying to increase the maximum supported vcpu number.
> 
> There has been big system supporting more than 256 logical CPUs, and vmware
> can also support guest system with more than logical 256 CPUs. So kvm should 
> also increase the maximum supported cpu number.

How did it work?
KVM lapic does not handle more more than 256 [1] at the moment, so
additional VCPUs had to wraparound ...

---
1: "struct kvm_apic_map" has "struct kvm_lapic *phys_map[256]" and we
   are using "& 0xff" when dealing with it, too.
