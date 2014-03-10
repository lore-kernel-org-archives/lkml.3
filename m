Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaCJMRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:17:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbaCJMRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:17:18 -0400
Date: Mon, 10 Mar 2014 13:17:04 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        alex.williamson@redhat.com, mtosatti@redhat.com, gleb@kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH 4/7] KVM: vmx: Allow the guest to run with dirty debug
 registers
Message-ID: <20140310121704.GB16023@potion.brq.redhat.com>
References: <1394192571-11056-1-git-send-email-pbonzini@redhat.com>
 <1394192571-11056-5-git-send-email-pbonzini@redhat.com>
 <20140309182639.GA10479@potion.redhat.com>
 <531CCB15.6070402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <531CCB15.6070402@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-09 21:12+0100, Paolo Bonzini:
> Il 09/03/2014 19:26, Radim Krčmář ha scritto:
> >> +
> >> +		/*
> >> +		 * No more DR vmexits; force a reload of the debug registers
> >> +		 * and reenter on this instruction.  The next vmexit will
> >> +		 * retrieve the full state of the debug registers.
> >> +		 */
> >> +		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_WONT_EXIT;
> >> +		return 1;
> >> +	}
> >> +
> >
> >We could make the code slighly uglier and move the functional part of
> >this block before the previous one, so it would do both things in one
> >exit.
> 
> I considered this, but decided that it's unlikely for emulation to
> be faster than hardware---especially on those AMD CPUs that lack
> decode assists (and it's good for VMX and SVM code to look as
> similar as possible).

I meant to move it before the block that exits if there is the
'exception on access' bit set in cr7, so we wouldn't exit again right
away on the actual access, which is quite likely.
(Exiting without emulation was a great move.)

> >(Exception handler will likely access DR too.)
> 
> Which exception handler?

For #DB. (Pure guesswork, I haven't seen any of them.)
