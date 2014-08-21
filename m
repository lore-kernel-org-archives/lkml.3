Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaHUQaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:30:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbaHUQau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:30:50 -0400
Message-ID: <53F61EAC.2000004@redhat.com>
Date: Thu, 21 Aug 2014 18:30:36 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: Re: [PATCH v3 0/7] Dynamic Pause Loop Exiting window.
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/08/2014 18:08, Radim Krčmář ha scritto:
> v2 -> v3:
>  * copy&paste frenzy [v3 4/7] (split modify_ple_window)
>  * commented update_ple_window_actual_max [v3 4/7]
>  * renamed shrinker to modifier [v3 4/7]
>  * removed an extraneous max(new, ple_window) [v3 4/7] (should have been in v2)
>  * changed tracepoint argument type, printing and macro abstractions [v3 5/7]
>  * renamed ple_t to ple_int [v3 6/7] (visible in modinfo)
>  * intelligent updates of ple_window [v3 7/7]
> 
> ---
> v1 -> v2:
>  * squashed [v1 4/9] and [v1 5/9] (clamping)
>  * dropped [v1 7/9] (CPP abstractions)
>  * merged core of [v1 9/9] into [v1 4/9] (automatic maximum)
>  * reworked kernel_param_ops: closer to pure int [v2 6/6]
>  * introduced ple_window_actual_max & reworked clamping [v2 4/6]
>  * added seqlock for parameter modifications [v2 6/6]
> 
> ---
> PLE does not scale in its current form.  When increasing VCPU count
> above 150, one can hit soft lockups because of runqueue lock contention.
> (Which says a lot about performance.)
> 
> The main reason is that kvm_ple_loop cycles through all VCPUs.
> Replacing it with a scalable solution would be ideal, but it has already
> been well optimized for various workloads, so this series tries to
> alleviate one different major problem while minimizing a chance of
> regressions: we have too many useless PLE exits.
> 
> Just increasing PLE window would help some cases, but it still spirals
> out of control.  By increasing the window after every PLE exit, we can
> limit the amount of useless ones, so we don't reach the state where CPUs
> spend 99% of the time waiting for a lock.
> 
> HP confirmed that this series prevents soft lockups and TSC sync errors
> on large guests.

Hi,

I'm not sure of the usefulness of patch 6, so I'm going to drop it.
I'll keep it in my local junkyard branch in case it's going to be useful
in some scenario I didn't think of.

Patch 7 can be easily rebased, so no need to repost (and I might even
squash it into patch 3, what do you think?).

Paolo
