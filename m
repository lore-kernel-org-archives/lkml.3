Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaHKWLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:11:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:50114 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbaHKWLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:11:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,844,1400050800"; 
   d="scan'208";a="467602175"
Message-ID: <53E93F77.9030305@linux.intel.com>
Date: Mon, 11 Aug 2014 15:11:03 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        kvm list <kvm@vger.kernel.org>, jgarzik@bitpay.com, duwe@lst.de,
        Amos Kong <akong@redhat.com>, ricardo.neri-calderon@linux.intel.com,
        tytso@mit.edu, herbert@gondor.apana.org.au
Subject: Re: [PATCH 1/1] virtio: rng: add derating factor for use by hwrng
 core
References: <6f2df652355d6e78da846d06e32489b7d9cdfcc2.1407782982.git.amit.shah@redhat.com>
In-Reply-To: <6f2df652355d6e78da846d06e32489b7d9cdfcc2.1407782982.git.amit.shah@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 11:49 AM, Amit Shah wrote:
> The khwrngd thread is started when a hwrng device of sufficient
> quality is registered.  The virtio-rng device is backed by the
> hypervisor, and we trust the hypervisor to provide real entropy.  A
> malicious hypervisor is a scenario that's ruled out, so we are certain
> the quality of randomness we receive is perfectly trustworthy.  Hence,
> we use 100% for the factor, indicating maximum confidence in the source.
> 
> Signed-off-by: Amit Shah <amit.shah@redhat.com>

It isn't "ruled out", it is just irrelevant: if the hypervisor is
malicious, the quality of your random number source is the least of your
problems.

	-hpa


