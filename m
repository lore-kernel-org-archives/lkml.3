Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaCNJ5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:57:41 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:36861 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaCNJ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:57:39 -0400
Message-ID: <5322D28C.9080009@redhat.com>
Date: Fri, 14 Mar 2014 10:57:32 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Gleb Natapov <gleb@kernel.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: fix cr8 intercept window
References: <1394561478-8815-1-git-send-email-rkrcmar@redhat.com> <20140312010513.GA8131@amt.cnet> <20140312104047.GA7488@potion.brq.redhat.com> <53209741.3060204@redhat.com> <20140313135206.GB30596@minantech.com> <20140313170846.GA23297@potion.brq.redhat.com>
In-Reply-To: <20140313170846.GA23297@potion.brq.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/03/2014 18:08, Radim Krčmář ha scritto:
> > I agree that old code is wrong and the patch looks correct, but I only
> > see how the bug may cause pending IRR to not be delivered in time,
> > not how interrupt can disrupt a higher priority task.

Right.  Also, on SMP guests the effect would likely be just a deadlock
if a lower-priority ISR interrupted a higher priority task and accessed 
shared data (since you need anyway a spinlock in addition to raising the 
IRQL).

A more likely explanation is that if the remote processor delays an IPI 
too much, it will have a stable TLB entry.  The resulting random 
corruption of paged memory is compatible with the BAD_POOL_HEADER error 
codes that Radim observed.

> Paolo, can you change the last sentence to ", which means we don't
> inject pending IRR immediately."?  (or do we just forget it?)

It's already in Linus's tree.

Paolo
