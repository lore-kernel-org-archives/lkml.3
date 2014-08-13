Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaHMUtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 16:49:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:41328 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbaHMUtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 16:49:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="372052707"
Message-ID: <53EBCF42.8040706@linux.intel.com>
Date: Wed, 13 Aug 2014 13:49:06 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Amos Kong <akong@redhat.com>,
        ricardo.neri-calderon@linux.intel.com, tytso@mit.edu,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio: rng: add derating factor for use by hwrng core
References: <87zjf88awc.fsf@rustcorp.com.au>
In-Reply-To: <87zjf88awc.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 12:09 PM, Rusty Russell wrote:
> The khwrngd thread is started when a hwrng device of sufficient
> quality is registered.  The virtio-rng device is backed by the
> hypervisor, and we trust the hypervisor to provide real entropy.
> 
> A malicious hypervisor is a scenario that's irrelevant -- such a setup
> is bound to cause all sorts of badness, and a compromised hwrng is not
> the biggest threat.
> 
> Given this, we are certain the quality of randomness we receive is
> perfectly trustworthy.  Hence, we use 100% for the factor, indicating
> maximum confidence in the source.
> 
> Signed-off-by: Amit Shah <amit.shah@redhat.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
> Pretty small and contained patch; would be great if it is picked up for
> 3.17.
> 
> v2: re-word commit msg
> 
> [Agreed, re-sending to Linus with SOB before jumping on plane]

Reviewed-by: H. Peter Anvin <hpa@linux.intel.com>

