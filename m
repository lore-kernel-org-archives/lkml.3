Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbbAVOtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:49:43 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:61134 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753784AbbAVOti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:49:38 -0500
Message-ID: <1421938175.13638.58.camel@x220>
Subject: Re: KVM: HAVE_KVM_ARCH_DIRTY_LOG_PROTECT?
From: Paul Bolle <pebolle@tiscali.nl>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Mario Smarduch <m.smarduch@samsung.com>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Gleb Natapov <gleb@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 22 Jan 2015 15:49:35 +0100
In-Reply-To: <54C101B9.1050804@redhat.com>
References: <1421918381.13638.43.camel@x220> <54C101B9.1050804@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jan 2015 14:49:36.0769 (UTC) FILETIME=[A46ED710:01D03652]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-22 at 14:57 +0100, Paolo Bonzini wrote:
> On 22/01/2015 10:19, Paul Bolle wrote:
> > Your commit ba0513b5b8ff ("KVM: Add generic support for dirty page
> > logging") is included in today's linux-next (ie, next-20150122). I
> > noticed because a script I use to check linux-next spotted a problem
> > with it.
> > 
> > That commit added a Kconfig symbol HAVE_KVM_ARCH_DIRTY_LOG_PROTECT. But
> > nothing in linux-next uses that symbol. Why was it added?
> 
> Ah, there are two Kconfig symbols added by mistake.
> 
> +config HAVE_KVM_ARCH_DIRTY_LOG_PROTECT
> + bool
> +
> +config KVM_GENERIC_DIRTYLOG_READ_PROTECT
> + bool

This one is actually used (so my 800 line perl monster didn't bark):
    $ git grep -n KVM_GENERIC_DIRTYLOG_READ_PROTECT next-20150122
    next-20150122:arch/arm/kvm/Kconfig:27:  select KVM_GENERIC_DIRTYLOG_READ_PROTECT
    next-20150122:arch/arm64/kvm/Kconfig:30:        select KVM_GENERIC_DIRTYLOG_READ_PROTECT
    next-20150122:arch/x86/kvm/Kconfig:42:  select KVM_GENERIC_DIRTYLOG_READ_PROTECT
    next-20150122:virt/kvm/Kconfig:47:config KVM_GENERIC_DIRTYLOG_READ_PROTECT
    next-20150122:virt/kvm/kvm_main.c:998:#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT

> Christoffer, can you fix that in kvm-arm and also the other mistake that
> Paul reported?

Thanks,


Paul  Bolle

