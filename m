Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab3CUHha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:37:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422Ab3CUHh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:37:29 -0400
Date: Thu, 21 Mar 2013 09:29:55 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Kevin Hilman <khilman@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linaro-kernel@lists.linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "open list:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: allow host header to be included even for
 !CONFIG_KVM
Message-ID: <20130321072955.GO3889@redhat.com>
References: <1363306426-27209-1-git-send-email-khilman@linaro.org>
 <1363823921.25034.35@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363823921.25034.35@snotra>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 06:58:41PM -0500, Scott Wood wrote:
> On 03/14/2013 07:13:46 PM, Kevin Hilman wrote:
> >The new context tracking subsystem unconditionally includes kvm_host.h
> >headers for the guest enter/exit macros.  This causes a compile
> >failure when KVM is not enabled.
> >
> >Fix by adding an IS_ENABLED(CONFIG_KVM) check to kvm_host so it can
> >be included/compiled even when KVM is not enabled.
> >
> >Cc: Frederic Weisbecker <fweisbec@gmail.com>
> >Signed-off-by: Kevin Hilman <khilman@linaro.org>
> >---
> >Applies on v3.9-rc2
> >
> > include/linux/kvm_host.h | 7 ++++++-
> > 1 file changed, 6 insertions(+), 1 deletion(-)
> 
> This broke the PPC non-KVM build, which was relying on stub
> functions in kvm_ppc.h, which relies on "struct vcpu" in kvm_host.h.
> 
> Why can't the entirety kvm_host.h be included regardless of
> CONFIG_KVM, just like most other feature-specific headers?  Why
> can't the if/else just go around the functions that you want to stub
> out for non-KVM builds?
> 
Kevin,

 What compilation failure this patch fixes? I presume something ARM
related.

--
			Gleb.
