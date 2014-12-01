Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaLARij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:38:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbaLARii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:38:38 -0500
Message-ID: <547CA79A.10206@redhat.com>
Date: Mon, 01 Dec 2014 18:38:34 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org
Subject: Re: [PATCH 0/5] kvm: memslots lookup optimization
References: <1417454967-4465-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <1417454967-4465-1-git-send-email-imammedo@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/12/2014 18:29, Igor Mammedov wrote:
> Series speed-ups GFN to memslot lookup time by:
>  * introducing LRU cache, which improves looukup time for
>    same slot workload (typically boot time of Windows and Linux guest)
>  * switching to binary search for GFN to memslot lookup,
>    improving lookup time with large amount of memory slots
> 
> Igor Mammedov (5):
>   kvm: update_memslots: drop not needed check for the same number of
>     pages
>   kvm: update_memslots: drop not needed check for the same slot
>   kvm: search_memslots: add simple LRU memslot caching
>   kvm: change memslot sorting rule from size to GFN
>   kvm: optimize GFN to memslot lookup with large slots amount
> 
>  include/linux/kvm_host.h | 28 +++++++++++++++++++++++-----
>  virt/kvm/kvm_main.c      | 46 ++++++++++++++++++++++++++--------------------
>  2 files changed, 49 insertions(+), 25 deletions(-)
> 

Applied patches 1-3 for now, I'm not in the mood for proving that the
binary search is correct. :)

Paolo
