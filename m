Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380Ab3CUO1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:27:19 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46345 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758292Ab3CUO1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:27:18 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Scott Wood <scottwood@freescale.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linaro-kernel@lists.linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "open list\:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: allow host header to be included even for !CONFIG_KVM
References: <1363306426-27209-1-git-send-email-khilman@linaro.org>
	<1363823921.25034.35@snotra> <20130321072955.GO3889@redhat.com>
Date: Thu, 21 Mar 2013 07:27:14 -0700
In-Reply-To: <20130321072955.GO3889@redhat.com> (Gleb Natapov's message of
	"Thu, 21 Mar 2013 09:29:55 +0200")
Message-ID: <87ppyshlq5.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb Natapov <gleb@redhat.com> writes:

> On Wed, Mar 20, 2013 at 06:58:41PM -0500, Scott Wood wrote:
>> On 03/14/2013 07:13:46 PM, Kevin Hilman wrote:
>> >The new context tracking subsystem unconditionally includes kvm_host.h
>> >headers for the guest enter/exit macros.  This causes a compile
>> >failure when KVM is not enabled.
>> >
>> >Fix by adding an IS_ENABLED(CONFIG_KVM) check to kvm_host so it can
>> >be included/compiled even when KVM is not enabled.
>> >
>> >Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> >Signed-off-by: Kevin Hilman <khilman@linaro.org>
>> >---
>> >Applies on v3.9-rc2
>> >
>> > include/linux/kvm_host.h | 7 ++++++-
>> > 1 file changed, 6 insertions(+), 1 deletion(-)
>> 
>> This broke the PPC non-KVM build, which was relying on stub
>> functions in kvm_ppc.h, which relies on "struct vcpu" in kvm_host.h.
>> 
>> Why can't the entirety kvm_host.h be included regardless of
>> CONFIG_KVM, just like most other feature-specific headers?  Why
>> can't the if/else just go around the functions that you want to stub
>> out for non-KVM builds?
>> 
> Kevin,
>
>  What compilation failure this patch fixes? I presume something ARM
> related.

Not specficially ARM related, but more context tracking related since
kernel/context_tracking.c pulls in kvm_host.h, which attempts to pull in
<asm/kvm*.h> which may not exist on some platforms.

At least for ARM, KVM support was added in v3.9 so this patch can
probably be dropped since the non-KVM builds on ARM now work.  But any
platform without the <asm/kvm*.h> will still be broken when trying to
build the context tracker.

Kevin
