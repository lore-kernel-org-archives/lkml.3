Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab3GYKpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:45:01 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:40909 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab3GYKoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:44:54 -0400
Message-ID: <51F101A0.3050104@de.ibm.com>
Date: Thu, 25 Jul 2013 12:44:48 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [RFC][PATCH 0/2] s390/kvm: add kvm support for guest page hinting
 v2
References: <1374742461-29160-1-git-send-email-schwidefsky@de.ibm.com>
In-Reply-To: <1374742461-29160-1-git-send-email-schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072510-0342-0000-0000-000005AD666C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/07/13 10:54, Martin Schwidefsky wrote:
> v1->v2:
>  - found a way to simplify the common code patch
> 
> Linux on s390 as a guest under z/VM has been using the guest page
> hinting interface (alias collaborative memory management) for a long
> time. The full version with volatile states has been deemed to be too
> complicated (see the old discussion about guest page hinting e.g. on
> http://marc.info/?l=linux-mm&m=123816662017742&w=2).
> What is currently implemented for the guest is the unused and stable
> states to mark unallocated pages as freely available to the host.
> This works just fine with z/VM as the host.
> 
> The two patches in this series implement the guest page hinting
> interface for the unused and stable states in the KVM host.
> Most of the code specific to s390 but there is a common memory
> management part as well, see patch #1.
> 
> The code is working stable now, from my point of view this is ready
> for prime-time.
> 
> Konstantin Weitz (2):
>   mm: add support for discard of unused ptes
>   s390/kvm: support collaborative memory management

Can you also add the patch from our tree that reset the usage states
on reboot (diag 308 subcode 3 and 4)?

