Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaHUNZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:25:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbaHUNZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:25:45 -0400
Message-ID: <53F5F346.5090105@redhat.com>
Date: Thu, 21 Aug 2014 15:25:26 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 1/6] KVM: add kvm_arch_sched_in
References: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com> <1408567997-21222-2-git-send-email-rkrcmar@redhat.com> <53F5ADF6.7060000@redhat.com> <20140821113801.GA20546@potion.brq.redhat.com> <53F5E5B1.6020106@redhat.com> <20140821125056.GE20453@potion.brq.redhat.com>
In-Reply-To: <20140821125056.GE20453@potion.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/08/2014 14:50, Radim Krčmář ha scritto:
> > > 
> > > All empty arch functions are in '.c' files, so it seems better to follow
> > > the same path.
> > > (And have one refactoring patch if GCC does not optimize this.)
> > 
> > GCC certainly does not optimize this (unless you use LTO).
> 
> I see LTO patches in next ... do we want to move every empty arch
> function into headers?

I wouldn't reject the patches.

(It would also save some lines of code, since in the headers it's common
to do "static inline void foo(void) {}" on a single line).

> (It is probably going to take LTO few years to be enabled by default.)

Indeed...  see also
http://lwn.net/SubscriberLink/608945/7763ad2aee106f1d/ from today's LWN
issue.

Paolo
