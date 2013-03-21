Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3CUVRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:17:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab3CUVRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:17:43 -0400
Date: Thu, 21 Mar 2013 23:17:36 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Kevin Hilman <khilman@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linaro-kernel@lists.linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "open list:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: allow host header to be included even for
 !CONFIG_KVM
Message-ID: <20130321211736.GI9382@redhat.com>
References: <1363306426-27209-1-git-send-email-khilman@linaro.org>
 <1363823921.25034.35@snotra>
 <20130321072955.GO3889@redhat.com>
 <87ppyshlq5.fsf@linaro.org>
 <1363891354.31522.17@snotra>
 <20130321191600.GG9382@redhat.com>
 <1363894393.31522.20@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363894393.31522.20@snotra>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 02:33:13PM -0500, Scott Wood wrote:
> On 03/21/2013 02:16:00 PM, Gleb Natapov wrote:
> >On Thu, Mar 21, 2013 at 01:42:34PM -0500, Scott Wood wrote:
> >> On 03/21/2013 09:27:14 AM, Kevin Hilman wrote:
> >> >Gleb Natapov <gleb@redhat.com> writes:
> >> >
> >> >> On Wed, Mar 20, 2013 at 06:58:41PM -0500, Scott Wood wrote:
> >> >>> Why can't the entirety kvm_host.h be included regardless of
> >> >>> CONFIG_KVM, just like most other feature-specific headers?  Why
> >> >>> can't the if/else just go around the functions that you want to
> >> >stub
> >> >>> out for non-KVM builds?
> >> >>>
> >> >> Kevin,
> >> >>
> >> >>  What compilation failure this patch fixes? I presume
> >something ARM
> >> >> related.
> >> >
> >> >Not specficially ARM related, but more context tracking related
> >since
> >> >kernel/context_tracking.c pulls in kvm_host.h, which attempts to
> >> >pull in
> >> ><asm/kvm*.h> which may not exist on some platforms.
> >> >
> >> >At least for ARM, KVM support was added in v3.9 so this patch can
> >> >probably be dropped since the non-KVM builds on ARM now work.
> >But any
> >> >platform without the <asm/kvm*.h> will still be broken when
> >trying to
> >> >build the context tracker.
> >>
> >> Maybe other platforms should get empty asm/kvm*.h files.  Is there
> >> anything from those files that the linux/kvm*.h headers need to
> >> build?
> >>
> >arch things. kvm_vcpu_arch, kvm_arch_memory_slot, kvm_arch etc.
> 
> Could define them as empty structs.
> 
Isn't is simpler for kernel/context_tracking.c to define empty
__guest_enter()/__guest_exit() if !CONFIG_KVM.

--
			Gleb.
